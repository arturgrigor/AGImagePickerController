//
//  AGImagePickerController.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define IS_IPAD()               ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && \
[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// Size in points
#define AGIPC_CHECKMARK_WIDTH                   28.f
#define AGIPC_CHECKMARK_HEIGHT                  28.f

#define AGIPC_ITEMS_PER_ROW                     4

#define AGIPC_ITEM_WIDTH_IPHONE                 75.f
#define AGIPC_ITEM_HEIGHT_IPHONE                75.f
#define AGIPC_ITEM_LEFT_MARGIN_IPHONE           4.f
#define AGIPC_ITEM_TOP_MARGIN_IPHONE            4.f
#define AGIPC_CHECKMARK_RIGHT_MARGIN_IPHONE     4.f
#define AGIPC_CHECKMARK_BOTTOM_MARGIN_IPHONE    4.f

#define AGIPC_ITEM_WIDTH_IPAD                   162.f
#define AGIPC_ITEM_HEIGHT_IPAD                  162.f
#define AGIPC_ITEM_LEFT_MARGIN_IPAD             24.f
#define AGIPC_ITEM_TOP_MARGIN_IPAD              24.f
#define AGIPC_CHECKMARK_RIGHT_MARGIN_IPAD       8.f
#define AGIPC_CHECKMARK_BOTTOM_MARGIN_IPAD      8.f

@class AGImagePickerController;

typedef void (^AGIPCDidFinish)(NSArray *info);
typedef void (^AGIPCDidFail)(NSError *error);

@protocol AGImagePickerControllerDelegate

@optional
- (void)agImagePickerController:(AGImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)agImagePickerController:(AGImagePickerController *)picker didFail:(NSError *)error;

@end

@interface AGImagePickerController : UINavigationController
{
    ALAssetsLibrary *assetsLibrary;
    id delegate;
    
    AGIPCDidFinish didFinishBlock;
    AGIPCDidFail didFailBlock;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, copy) AGIPCDidFail didFailBlock;
@property (nonatomic, copy) AGIPCDidFinish didFinishBlock;

- (id)initWithDelegate:(id)theDelegate;
- (id)initWithFailureBlock:(AGIPCDidFail)theFailureBlock andSuccessBlock:(AGIPCDidFinish)theSuccessBlock;

@end


