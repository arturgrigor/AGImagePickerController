//
//  AGIPCAlbumsController.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AGIPCAlbumsController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *assetsGroups;
    UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
