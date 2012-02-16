//
//  AGIPCAlbumsController.h
//  AGImagePickerController Demo
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AGImagePickerController.h"

@interface AGIPCAlbumsController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *assetGroups;
}

@property (nonatomic, readonly) NSMutableArray *assetGroups;

@end
