//
//  AGIPCAlbumsController.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AGIPCAlbumsController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *assetsGroups;
    UITableView *tableView;
}

@property (retain) IBOutlet UITableView *tableView;
@property (assign) BOOL savedPhotosOnTop;

@end
