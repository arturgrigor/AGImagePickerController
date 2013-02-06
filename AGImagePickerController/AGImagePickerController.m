//
//  AGImagePickerController.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import "AGImagePickerController.h"

#import "AGIPCAlbumsController.h"
#import "AGIPCGridItem.h"

@interface AGImagePickerController ()
{
    
}

- (void)didFinishPickingAssets:(NSArray *)selectedAssets;
- (void)didCancelPickingAssets;
- (void)didFail:(NSError *)error;

@end

@implementation AGImagePickerController

#pragma mark - Properties

@synthesize
    delegate = _pickerDelegate,
    maximumNumberOfPhotosToBeSelected = _maximumNumberOfPhotosToBeSelected,
    shouldChangeStatusBarStyle = _shouldChangeStatusBarStyle,
    shouldShowSavedPhotosOnTop = _shouldShowSavedPhotosOnTop;

@synthesize
    didFailBlock,
    didFinishBlock;

@synthesize
    toolbarItemsForManagingTheSelection = _toolbarItemsForManagingTheSelection,
    selection = _selection;

- (AGImagePickerControllerSelectionMode)selectionMode
{
    return (self.maximumNumberOfPhotosToBeSelected == 1 ? AGImagePickerControllerSelectionModeSingle : AGImagePickerControllerSelectionModeMultiple);
}

- (void)setDelegate:(id)delegate
{
    _pickerDelegate = delegate;
    
    _pickerFlags.delegateSelectionBehaviorInSingleSelectionMode = _pickerDelegate && [_pickerDelegate respondsToSelector:@selector(selectionBehaviorInSingleSelectionModeForAGImagePickerController:)];
    _pickerFlags.delegateNumberOfItemsPerRowForDevice = _pickerDelegate && [_pickerDelegate respondsToSelector:@selector(agImagePickerController:numberOfItemsPerRowForDevice:andInterfaceOrientation:)];
    _pickerFlags.delegateShouldDisplaySelectionInformationInSelectionMode = _pickerDelegate && [_pickerDelegate respondsToSelector:@selector(agImagePickerController:shouldDisplaySelectionInformationInSelectionMode:)];
    _pickerFlags.delegateShouldShowToolbarForManagingTheSelectionInSelectionMode = _pickerDelegate && [_pickerDelegate respondsToSelector:@selector(agImagePickerController:shouldShowToolbarForManagingTheSelectionInSelectionMode:)];
    _pickerFlags.delegateDidFinishPickingMediaWithInfo = _pickerDelegate && [_pickerDelegate respondsToSelector:@selector(agImagePickerController:didFinishPickingMediaWithInfo:)];
    _pickerFlags.delegateDidFail = _pickerDelegate && [_pickerDelegate respondsToSelector:@selector(agImagePickerController:didFail:)];
}

- (void)setShouldChangeStatusBarStyle:(BOOL)shouldChangeStatusBarStyle
{
    if (_shouldChangeStatusBarStyle != shouldChangeStatusBarStyle)
    {
        _shouldChangeStatusBarStyle = shouldChangeStatusBarStyle;
        
        if (_shouldChangeStatusBarStyle)
            if (IS_IPAD())
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
            else
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        else
            [[UIApplication sharedApplication] setStatusBarStyle:_oldStatusBarStyle animated:YES];
    }
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static ALAssetsLibrary *assetsLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Workaround for triggering ALAssetsLibraryChangedNotification
        [assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) { }];
    });
    
    return assetsLibrary;
}

#pragma mark - Object Lifecycle

- (id)init
{
    return [self initWithDelegate:nil failureBlock:nil successBlock:nil maximumNumberOfPhotosToBeSelected:0 shouldChangeStatusBarStyle:SHOULD_CHANGE_STATUS_BAR_STYLE toolbarItemsForManagingTheSelection:nil andShouldShowSavedPhotosOnTop:SHOULD_SHOW_SAVED_PHOTOS_ON_TOP];
}

