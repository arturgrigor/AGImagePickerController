//
//  AGViewController.h
//  AGImagePickerController Demo
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGImagePickerController.h"

@interface AGViewController : UIViewController<AGImagePickerControllerDelegate>
{
    NSMutableArray *selectedPhotos;
}

- (IBAction)openAction:(id)sender;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@end
