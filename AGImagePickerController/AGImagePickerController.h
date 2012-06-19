//
//  AGImagePickerController.h
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
    BOOL shouldDisplaySelectionInformation;
    BOOL shouldShowSavedPhotosOnTop;
    UIStatusBarStyle oldStatusBarStyle;
    
    AGIPCDidFinish didFinishBlock;
    AGIPCDidFail didFailBlock;
    
    NSUInteger maximumNumberOfPhotos;
    
    NSArray *toolbarItemsForSelection;
    NSArray *selection;
}

@property (assign) BOOL shouldChangeStatusBarStyle;
@property (assign) BOOL shouldDisplaySelectionInformation;
@property (assign) BOOL shouldShowSavedPhotosOnTop;
@property NSUInteger maximumNumberOfPhotos;

@property (nonatomic, assign) id delegate;

@property (copy) AGIPCDidFail didFailBlock;
@property (copy) AGIPCDidFinish didFinishBlock;

@property (retain) NSArray *toolbarItemsForSelection; 
@property (retain) NSArray *selection;

+ (ALAssetsLibrary *)defaultAssetsLibrary;
+ (UIInterfaceOrientation)currentInterfaceOrientation;

- (id)initWithDelegate:(id)theDelegate;
- (id)initWithFailureBlock:(AGIPCDidFail)theFailureBlock andSuccessBlock:(AGIPCDidFinish)theSuccessBlock;
- (id)initWithDelegate:(id)theDelegate failureBlock:(AGIPCDidFail)theFailureBlock successBlock:(AGIPCDidFinish)theSuccessBlock maximumNumberOfPhotos:(NSUInteger)theMaximumNumberOfPhotos shouldChangeStatusBarStyle:(BOOL)shouldChangeStatusBarStyleValue toolbarItemsForSelection:(NSArray *)theToolbarItemsForSelection andShouldDisplaySelectionInformation:(BOOL)shouldDisplaySelectionInformation;

@end


