//
//  AGIPCAlbumsController.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCAlbumsController.h"
#import "AGIPCGridCell.h"
#import "AGIPCAlbumItem.h"

@interface AGIPCAlbumsController (Private)

- (NSArray *)itemsForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)loadAssetGroups;
- (void)reloadData;

@end

@implementation AGIPCAlbumsController

#pragma mark - Properties

@synthesize tableView, sourceSegmentedControl;

- (NSMutableArray *)assetGroups
{
    if (assetGroups == nil)
    {
        assetGroups = [[NSMutableArray alloc] init];
        [self loadAssetGroups];
    }
    
    return assetGroups;
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [tableView release];
    [sourceSegmentedControl release];
    
    [assetGroups release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.topItem.titleView = self.sourceSegmentedControl;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    double albums = (double)self.assetGroups.count;
    return ceil(albums / ITEMS_PER_ROW);
}

- (NSArray *)itemsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:ITEMS_PER_ROW];
    
    NSUInteger startIndex = indexPath.row * ITEMS_PER_ROW, endIndex = startIndex + ITEMS_PER_ROW - 1;
    if (startIndex < self.assetGroups.count)
    {
        if (endIndex > self.assetGroups.count - 1)
            endIndex = self.assetGroups.count - 1;
        
        for (NSUInteger i = startIndex; i <= endIndex; i++)
        {
            ALAssetsGroup *group = (ALAssetsGroup *)[self.assetGroups objectAtIndex:i];
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            NSInteger numberOfAssets = [group numberOfAssets];
            
            NSMutableArray *assets = [[NSMutableArray alloc] initWithCapacity:3];
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, MIN(3, numberOfAssets))] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result == nil)
                    return;
                
                [assets addObject:result];
            }];
            
            // Adding the album view
            AGAlbumItem *albumItem = [[AGAlbumItem alloc] initWithAssets:assets andTitle:[group valueForProperty:ALAssetsGroupPropertyName]];
            [items addObject:albumItem];
            [albumItem release];
            
            [assets release];
        }
    }
    
    return items;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *items = [self itemsForRowAtIndexPath:indexPath];
    
    AGGridCell *cell = (AGGridCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AGGridCell alloc] initWithItems:items reuseIdentifier:CellIdentifier] autorelease];
    } else {
        cell.items = items;
    }
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[group valueForProperty:ALAssetsGroupPropertyName], numberOfAssets];
//    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
//	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    cell.textLabel.textColor = [UIColor whiteColor];
	
    return cell;
}

#pragma mark - UITableViewDelegate Methods

#pragma mark - Private

- (void)loadAssetGroups
{
    [self.assetGroups removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        @autoreleasepool {
            
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
            {
                if (group == nil) 
                {
                    return;
                }
                
                [self.assetGroups addObject:group];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            };
            
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                NSLog(@"A problem occured. Error: %@", error.localizedDescription);
#warning Delegate this method.
            };	
            
            [((AGImagePickerController *)self.navigationController).assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:assetGroupEnumerator 
                                 failureBlock:assetGroupEnumberatorFailure];
            
        }
        
    });
}

- (void)reloadData
{
    [self.tableView reloadData];
}

@end
