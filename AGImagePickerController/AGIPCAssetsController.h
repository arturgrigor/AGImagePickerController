//
//  AGIPCAssetsController.h
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

#import "AGIPCGridItem.h"

@interface AGIPCAssetsController : UIViewController<UITableViewDataSource, UITableViewDelegate, AGIPCGridItemDelegate>
{
    UITableView *tableView;
    ALAssetsGroup *assetsGroup;
    
    NSMutableArray *assets;
}

@property (retain) ALAssetsGroup *assetsGroup;
@property (retain) IBOutlet UITableView *tableView;

@property (readonly) NSArray *selectedAssets;

- (id)initWithAssetsGroup:(ALAssetsGroup *)theAssetsGroup;

@end
