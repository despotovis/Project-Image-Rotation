#include <linux/cdev.h>
#include <linux/kdev_t.h>
#include <linux/uaccess.h>
#include <linux/errno.h>
#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/string.h>
#include <linux/of.h>

#include <linux/mm.h>              //za memorijsko mapiranje
#include <linux/io.h>              //iowrite ioread
#include <linux/slab.h>            //kmalloc kfree
#include <linux/platform_device.h> //platform driver
#include <linux/of.h>              //of match table
#include <linux/ioport.h>          //ioremap

#include <linux/semaphore.h>

#define BUFF_SIZE 100
#define BRAM_SIZE_ROTATED 7056
#define BRAM_SIZE_UNROTATED 3600

MODULE_AUTHOR("STIPE I PJESAK");
MODULE_DESCRIPTION("Driver for Image Rotatation IP.");
MODULE_LICENSE("Dual BSD/GPL");

int bram_r_rotated[BRAM_SIZE_ROTATED];
int bram_g_rotated[BRAM_SIZE_ROTATED];
int bram_b_rotated[BRAM_SIZE_ROTATED];

int bram_r_unrotated[BRAM_SIZE_UNROTATED];
int bram_g_unrotated[BRAM_SIZE_UNROTATED];
int bram_b_unrotated[BRAM_SIZE_UNROTATED];


int cntr =0;
int cntg =0;
int cntb =0;

int cntrun =0;
int cntgun =0;
int cntbun =0;

int endReadru = 0;
int endReadbu = 0;
int endReadgu = 0;

int endReadrr = 0;
int endReadbr = 0;
int endReadgr = 0;

dev_t my_dev_id;

static struct class *my_class;
static struct device *my_device;
static struct cdev *my_cdev;



static int ROT_open(struct inode *pinode, struct file *pfile);
static int ROT_close(struct inode *pinode, struct file *pfile);
static ssize_t ROT_read(struct file *pfile, char __user *buf, size_t length, loff_t *offset);
static ssize_t ROT_write(struct file *pfile, const char __user *buf, size_t length, loff_t *offset);

static int __init ROT_init(void);
static void __exit ROT_exit(void);


struct file_operations my_fops =
    {
        .owner = THIS_MODULE,
        .read = ROT_read,
        .write = ROT_write,
        .open = ROT_open,
	.release = ROT_close
	
    };

