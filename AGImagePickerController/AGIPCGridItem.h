//
//  AGIPCGridItem.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AGImagePickerController.h"

@class AGIPCGridItem;

@protocol AGIPCGridItemDelegate <NSObject>

@optional
- (void)agGridItem:(AGIPCGridItem *)gridItem didChangeSelectionState:(NSNumber *)selected;
- (void)agGridItem:(AGIPCGridItem *)gridItem didChangeNumberOfSelections:(NSNumber *)numberOfSelections;
- (BOOL)agGridItemCanSelect:(AGIPCGridItem *)gridItem;

@end

@interface AGIPCGridItem : UIView
{

}

@property (assign) BOOL selected;
@property (strong) ALAsset *asset;

@property (nonatomic, ag_weak) id<AGIPCGridItemDelegate> delegate;

@property (strong) AGImagePickerController *imagePickerController;

- (id)initWithImagePickerController:(AGImagePickerController *)imagePickerController andAsset:(ALAsset *)asset;
- (id)initWithImagePickerController:(AGImagePickerController *)imagePickerController asset:(ALAsset *)asset andDelegate:(id<AGIPCGridItemDelegate>)delegate;

- (void)tap;

+ (NSUInteger)numberOfSelections;

@end
