//
//  AGIPCGridCell.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import <UIKit/UIKit.h>

#import "AGImagePickerController.h"

@interface AGIPCGridCell : UITableViewCell

@property (strong) NSArray *items;
// change strong to weak, springox(20140422)
@property (ag_weak) AGImagePickerController *imagePickerController;

- (id)initWithImagePickerController:(AGImagePickerController *)imagePickerController items:(NSArray *)items andReuseIdentifier:(NSString *)identifier;

@end
