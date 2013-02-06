//
//  AGImagePickerController+Helper.h
//  AGImagePickerController Demo
//
//  Created by Artur Grigor on 06.02.2013.
//  Copyright (c) 2013 Artur Grigor. All rights reserved.
//

#import "AGImagePickerController.h"

@interface AGImagePickerController (Helper)

//
//  Configuring Rows
//
- (NSUInteger)defaultNumberOfItemsPerRow;
- (NSUInteger)numberOfItemsPerRow;

//
//  Configuring Selections
//
- (AGImagePickerControllerSelectionBehaviorType)selectionBehaviorInSingleSelectionMode;

//
//  Appearance Configuration
//
- (BOOL)shouldDisplaySelectionInformation;
- (BOOL)shouldShowToolbarForManagingTheSelection;

//
//  Others
//
- (AGDeviceType)deviceType;

//
//  Drawing: Item
//
- (CGPoint)itemTopLeftPoint;
- (CGRect)itemRect;

//
//  Drawing: Checkmark
//
- (CGRect)checkmarkFrameUsingItemFrame:(CGRect)frame;

@end

@interface NSInvocation (Addon)

+ (id)invocationWithProtocol:(Protocol *)targetProtocol selector:(SEL)selector andRequiredFlag:(BOOL)isMethodRequired;

@end