- (id)initWithDelegate:(id)delegate
{
    return [self initWithDelegate:delegate failureBlock:nil successBlock:nil maximumNumberOfPhotosToBeSelected:0 shouldChangeStatusBarStyle:SHOULD_CHANGE_STATUS_BAR_STYLE toolbarItemsForManagingTheSelection:nil andShouldShowSavedPhotosOnTop:SHOULD_SHOW_SAVED_PHOTOS_ON_TOP];
}

- (id)initWithFailureBlock:(AGIPCDidFail)failureBlock
           andSuccessBlock:(AGIPCDidFinish)successBlock
{
    return [self initWithDelegate:nil failureBlock:failureBlock successBlock:successBlock maximumNumberOfPhotosToBeSelected:0 shouldChangeStatusBarStyle:SHOULD_CHANGE_STATUS_BAR_STYLE toolbarItemsForManagingTheSelection:nil andShouldShowSavedPhotosOnTop:SHOULD_SHOW_SAVED_PHOTOS_ON_TOP];
}

- (id)initWithDelegate:(id)delegate
          failureBlock:(AGIPCDidFail)failureBlock
          successBlock:(AGIPCDidFinish)successBlock
maximumNumberOfPhotosToBeSelected:(NSUInteger)maximumNumberOfPhotosToBeSelected
shouldChangeStatusBarStyle:(BOOL)shouldChangeStatusBarStyle
toolbarItemsForManagingTheSelection:(NSArray *)toolbarItemsForManagingTheSelection
andShouldShowSavedPhotosOnTop:(BOOL)shouldShowSavedPhotosOnTop
{
    self = [super init];
    if (self)
    {
        _oldStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        
        self.shouldChangeStatusBarStyle = shouldChangeStatusBarStyle;
        self.shouldShowSavedPhotosOnTop = shouldShowSavedPhotosOnTop;
        
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.translucent = YES;
        self.toolbar.barStyle = UIBarStyleBlack;
        self.toolbar.translucent = YES;
        
        self.toolbarItemsForManagingTheSelection = toolbarItemsForManagingTheSelection;
        self.selection = nil;
        self.maximumNumberOfPhotosToBeSelected = maximumNumberOfPhotosToBeSelected;
        self.delegate = delegate;
        self.didFailBlock = failureBlock;
        self.didFinishBlock = successBlock;
        
        self.viewControllers = @[[[AGIPCAlbumsController alloc] initWithImagePickerController:self]];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Private

- (void)didFinishPickingAssets:(NSArray *)selectedAssets
{
    [self popToRootViewControllerAnimated:NO];
    
    // Reset the number of selections
    [AGIPCGridItem performSelector:@selector(resetNumberOfSelections)];
    
    if (self.didFinishBlock)
        self.didFinishBlock(selectedAssets);
    
	if (_pickerFlags.delegateDidFinishPickingMediaWithInfo)
    {
		[self.delegate performSelector:@selector(agImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:selectedAssets];
	}
}

- (void)didCancelPickingAssets
{
    [self popToRootViewControllerAnimated:NO];
    
    // Reset the number of selections
    [AGIPCGridItem performSelector:@selector(resetNumberOfSelections)];
    
    if (self.didFailBlock)
        self.didFailBlock(nil);
    
    if (_pickerFlags.delegateDidFail)
    {
		[self.delegate performSelector:@selector(agImagePickerController:didFail:) withObject:self withObject:nil];
	}
}

- (void)didFail:(NSError *)error
{
    [self popToRootViewControllerAnimated:NO];
    
    // Reset the number of selections
    [AGIPCGridItem performSelector:@selector(resetNumberOfSelections)];
    
    if (self.didFailBlock)
        self.didFailBlock(error);
    
    if (_pickerFlags.delegateDidFail)
    {
		[self.delegate performSelector:@selector(agImagePickerController:didFail:) withObject:self withObject:error];
	}
}

@end
