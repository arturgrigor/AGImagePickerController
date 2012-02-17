//
//  AGIPCAssetsController.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AGIPCAssetsController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView;
    ALAssetsGroup *assetsGroup;
    
    NSMutableArray *assets;
}

@property (nonatomic, retain) ALAssetsGroup *assetsGroup;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, readonly) NSArray *selectedAssets;

- (id)initWithAssetsGroup:(ALAssetsGroup *)theAssetsGroup;

@end
