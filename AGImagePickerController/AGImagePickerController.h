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
    id delegate;
    
    BOOL shouldChangeStatusBarStyle;
    UIStatusBarStyle oldStatusBarStyle;
    
    AGIPCDidFinish didFinishBlock;
    AGIPCDidFail didFailBlock;
    
    NSUInteger maximumNumberOfPhotos;
}

@property (nonatomic, assign) BOOL shouldChangeStatusBarStyle;
@property (nonatomic, assign) NSUInteger maximumNumberOfPhotos;

@property (nonatomic, assign) id delegate;

@property (nonatomic, copy) AGIPCDidFail didFailBlock;
@property (nonatomic, copy) AGIPCDidFinish didFinishBlock;

+ (ALAssetsLibrary *)defaultAssetsLibrary;
+ (UIInterfaceOrientation)currentInterfaceOrientation;

- (id)initWithDelegate:(id)theDelegate;
- (id)initWithFailureBlock:(AGIPCDidFail)theFailureBlock andSuccessBlock:(AGIPCDidFinish)theSuccessBlock;
- (id)initWithDelegate:(id)theDelegate failureBlock:(AGIPCDidFail)theFailureBlock successBlock:(AGIPCDidFinish)theSuccessBlock maximumNumberOfPhotos:(NSUInteger)theMaximumNumberOfPhotos andShouldChangeStatusBarStyle:(BOOL)shouldChangeStatusBarStyleValue;

@end


