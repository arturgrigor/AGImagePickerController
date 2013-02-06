//
//  AGImagePickerController+Helper.m
//  AGImagePickerController Demo
//
//  Created by Artur Grigor on 06.02.2013.
//  Copyright (c) 2013 Artur Grigor. All rights reserved.
//

#import "AGImagePickerController.h"
#import "AGImagePickerController+Helper.h"

#import <objc/runtime.h>

@implementation AGImagePickerController (Helper)

#pragma mark - Configuring Rows

- (NSUInteger)numberOfItemsPerRow
{
    if (_pickerFlags.delegateNumberOfItemsPerRowForDevice)
    {
        AGDeviceType deviceType = self.deviceType;
        UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
        
        SEL selector = @selector(agImagePickerController:numberOfItemsPerRowForDevice:andInterfaceOrientation:);
        Protocol *protocol = @protocol(AGImagePickerControllerDelegate);
        
        NSInvocation *invocation = [NSInvocation invocationWithProtocol:protocol selector:selector andRequiredFlag:NO];
        [invocation setSelector:selector];
        [invocation setArgument:(__bridge void *)(self) atIndex:2];
        [invocation setArgument:&deviceType atIndex:3];
        [invocation setArgument:&interfaceOrientation atIndex:4];
        [invocation invokeWithTarget:self.delegate];
        
        if (invocation)
        {
            NSUInteger length = [[invocation methodSignature] methodReturnLength];
            void *buffer = malloc(length);
            [invocation getReturnValue:buffer];
            NSUInteger ret = *(NSUInteger *)buffer;
            free(buffer);
            
            return ret;
        } else
            return self.defaultNumberOfItemsPerRow;
    } else {
        return self.defaultNumberOfItemsPerRow;
    }
}

- (NSUInteger)defaultNumberOfItemsPerRow
{
    NSUInteger numberOfItemsPerRow = 0;
    
    if (IS_IPAD())
    {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            numberOfItemsPerRow = AGIPC_ITEMS_PER_ROW_IPAD_PORTRAIT;
        } else
        {
            numberOfItemsPerRow = AGIPC_ITEMS_PER_ROW_IPAD_LANDSCAPE;
        }
    } else
    {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            numberOfItemsPerRow = AGIPC_ITEMS_PER_ROW_IPHONE_PORTRAIT;
            
        } else
        {
            numberOfItemsPerRow = AGIPC_ITEMS_PER_ROW_IPHONE_LANDSCAPE;
        }
    }
    
    return numberOfItemsPerRow;
}

#pragma mark - Configuring Selections

- (AGImagePickerControllerSelectionBehaviorType)selectionBehaviorInSingleSelectionMode
{
    if (_pickerFlags.delegateSelectionBehaviorInSingleSelectionMode)
    {
        SEL selector = @selector(selectionBehaviorInSingleSelectionModeForAGImagePickerController:);
        Protocol *protocol = @protocol(AGImagePickerControllerDelegate);
        
        NSInvocation *invocation = [NSInvocation invocationWithProtocol:protocol selector:selector andRequiredFlag:NO];
        [invocation setSelector:selector];
        [invocation setArgument:(__bridge void *)(self) atIndex:2];
        [invocation invokeWithTarget:self.delegate];
        
        if (invocation)
        {
            NSUInteger length = [[invocation methodSignature] methodReturnLength];
            void *buffer = malloc(length);
            [invocation getReturnValue:buffer];
            AGImagePickerControllerSelectionBehaviorType ret = *(AGImagePickerControllerSelectionBehaviorType *)buffer;
            free(buffer);
            
            return ret;
        } else
            return SELECTION_BEHAVIOR_IN_SINGLE_SELECTION_MODE;
    } else {
        return SELECTION_BEHAVIOR_IN_SINGLE_SELECTION_MODE;
    }
}

#pragma mark - Appearance Configuration

