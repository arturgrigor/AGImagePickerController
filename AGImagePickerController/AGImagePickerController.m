//
//  AGImagePickerController.m
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

#import "AGImagePickerController.h"

#import "AGIPCAlbumsController.h"

#import "AGIPCGridItem.h"

@interface AGImagePickerController (Private)

- (void)didFinishPickingAssets:(NSArray *)selectedAssets;
- (void)didCancelPickingAssets;
- (void)didFail:(NSError *)error;

@end

@implementation AGImagePickerController

#pragma mark - Properties

@synthesize assetsLibrary, delegate, maximumNumberOfPhotos;

@synthesize didFailBlock, didFinishBlock;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [assetsLibrary release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.translucent = YES;
        self.toolbar.barStyle = UIBarStyleBlack;
        self.toolbar.translucent = YES;
        
        self.maximumNumberOfPhotos = 0;
        self.delegate = nil;
        self.didFailBlock = nil;
        self.didFinishBlock = nil;
    }
    
    return self;
}

- (id)initWithDelegate:(id)theDelegate
{
    self = [self init];
    if (self)
    {
        self.delegate = theDelegate;
    }
    
    return self;
}

- (id)initWithFailureBlock:(AGIPCDidFail)theFailureBlock andSuccessBlock:(AGIPCDidFinish)theSuccessBlock
{
    self = [self init];
    if (self)
    {
        self.didFailBlock = theFailureBlock;
        self.didFinishBlock = theSuccessBlock;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIViewController *rootViewController = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rootViewController = [[AGIPCAlbumsController alloc] initWithNibName:@"AGIPCAlbumsController_iPhone" bundle:nil];
    } else {
        rootViewController = [[AGIPCAlbumsController alloc] initWithNibName:@"AGIPCAlbumsController_iPad" bundle:nil];
    }
    self.viewControllers = [NSArray arrayWithObject:rootViewController];
    [rootViewController release];
}

#pragma mark - Private

- (void)didFinishPickingAssets:(NSArray *)selectedAssets
{
    // Reset the number of selections
    [AGIPCGridItem performSelector:@selector(resetNumberOfSelections)];
    
    NSMutableArray *selectedImages = [NSMutableArray array];
	
	for(ALAsset *asset in selectedAssets)
    {
        NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
        [workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
        [workingDictionary setObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage] forKey:@"UIImagePickerControllerOriginalImage"];
		[workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
		
		[selectedImages addObject:workingDictionary];
		[workingDictionary release];	
	}
	
    [self popToRootViewControllerAnimated:NO];
    
	if ([self.delegate respondsToSelector:@selector(agImagePickerController:didFinishPickingMediaWithInfo:)])
    {
		[delegate performSelector:@selector(agImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:selectedImages];
	}
    
    if (self.didFinishBlock)
        self.didFinishBlock(selectedImages);
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
