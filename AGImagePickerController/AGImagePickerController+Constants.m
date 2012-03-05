//
//  AGImagePickerController+Constants.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 28.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import "AGImagePickerController+Constants.h"

@implementation AGImagePickerController (Constants)

+ (NSUInteger)numberOfItemsPerRow
{
    NSUInteger numberOfItemsPerRow = 0;
    
    if (IS_IPAD())
    {    
        if (UIInterfaceOrientationIsPortrait([AGImagePickerController currentInterfaceOrientation]))
        {    
            numberOfItemsPerRow = AGIPC_ITEMS_PER_ROW_IPAD_PORTRAIT;   
        } else
        {
            numberOfItemsPerRow = AGIPC_ITEMS_PER_ROW_IPAD_LANDSCAPE;
        }
    } else
    {    
        if (UIInterfaceOrientationIsPortrait([AGImagePickerController currentInterfaceOrientation]))
        {    
            numberOfItemsPerRow = AGIPC_ITEMS_PER_ROW_IPHONE_PORTRAIT;
            
        } else
        {
            numberOfItemsPerRow = AGIPC_ITEMS_PER_ROW_IPHONE_LANDSCAPE;    
        }   
    }
    return numberOfItemsPerRow;
}

#pragma mark - Item

+ (CGSize)itemSize
{
    return CGSizeMake(AGIPC_ITEM_WIDTH, AGIPC_ITEM_HEIGHT);
}

+ (CGRect)itemRect
{
    CGPoint topLeftPoint = [AGImagePickerController itemTopLeftPoint];
    CGSize size = [AGImagePickerController itemSize];
    
    return CGRectMake(topLeftPoint.x, topLeftPoint.y, size.width, size.height);
}

+ (CGPoint)itemTopLeftPoint
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = bounds.size.width;
    
    if (UIInterfaceOrientationIsLandscape([AGImagePickerController currentInterfaceOrientation])) {
        width = bounds.size.height;
    }
    
    CGFloat x = 0, y = 0;
    
    x = (width - ([AGImagePickerController numberOfItemsPerRow] * [AGImagePickerController itemSize].width)) / ([AGImagePickerController numberOfItemsPerRow] + 1);
    y = x;
    return CGPointMake(x, y);
}

#pragma mark - Checkmark

+ (CGPoint)checkmarkBottomRightPoint
{
    return CGPointMake(AGIPC_CHECKMARK_RIGHT_MARGIN, AGIPC_CHECKMARK_BOTTOM_MARGIN);
}

+ (CGSize)checkmarkSize
{
    return CGSizeMake(AGIPC_CHECKMARK_WIDTH, AGIPC_CHECKMARK_HEIGHT);
}

+ (CGRect)checkmarkRect
{
    CGPoint bottomRightPoint = [AGImagePickerController checkmarkBottomRightPoint];
    CGSize size = [AGImagePickerController checkmarkSize];
    
    return CGRectMake(bottomRightPoint.x, bottomRightPoint.y, size.width, size.height);
}

+ (CGRect)checkmarkFrameUsingItemFrame:(CGRect)frame
{
    CGRect checkmarkRect = [AGImagePickerController checkmarkRect];
    
    return CGRectMake(
                          frame.size.width - checkmarkRect.size.width - checkmarkRect.origin.x, 
                          frame.size.height - checkmarkRect.size.height - checkmarkRect.origin.y, 
                          checkmarkRect.size.width, 
                          checkmarkRect.size.height
                      );
}

@end