ssize_t ROT_read(struct file *pfile, char __user *buf, size_t length, loff_t *offset)
{
  
    int ret, pos = 0;
    char buff[BUFF_SIZE];
    int len, value;
    int minor = MINOR(pfile->f_inode->i_rdev);
    if (endReadru == 1)
    {
        endReadru = 0;
	cntrun = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
      if (endReadgu == 1)
    {
        endReadgu = 0;
	cntgun = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
        if (endReadbu == 1)
    {
        endReadbu = 0;
	cntbun = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
	  if (endReadrr == 1)
    {
        endReadrr = 0;
	cntr = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
	    if (endReadgr == 1)
    {
        endReadgr = 0;
	cntg =0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
	      if (endReadbr == 1)
    {
        endReadbr = 0;
	cntb = 0;
	printk(KERN_INFO "Succesfully read from file\n");
        return 0;
    }
    switch (minor)
      {
	
      case 0: // ip
       
	
        break;
    
      case 1: // bram_r_unrotated
      /*if (down_interruptible(&bramResSem))
        {
	printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	
	return -ERESTARTSYS;
	}*/
	
	value = bram_r_unrotated[cntrun];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
	
        
        
	if (ret)
      {
	return -EFAULT;
      }
	
	cntrun++;
	if (cntrun == BRAM_SIZE_UNROTATED-1)
	  {
	endReadru = 1;
	cntrun = 0;
	  }
	// up(&bramResSem);
	break;
	
      case 2: // bram_g_unrotated
	/*if (down_interruptible(&bramResSem))
	  {
	  printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	  
	  return -ERESTARTSYS;
	  }*/
	
	value = bram_g_unrotated[cntgun];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
	
	
	
	if (ret)
	  {
	    return -EFAULT;
	  }
	
	cntgun++;
	if (cntgun == BRAM_SIZE_UNROTATED-1)
	  {
	    endReadgu = 1;
	    cntgun = 0;
	  }
	// up(&bramResSem);
	break;
	
      case 3://bram_b_unrotated
	/*if (down_interruptible(&bramResSem))
	  {
	  printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	  
	  return -ERESTARTSYS;
	  }*/
	
	value = bram_b_unrotated[cntbun];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
	
	
	
	if (ret)
	  {
	    return -EFAULT;
	  }
	
	cntbun++;
	if (cntbun == BRAM_SIZE_UNROTATED-1)
	  {
	    endReadbu = 1;
	    cntbun = 0;
	  }
	// up(&bramResSem);
	break;
	
	
      case 4://bram_r_rotated
	
	/*if (down_interruptible(&bramResSem))
	  {
	  printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	  
	  return -ERESTARTSYS;
	  }*/
	
	value = bram_r_rotated[cntr];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
	
	
	
	if (ret)
	  {
	    return -EFAULT;
	  }
	
	cntr++;
	if (cntr == BRAM_SIZE_ROTATED-1)
	  {
	    endReadrr = 1;
	    cntr = 0;
	  }
	// up(&bramResSem);
	break;
      case 5://bram_g_rotated
	
	/*if (down_interruptible(&bramResSem))
	  {
	  printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	  
	  return -ERESTARTSYS;
	  }*/
	
	value = bram_g_rotated[cntg];
	len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	ret = copy_to_user(buf, buff, len);
	//printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
	
	
	
	if (ret)
	  {
	   return -EFAULT;
	 }
	
       cntg++;
       if (cntg == BRAM_SIZE_ROTATED-1)
	 {
	   endReadgr = 1;
	   cntg = 0;
	 }
       // up(&bramResSem);
       break;
       
      case 6://bram_b_rotated
	 /*if (down_interruptible(&bramResSem))
	   {
	   printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	   
	   return -ERESTARTSYS;
	   }*/
	 
	 value = bram_b_rotated[cntb];
	 len = scnprintf(buff, BUFF_SIZE, "%d\n", value);
	 ret = copy_to_user(buf, buff, len);
	 //printk(KERN_INFO "Bram RES:%d.\n", bramResReadCounter);
	 
	 
	 
	 if (ret)
	   {
	     return -EFAULT;
	   }
	 
	 cntb++;
	 if (cntb == BRAM_SIZE_ROTATED-1)
	   {
	     endReadbr = 1;
	     cntb = 0;
	   }
	 // up(&bramResSem);
	 break;
      default:
	   printk(KERN_INFO "somethnig went wrong\n");
      }
	   
	   return len;
}
ssize_t ROT_write(struct file *pfile, const char __user *buf, size_t length, loff_t *offset)
{
  
  char buff[BUFF_SIZE];
  int minor = MINOR(pfile->f_inode->i_rdev);
  int cx=0;
  int cy=0;
  int midx =0;
  int midy =0;
  int sc = 0;
  int cc = 0;
  int new_height = 0;
  int new_width = 0;
  int old_height = 0;
  int old_width = 0;
  int lri = 0;
  int start = 0;
  int ret = 0;
  int rpos = 0;
  int gpos = 0;
  int bpos = 0;
  int x = 0;
  int y = 0;
  
  int pixel_r_val = 0;
  int pixel_g_val = 0;
  int pixel_b_val = 0;
  
  
  ret = copy_from_user(buff, buf, length);
  
  if (ret)
    {
      printk("copy from user failed \n");
      return -EFAULT;
    }
  buff[length] = '\0';
  
  switch (minor)
    {
      
    case 0: // IP
      /* if (down_interruptible(&ipMem))
	 {
	 
	 printk(KERN_INFO "Bram IMG: semaphore: access to IP denied.\n");
	 return -ERESTARTSYS;
	 }
	 if (down_interruptible(&bramImgSem))
	 {
	 
	 printk(KERN_INFO "Bram IMG: semaphore: access to memory denied.\n");
	 return -ERESTARTSYS;
	 }
	 if (down_interruptible(&bramResSem))
	 {
	 printk(KERN_INFO "Bram RES: semaphore: access to memory denied.\n");
	 
	 return -ERESTARTSYS;
        }
        sscanf(buff, "%d", &start);
      */
      sscanf(buff, "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n", &start , &lri , &cx ,&cy ,&midx ,&midy , &cc , &sc , &new_height , &new_width , &old_height , &old_width );
      //printk(KERN_WARNING "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n", start , lri , cx ,cy ,midx ,midy , cc , sc , new_height , new_width , old_height , old_width);
      if (ret != -EINVAL)
        {
	  if (start == 0)
            {
	      printk(KERN_WARNING "IP: start must be 1 to start \n");
            }
	  else
            {
	      
	      for (int row = 0; row < new_height ; row++){
		
		for (int col = 0; col < new_width ; col++){
		  
		  if (lri == 1){
		    x  = ((row-midx ) * cc - (col-midy) * sc + cx * 16384)/16384;
		    y  = ((col-midy ) * cc + (row-midx) * sc + cy * 16384)/16384;
		    
		    printk ( KERN_WARNING "%d , %d ",x,y);
			  }
		  
		  if (lri == 0){
		    
		    x  = ((row-midx ) * cc + (col-midy) * sc +cx * 16384 )/16384;
		    y  = ((col-midy ) * cc - (row-midx) * sc +cy * 16384 )/16384;
			
		    printk ( KERN_WARNING "%d , %d ",x,y);
		  }
		  if (x >= 0 && x< old_height && y >= 0 && y< old_width)
		     {
		       bram_r_rotated[row*new_height + col] =  bram_r_unrotated[x*old_height + y];;
		       bram_g_rotated[row*new_height + col] =  bram_g_unrotated[x*old_height + y];;
		       bram_b_rotated[row*new_height + col] =  bram_b_unrotated[x*old_height + y];;
		       
		     }
		   
		   
		 }
		 
	       }
	    }
	}
	       //up(&ipMem);
	       //up(&bramImgSem);
	       //up(&bramResSem);
	       
	       break;
		 
      case 1: // bram_r_unrotated
      /* if (down_interruptible(&bramImgSem))
        {
            printk(KERN_INFO "Bram IMG: semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }*/
        printk(KERN_WARNING "ROT_write: about to write to bram_r_unrotated \n");
        sscanf(buff, "(%d,%d)", &rpos, &pixel_r_val);
        printk(KERN_WARNING "CONV_write: bram pos: %ld, pixel value: %d\n", rpos, pixel_r_val);
        if (pixel_r_val > 255)
        {
            printk(KERN_WARNING "BRAM_R_UNROTATED: Pixel value cannot be larger than 255 \n");
        }
        else if (pixel_r_val < 0)
        {
            printk(KERN_WARNING "BRAM_R_UNROTATED: Pixel value cannot be negative \n");
        }
        else if (rpos < 0)
        {
            printk(KERN_WARNING "BRAM_R_UNROTATED: Pixel adr cannot be negative \n");
        }
        else if (rpos > BRAM_SIZE_UNROTATED - 1)
        {
            printk(KERN_WARNING "BRAM_R_UNROTATED: Pixel adr cannot be larger than bram size \n");
        }
        else
        {
            // printk(KERN_WARNING "CONV_write: about to write to %p, brma pos: %ld, pixel value: %d\n", img->base_addr, bramPos, pixelVal);
            //pos = bramPos * 4;
            bram_r_unrotated[rpos] = pixel_r_val;
            // iowrite32((u32)pixelVal, img->base_addr);
            // iowrite32((u32)bramPos, img->base_addr + 8);
        }
        //up(&bramImgSem);
        break;

    case 2: // bram_g_unrotated
     
            /* if (down_interruptible(&bramImgSem))
        {
            printk(KERN_INFO "Bram IMG: semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }*/
        printk(KERN_WARNING "ROT_write: about to write to bram_b_unrotated \n");
        sscanf(buff, "(%d,%d)", &gpos, &pixel_g_val);
        printk(KERN_WARNING "ROT_write: bram pos: %ld, pixel value: %d\n", gpos, pixel_g_val);
        if (pixel_g_val > 255)
        {
            printk(KERN_WARNING "BRAM_G_UNROTATED: Pixel value cannot be larger than 255 \n");
        }
        else if (pixel_g_val < 0)
        {
            printk(KERN_WARNING "BRAM_G_UNROTATED: Pixel value cannot be negative \n");
        }
        else if (gpos < 0)
        {
            printk(KERN_WARNING "BRAM_G_UNROTATED: Pixel adr cannot be negative \n");
        }
        else if (gpos > BRAM_SIZE_UNROTATED  - 1)
        {
            printk(KERN_WARNING "BRAM_G_UNROTATED: Pixel adr cannot be larger than bram size \n");
        }
        else
        {
          
            bram_g_unrotated[gpos] = pixel_g_val;
	}
	break;
    
        //up(&bramImgSem);
    case 3://bram_b_unrotated
            /* if (down_interruptible(&bramImgSem))
        {
            printk(KERN_INFO "Bram IMG: semaphore: access to memory denied.\n");
            return -ERESTARTSYS;
        }*/
        printk(KERN_WARNING "ROT_write: about to write to bram_b_unrotated \n");
        sscanf(buff, "(%d,%d)", &bpos, &pixel_b_val);
        printk(KERN_WARNING "ROT_write:brma pos: %ld, pixel value: %d\n", bpos, pixel_b_val);
        if (pixel_b_val > 255)
        {
            printk(KERN_WARNING "BRAM_B_UNROTATED: Pixel value cannot be larger than 255 \n");
        }
        else if (pixel_b_val < 0)
        {
            printk(KERN_WARNING "BRAM_B_UNROTATED: Pixel value cannot be negative \n");
        }
        else if (bpos < 0)
        {
            printk(KERN_WARNING "BRAM_B_UNROTATED: Pixel adr cannot be negative \n");
        }
        else if (bpos > BRAM_SIZE_UNROTATED  - 1)
        {
            printk(KERN_WARNING "BRAM_B_UNROTATED: Pixel adr cannot be larger than bram size \n");
        }
        else
        {
            
            
            bram_b_unrotated[bpos] = pixel_b_val;
          
        }
        //up(&bramImgSem);
        break;


      
    case 4://bram_r_rotated
      printk(KERN_WARNING "CONV_write: cannot write to   BRAM_R_ROTATED \n");
      break;
      
      
      
      
    case 5://bram_g_rotated
      printk(KERN_WARNING "CONV_write: cannot write to   BRAM_G_ROTATED \n");
      break;
      
	
	
    case 6://bram_b_rotated
      printk(KERN_WARNING "CONV_write: cannot write to   BRAM_B_ROTATED \n");
        break;


	
        default:
        printk(KERN_INFO "somethnig went wrong\n");
    }

    return length;
}



static int __init ROT_init(void)
{
  //sema_init(&bramImgSem, 1);
  //sema_init(&bramResSem, 1);
  //sema_init(&ipMem, 1);

    int num_of_minors = 6;
    int ret = 0;
    ret = alloc_chrdev_region(&my_dev_id, 0, num_of_minors, "ROT_REGION");
    if (ret != 0)
    {

        printk(KERN_ERR "Failed to register char device\n");
        return ret;
    }
    printk(KERN_INFO "Char device region allocated\n");

    my_class = class_create(THIS_MODULE, "ROT_class");
    if (my_class == NULL)
    {
        printk(KERN_ERR "Failed to create class\n");
        goto fail_0;
    }
    printk(KERN_INFO "Class created\n");

    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 0), NULL, "rot_ip");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device IP\n");
        goto fail_1;
    }
    printk(KERN_INFO "created IP\n");
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 1), NULL, "bram_r_unrotated");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device BRAM_R_UNROTATED\n");
        goto fail_1;
    }
    printk(KERN_INFO "created BRAM_R_UNROTATED\n");
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 2), NULL, "bram_g_unrotated");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device BRAM_G_UNRORATED\n");
        goto fail_1;
    }
    printk(KERN_INFO "created BRAM_G_UNROTATED\n");
      my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 3), NULL, "bram_b_unrotated");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device BRAM_B_UNROTATED\n");
        goto fail_1;
    }
    printk(KERN_INFO "created BRAM_B_UNROTATED\n");
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 4), NULL, "bram_r_rotated");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device BRAM_R_ROTATED\n");
        goto fail_1;
    }
    printk(KERN_INFO "created BRAM_R_ROTATED\n");
      my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 5), NULL, "bram_g_rotated");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device BRAM_G_ROTATED\n");
        goto fail_1;
    }
    printk(KERN_INFO "created BRAM_G_RORATED\n");
    my_device = device_create(my_class, NULL, MKDEV(MAJOR(my_dev_id), 6), NULL, "bram_b_rotated");
    if (my_device == NULL)
    {
        printk(KERN_ERR "failed to create device BRAM_B_ROTATED\n");
        goto fail_1;
    }
    printk(KERN_INFO "created BRAM_B_RORATED\n");


    my_cdev = cdev_alloc();
    my_cdev->ops = &my_fops;
    my_cdev->owner = THIS_MODULE;
    ret = cdev_add(my_cdev, my_dev_id, 7);
    if (ret)
    {
        printk(KERN_ERR "Failde to add cdev \n");
        goto fail_2;
    }
    printk(KERN_INFO "cdev_added\n");
    printk(KERN_INFO "Hello from ROT_driver\n");

    return 0;

