//
//  AGIPCAlbumItem.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCGridItem.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AGAlbumItem : AGGridItem
{
    NSArray *assets;
    NSString *title;
}

- (id)initWithAssets:(NSArray *)theAssets andTitle:(NSString *)theTitle;

@property (nonatomic, retain) NSArray *assets;
@property (nonatomic, retain) NSString *title;

@end