- (BOOL)shouldDisplaySelectionInformation
{
    if (_pickerFlags.delegateShouldDisplaySelectionInformationInSelectionMode)
    {
        AGImagePickerControllerSelectionMode selectionMode = self.selectionMode;
        
        SEL selector = @selector(agImagePickerController:shouldDisplaySelectionInformationInSelectionMode:);
        Protocol *protocol = @protocol(AGImagePickerControllerDelegate);
        
        NSInvocation *invocation = [NSInvocation invocationWithProtocol:protocol selector:selector andRequiredFlag:NO];
        [invocation setSelector:selector];
        [invocation setArgument:(__bridge void *)(self) atIndex:2];
        [invocation setArgument:&selectionMode atIndex:3];
        [invocation invokeWithTarget:self.delegate];
        
        if (invocation)
        {
            NSUInteger length = [[invocation methodSignature] methodReturnLength];
            void *buffer = malloc(length);
            [invocation getReturnValue:buffer];
            BOOL ret = *(BOOL *)buffer;
            free(buffer);
            
            return ret;
        } else
            return SHOULD_DISPLAY_SELECTION_INFO;
    } else {
        return SHOULD_DISPLAY_SELECTION_INFO;
    }
}

- (BOOL)shouldShowToolbarForManagingTheSelection
{
    if (_pickerFlags.delegateShouldShowToolbarForManagingTheSelectionInSelectionMode)
    {
        AGImagePickerControllerSelectionMode selectionMode = self.selectionMode;
        
        SEL selector = @selector(agImagePickerController:shouldShowToolbarForManagingTheSelectionInSelectionMode:);
        Protocol *protocol = @protocol(AGImagePickerControllerDelegate);
        
        NSInvocation *invocation = [NSInvocation invocationWithProtocol:protocol selector:selector andRequiredFlag:NO];
        [invocation setSelector:selector];
        [invocation setArgument:(__bridge void *)(self) atIndex:2];
        [invocation setArgument:&selectionMode atIndex:3];
        [invocation invokeWithTarget:self.delegate];
        
        if (invocation)
        {
            NSUInteger length = [[invocation methodSignature] methodReturnLength];
            void *buffer = malloc(length);
            [invocation getReturnValue:buffer];
            BOOL ret = *(BOOL *)buffer;
            free(buffer);
            
            return ret;
        } else
            return SHOULD_SHOW_TOOLBAR_FOR_MANAGING_THE_SELECTION;
    } else {
        return SHOULD_SHOW_TOOLBAR_FOR_MANAGING_THE_SELECTION;
    }
}

#pragma mark - Others

- (AGDeviceType)deviceType
{
    return (IS_IPAD() ? AGDeviceTypeiPad : AGDeviceTypeiPhone);
}

#pragma mark - Drawing: Item

- (CGRect)itemRect
{
    CGPoint topLeftPoint = self.itemTopLeftPoint;
    CGSize size = AGIPC_ITEM_SIZE;
    
    return CGRectMake(topLeftPoint.x, topLeftPoint.y, size.width, size.height);
}

- (CGPoint)itemTopLeftPoint
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = bounds.size.width;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        width = bounds.size.height;
    }
    
    CGFloat x = 0, y = 0;
    
    x = (width - (self.numberOfItemsPerRow * AGIPC_ITEM_SIZE.width)) / (self.numberOfItemsPerRow + 1);
    y = x;
    return CGPointMake(x, y);
}

#pragma mark - Drawing: Checkmark

- (CGRect)checkmarkFrameUsingItemFrame:(CGRect)frame
{
    CGRect checkmarkRect = AGIPC_CHECKMARK_RECT;
    
    return CGRectMake(
                      frame.size.width - checkmarkRect.size.width - checkmarkRect.origin.x,
                      frame.size.height - checkmarkRect.size.height - checkmarkRect.origin.y,
                      checkmarkRect.size.width,
                      checkmarkRect.size.height
                      );
}

@end

@implementation NSInvocation (Addon)

#pragma mark - Invocation

+ (id)invocationWithProtocol:(Protocol *)targetProtocol selector:(SEL)selector andRequiredFlag:(BOOL)isMethodRequired
{
	struct objc_method_description desc;
	desc = protocol_getMethodDescription(targetProtocol, selector, isMethodRequired, YES);
	if (desc.name == NULL)
		return nil;
	
	NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:desc.types];
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
	[inv setSelector:selector];
	return inv;
}

@end
