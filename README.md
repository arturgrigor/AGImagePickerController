## AGImagePickerController

AGImagePickerController is a image picker controller that allows you to select multiple photos and can be used for all iOS devices.

![Screenshot](http://dl.dropbox.com/u/2387405/Screenshots/AGImagePickerController.png)

## Installation

Copy over the files from the AGImagePickerController folder to your project folder.

## Usage

Wherever you want to use AGImagePickerController, import the appropriate header file and initialize as follows:

``` objective-c
#import "AGImagePickerController.h"
```

### Basic

``` objective-c
AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {

        if (error == nil)
        {
            NSLog(@"User has cancelled.");
            [self dismissModalViewControllerAnimated:YES];
        } else
        {     
            NSLog(@"Error: %@", error);
        
            // Wait for the view controller to show first and hide it after that
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissModalViewControllerAnimated:YES];
            });
        }
            
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    } andSuccessBlock:^(NSArray *info) {
        NSLog(@"Info: %@", info);
        [self dismissModalViewControllerAnimated:YES];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
    
    [self presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
```

## Contact

- [GitHub](http://github.com/arturgrigor)
- [Twitter](http://twitter.com/arturgrigor)

Let me know if you're using or enjoying this product.
