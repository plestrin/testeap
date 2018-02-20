#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <asm/uaccess.h>

extern int read_cr4_smap(void);

extern void test_write(void* addr);

static ssize_t cr4_smap_read(struct file* filp, char* u_buffer, size_t max_lg, loff_t* offset){
	const char* result;
	size_t 		length = 2;

	if (*offset > 1){
		return 0;
	}

	if (read_cr4_smap()){
		result = "1\n";
	}
	else{
		result = "0\n";
	}

	if (length > max_lg){
		length = max_lg;
	}

	if (copy_to_user(u_buffer, result + *offset, length)){
		return -EFAULT;
	}

	*offset += length;

	return length;
}

static ssize_t smap_test_read(struct file* filp, char* u_buffer, size_t max_lg, loff_t* offset){
	size_t length = 2;

	if (*offset > 1){
		return 0;
	}

	if (length > max_lg){
		length = max_lg;
	}

	if (copy_to_user(u_buffer, "0\n" + *offset, length)){
		return -EFAULT;
	}

	if (!*offset){
		test_write(u_buffer);
	}

	*offset += length;

	return length;
}

static struct file_operations cr4_smap_fops = {
	.owner 	= THIS_MODULE,
	.read 	= cr4_smap_read
};

static struct miscdevice cr4_smap_misc = {
	.minor 	= MISC_DYNAMIC_MINOR,
	.name 	= "cr4.smap",
	.fops 	= &cr4_smap_fops
};

static struct file_operations smap_test_fops = {
	.owner 	= THIS_MODULE,
	.read 	= smap_test_read
};

static struct miscdevice smap_test_misc = {
	.minor 	= MISC_DYNAMIC_MINOR,
	.name 	= "smap_test",
	.fops 	= &smap_test_fops
};

static int __init smap_mod_init(void){
	int status;

	if ((status = misc_register(&cr4_smap_misc))){
		return status;
	}

	if ((status = misc_register(&smap_test_misc))){
		misc_deregister(&cr4_smap_misc);
	}

	return status;
}

static void __exit smap_mod_fini(void){
	misc_deregister(&cr4_smap_misc);
	misc_deregister(&smap_test_misc);
}

module_init(smap_mod_init);
module_exit(smap_mod_fini);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Read the SMAP bit in CR4");
