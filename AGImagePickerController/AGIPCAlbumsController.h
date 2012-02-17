//
//  AGIPCAlbumsController.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AGImagePickerController.h"

#define ITEMS_PER_ROW       4

@interface AGIPCAlbumsController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *assetGroups;
    UITableView *tableView;
    
    UISegmentedControl *sourceSegmentedControl;
}

@property (nonatomic, readonly) NSMutableArray *assetGroups;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sourceSegmentedControl;

@end