fail_2:
    device_destroy(my_class, my_dev_id);
fail_1:
    class_destroy(my_class);
fail_0:
    unregister_chrdev_region(my_dev_id, 1);
    return -1;
}

int ROT_open(struct inode *pinode, struct file *pfile)
{

    printk(KERN_INFO "Succesfully opened file\n");
    return 0;
}

int ROT_close(struct inode *pinode, struct file *pfile)
{

    printk(KERN_INFO "Succesfully closed file\n");
    return 0;
}


static void __exit ROT_exit(void)
{
    printk(KERN_ALERT "ROT_exit: rmmod called\n");
    cdev_del(my_cdev);
    printk(KERN_ALERT "ROT_exit: cdev_del done\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 0));
    printk(KERN_INFO "ROT_exit: device destroy 0\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 1));
    printk(KERN_INFO "ROT_exit: device destroy 1\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 2));
    printk(KERN_INFO "ROT_exit: device destroy 2\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id),3));
    printk(KERN_INFO "ROT_exit: device destroy 3\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 4));
    printk(KERN_INFO "ROT_exit: device destroy 4\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 5));
    printk(KERN_INFO "ROT_exit: device destroy 5\n");
    device_destroy(my_class, MKDEV(MAJOR(my_dev_id), 6));
    printk(KERN_INFO "ROT_exit: device destroy 6\n");
    class_destroy(my_class);
    printk(KERN_INFO "ROT_exit: class destroy \n");
    unregister_chrdev_region(my_dev_id, 7);
    printk(KERN_ALERT "Goodbye from CONV_driver\n");
}

module_init(ROT_init);
module_exit(ROT_exit);
