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

@interface AGGridItem : UIView
{
	BOOL selected;
    ALAsset *asset;
    
    UIImageView *thumbnailImageView;
    UIView *selectionView;
    UIImageView *checkmarkImageView;
}

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) ALAsset *asset;

- (id)initWithAsset:(ALAsset *)theAsset;

- (void)tap;

@end
