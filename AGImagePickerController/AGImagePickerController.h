//
//  AGImagePickerController.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AGImagePickerControllerDefines.h"

@class AGImagePickerController;

@protocol AGImagePickerControllerDelegate

@optional

#pragma mark - Configuring Rows
- (NSUInteger)agImagePickerController:(AGImagePickerController *)picker
   numberOfItemsPerRowForDevice:(AGDeviceType)deviceType
        andInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

#pragma mark - Configuring Selections
- (AGImagePickerControllerSelectionBehaviorType)selectionBehaviorInSingleSelectionModeForAGImagePickerController:(AGImagePickerController *)picker;

#pragma mark - Appearance Configuration
- (BOOL)agImagePickerController:(AGImagePickerController *)picker
shouldDisplaySelectionInformationInSelectionMode:(AGImagePickerControllerSelectionMode)selectionMode;
- (BOOL)agImagePickerController:(AGImagePickerController *)picker
shouldShowToolbarForManagingTheSelectionInSelectionMode:(AGImagePickerControllerSelectionMode)selectionMode;

#pragma mark - Managing Selections
- (void)agImagePickerController:(AGImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)agImagePickerController:(AGImagePickerController *)picker didFail:(NSError *)error;

@end

@interface AGImagePickerController : UINavigationController
{
    id __ag_weak _pickerDelegate;
    
    struct {
        unsigned int delegateSelectionBehaviorInSingleSelectionMode:1;
        unsigned int delegateNumberOfItemsPerRowForDevice:1;
        unsigned int delegateShouldDisplaySelectionInformationInSelectionMode:1;
        unsigned int delegateShouldShowToolbarForManagingTheSelectionInSelectionMode:1;
        unsigned int delegateDidFinishPickingMediaWithInfo:1;
        unsigned int delegateDidFail:1;
    } _pickerFlags;
    
    BOOL _shouldChangeStatusBarStyle;
    BOOL _shouldShowSavedPhotosOnTop;
    UIStatusBarStyle _oldStatusBarStyle;
    
    AGIPCDidFinish _didFinishBlock;
    AGIPCDidFail _didFailBlock;
    
    NSUInteger _maximumNumberOfPhotosToBeSelected;
    
    NSArray *_toolbarItemsForManagingTheSelection;
    NSArray *_selection;
}

@property (nonatomic) BOOL shouldChangeStatusBarStyle;
@property (nonatomic) BOOL shouldShowSavedPhotosOnTop;
@property (nonatomic) NSUInteger maximumNumberOfPhotosToBeSelected;

@property (nonatomic, ag_weak) id delegate;

@property (nonatomic, copy) AGIPCDidFail didFailBlock;
@property (nonatomic, copy) AGIPCDidFinish didFinishBlock;

@property (nonatomic, strong) NSArray *toolbarItemsForManagingTheSelection;
@property (nonatomic, strong) NSArray *selection;

@property (nonatomic, readonly) AGImagePickerControllerSelectionMode selectionMode;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

- (id)initWithDelegate:(id)delegate;
- (id)initWithFailureBlock:(AGIPCDidFail)failureBlock
           andSuccessBlock:(AGIPCDidFinish)successBlock;
- (id)initWithDelegate:(id)delegate
          failureBlock:(AGIPCDidFail)failureBlock
          successBlock:(AGIPCDidFinish)successBlock
maximumNumberOfPhotosToBeSelected:(NSUInteger)maximumNumberOfPhotosToBeSelected
shouldChangeStatusBarStyle:(BOOL)shouldChangeStatusBarStyle
toolbarItemsForManagingTheSelection:(NSArray *)toolbarItemsForManagingTheSelection
andShouldShowSavedPhotosOnTop:(BOOL)shouldShowSavedPhotosOnTop;

@end


