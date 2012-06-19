//
//  AGImagePickerController.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import "AGImagePickerController.h"
#import "AGImagePickerController+Constants.h"

#import "AGIPCAlbumsController.h"
#import "AGIPCGridItem.h"

@interface AGImagePickerController (Private)

- (void)didFinishPickingAssets:(NSArray *)selectedAssets;
- (void)didCancelPickingAssets;
- (void)didFail:(NSError *)error;

@end

static UIInterfaceOrientation currentInterfaceOrientation;

@implementation AGImagePickerController

#pragma mark - Properties

@synthesize delegate, maximumNumberOfPhotos, shouldChangeStatusBarStyle, shouldDisplaySelectionInformation, shouldShowSavedPhotosOnTop;

@synthesize didFailBlock, didFinishBlock;

@synthesize toolbarItemsForSelection, selection;

- (void)setShouldChangeStatusBarStyle:(BOOL)theShouldChangeStatusBarStyle
{
    @synchronized (self)
    {
        if (shouldChangeStatusBarStyle != theShouldChangeStatusBarStyle)
        {
            shouldChangeStatusBarStyle = theShouldChangeStatusBarStyle;
            
            if (shouldChangeStatusBarStyle)
                if (IS_IPAD())
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
                else
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
            else
                [[UIApplication sharedApplication] setStatusBarStyle:oldStatusBarStyle animated:YES];
        }
    }
}

- (BOOL)shouldChangeStatusBarStyle
{
    BOOL should;
    
    @synchronized (self)
    {
        should = shouldChangeStatusBarStyle;
    }
    
    return should;
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

+ (UIInterfaceOrientation)currentInterfaceOrientation
{
    return currentInterfaceOrientation;
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [toolbarItemsForSelection release];
    [selection release];
    
    [didFailBlock release];
    [didFinishBlock release];
    
    [super dealloc];
}

- (id)init
{
    return [self initWithDelegate:nil failureBlock:nil successBlock:nil maximumNumberOfPhotos:0 shouldChangeStatusBarStyle:SHOULD_CHANGE_STATUS_BAR_STYLE toolbarItemsForSelection:nil andShouldDisplaySelectionInformation:SHOULD_DISPLAY_SELECTION_INFO];
}

- (id)initWithDelegate:(id)theDelegate
{
    return [self initWithDelegate:theDelegate failureBlock:nil successBlock:nil maximumNumberOfPhotos:0 shouldChangeStatusBarStyle:SHOULD_CHANGE_STATUS_BAR_STYLE toolbarItemsForSelection:nil andShouldDisplaySelectionInformation:SHOULD_DISPLAY_SELECTION_INFO];
}

- (id)initWithFailureBlock:(AGIPCDidFail)theFailureBlock andSuccessBlock:(AGIPCDidFinish)theSuccessBlock
{
    return [self initWithDelegate:nil failureBlock:theFailureBlock successBlock:theSuccessBlock maximumNumberOfPhotos:0 shouldChangeStatusBarStyle:SHOULD_CHANGE_STATUS_BAR_STYLE toolbarItemsForSelection:nil andShouldDisplaySelectionInformation:SHOULD_DISPLAY_SELECTION_INFO];
}

- (id)initWithDelegate:(id)theDelegate failureBlock:(AGIPCDidFail)theFailureBlock successBlock:(AGIPCDidFinish)theSuccessBlock maximumNumberOfPhotos:(NSUInteger)theMaximumNumberOfPhotos shouldChangeStatusBarStyle:(BOOL)shouldChangeStatusBarStyleValue toolbarItemsForSelection:(NSArray *)theToolbarItemsForSelection andShouldDisplaySelectionInformation:(BOOL)shouldDisplaySelectionInformationValue
{
    self = [super init];
    if (self)
    {
        currentInterfaceOrientation = self.interfaceOrientation;
        oldStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        
        self.shouldChangeStatusBarStyle = shouldChangeStatusBarStyleValue;
        self.shouldDisplaySelectionInformation = shouldDisplaySelectionInformationValue;
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.translucent = YES;
        self.toolbar.barStyle = UIBarStyleBlack;
        self.toolbar.translucent = YES;
        
        self.toolbarItemsForSelection = theToolbarItemsForSelection;
        self.selection = nil;
        self.maximumNumberOfPhotos = theMaximumNumberOfPhotos;
        self.delegate = theDelegate;
        self.didFailBlock = theFailureBlock;
        self.didFinishBlock = theSuccessBlock;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    currentInterfaceOrientation = toInterfaceOrientation;
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AGIPCAlbumsController *rootViewController = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rootViewController = [[AGIPCAlbumsController alloc] initWithNibName:@"AGIPCAlbumsController_iPhone" bundle:nil];
    } else {
        rootViewController = [[AGIPCAlbumsController alloc] initWithNibName:@"AGIPCAlbumsController_iPad" bundle:nil];
    }
    rootViewController.savedPhotosOnTop = shouldShowSavedPhotosOnTop;
    self.viewControllers = [NSArray arrayWithObject:rootViewController];
    [rootViewController release];
}

#pragma mark - Private

- (void)didFinishPickingAssets:(NSArray *)selectedAssets
{
    // Reset the number of selections
    [AGIPCGridItem performSelector:@selector(resetNumberOfSelections)];
	
    [self popToRootViewControllerAnimated:NO];
    
	if ([self.delegate respondsToSelector:@selector(agImagePickerController:didFinishPickingMediaWithInfo:)])
    {
		[delegate performSelector:@selector(agImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:selectedAssets];
	}
    
    if (self.didFinishBlock)
        self.didFinishBlock(selectedAssets);
}

- (void)didCancelPickingAssets
{
    // Reset the number of selections
    [AGIPCGridItem performSelector:@selector(resetNumberOfSelections)];
    
    [self popToRootViewControllerAnimated:NO];
    
    if ([delegate respondsToSelector:@selector(agImagePickerController:didFail:)])
    {
		[delegate performSelector:@selector(agImagePickerController:didFail:) withObject:self withObject:nil];
	}
    
    if (self.didFailBlock)
        self.didFailBlock(nil);
}

- (void)didFail:(NSError *)error
{
    // Reset the number of selections
    [AGIPCGridItem performSelector:@selector(resetNumberOfSelections)];
    
    [self popToRootViewControllerAnimated:NO];
    
    if ([delegate respondsToSelector:@selector(agImagePickerController:didFail:)])
    {
		[delegate performSelector:@selector(agImagePickerController:didFail:) withObject:self withObject:error];
	}
    
    if (self.didFailBlock)
        self.didFailBlock(error);
}

@end
