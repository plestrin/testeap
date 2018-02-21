#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <asm/uaccess.h>

extern int read_cr4_smep(void);
extern int read_cr4_smap(void);

extern void test_write(void* addr);

extern int has_tsx(void);

static ssize_t cr4_smep_read(struct file* filp, char* u_buffer, size_t max_lg, loff_t* offset){
	const char* result;
	size_t 		length = 2;

	if (*offset > 1){
		return 0;
	}

	if (read_cr4_smep()){
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

static struct file_operations cr4_smep_fops = {
	.owner 	= THIS_MODULE,
	.read 	= cr4_smep_read
};

static struct miscdevice cr4_smep_misc = {
	.minor 	= MISC_DYNAMIC_MINOR,
	.name 	= "cr4.smep",
	.fops 	= &cr4_smep_fops
};

static int status_cr4_smep;

static struct file_operations cr4_smap_fops = {
	.owner 	= THIS_MODULE,
	.read 	= cr4_smap_read
};

static struct miscdevice cr4_smap_misc = {
	.minor 	= MISC_DYNAMIC_MINOR,
	.name 	= "cr4.smap",
	.fops 	= &cr4_smap_fops
};

static int status_cr4_smap;

static struct file_operations smap_test_fops = {
	.owner 	= THIS_MODULE,
	.read 	= smap_test_read
};

static struct miscdevice smap_test_misc = {
	.minor 	= MISC_DYNAMIC_MINOR,
	.name 	= "smap_test",
	.fops 	= &smap_test_fops
};

static int status_smap_test;

static int tsx;

static int __init smap_mod_init(void){
	status_cr4_smep = misc_register(&cr4_smep_misc);
	status_cr4_smap = misc_register(&cr4_smap_misc);

	tsx = has_tsx();

	if (tsx){
		status_smap_test = misc_register(&smap_test_misc);
	}
	else{
		status_smap_test = -1;
	}

	return 0;
}

static void __exit smap_mod_fini(void){
	if (!status_cr4_smep){
		misc_deregister(&cr4_smep_misc);
	}
	if (!status_cr4_smap){
		misc_deregister(&cr4_smap_misc);
	}
	if (!status_smap_test){
		misc_deregister(&smap_test_misc);
	}
}

module_init(smap_mod_init);
module_exit(smap_mod_fini);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Read the SMAP bit in CR4");
