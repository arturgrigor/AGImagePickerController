//
//  AGIPCGridItem.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
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
	BOOL selected;
    ALAsset *asset;
    
    UIImageView *thumbnailImageView;
    UIView *selectionView;
    UIImageView *checkmarkImageView;
    
    id<AGIPCGridItemDelegate> delegate;
}

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) ALAsset *asset;

@property (nonatomic, assign) id<AGIPCGridItemDelegate> delegate;

- (id)initWithAsset:(ALAsset *)theAsset;
- (id)initWithAsset:(ALAsset *)theAsset andDelegate:(id<AGIPCGridItemDelegate>)theDelegate;

- (void)tap;

+ (NSUInteger)numberOfSelections;

@end
