//
//  AGIPCGridItem.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AGImagePickerController.h"
#import "AGImagePickerController+Constants.h"

@class AGIPCGridItem;

@protocol AGIPCGridItemDelegate <NSObject>

@optional
- (void)agGridItem:(AGIPCGridItem *)gridItem didChangeSelectionState:(NSNumber *)selected;
- (void)agGridItem:(AGIPCGridItem *)gridItem didChangeNumberOfSelections:(NSNumber *)numberOfSelections;
- (BOOL)agGridItemCanSelect:(AGIPCGridItem *)gridItem;

@end

@interface AGIPCGridItem : UIView
{
	BOOL selected;
    ALAsset *asset;
    
    UIImageView *thumbnailImageView;
    UIView *selectionView;
    UIImageView *checkmarkImageView;
    
    id<AGIPCGridItemDelegate> delegate;
}

@property (assign) BOOL selected;
@property (retain) ALAsset *asset;

@property (nonatomic, assign) id<AGIPCGridItemDelegate> delegate;

- (id)initWithAsset:(ALAsset *)theAsset;
- (id)initWithAsset:(ALAsset *)theAsset andDelegate:(id<AGIPCGridItemDelegate>)theDelegate;

- (void)tap;

+ (NSUInteger)numberOfSelections;

@end
