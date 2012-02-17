//
//  AGIPCAssetsController.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCAssetsController.h"

#import "AGImagePickerController.h"

#import "AGIPCGridCell.h"
#import "AGIPCGridItem.h"

@interface AGIPCAssetsController ()

@property (nonatomic, retain) NSMutableArray *assets;

@end


@interface AGIPCAssetsController (Private)

- (void)loadAssets;
- (void)reloadData;

- (NSArray *)itemsForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)doneAction:(id)sender;
- (void)selectAllAction:(id)sender;
- (void)deselectAllAction:(id)sender;

@end

@implementation AGIPCAssetsController

#pragma mark - Properties

@synthesize tableView, assetsGroup, assets;

- (void)setAssetsGroup:(ALAssetsGroup *)theAssetsGroup
{
    if (assetsGroup != theAssetsGroup)
    {
        [assetsGroup release];
        assetsGroup = [theAssetsGroup retain];
        [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];

        [self reloadData];
    }
}

- (NSArray *)selectedAssets
{
    NSMutableArray *selectedAssets = [NSMutableArray array];
    
	for (AGGridItem *gridItem in self.assets) 
    {		
		if (gridItem.selected)
        {	
			[selectedAssets addObject:gridItem.asset];
		}
	}
    
    return selectedAssets;
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [tableView release];
    [assetsGroup release];
    [assets release];
    
    [super dealloc];
}

- (id)initWithAssetsGroup:(ALAssetsGroup *)theAssetsGroup
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self = [super initWithNibName:@"AGIPCAssetsController_iPhone" bundle:nil];
    } else {
        self = [super initWithNibName:@"AGIPCAssetsController_iPad" bundle:nil];
    }
    if (self)
    {
        self.assets = [[NSMutableArray alloc] init];
        self.assetsGroup = theAssetsGroup;
        self.title = NSLocalizedStringWithDefaultValue(@"AGIPC.Loading", nil, [NSBundle mainBundle], @"Loading...", nil);
    }
    
    return self;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    double numberOfAssets = (double)self.assetsGroup.numberOfAssets;
    return ceil(numberOfAssets / 4);
}

- (NSArray *)itemsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:ITEMS_PER_ROW];
    
    NSUInteger startIndex = indexPath.row * ITEMS_PER_ROW, endIndex = startIndex + ITEMS_PER_ROW - 1;
    if (startIndex < self.assets.count)
    {
        if (endIndex > self.assets.count - 1)
            endIndex = self.assets.count - 1;
        
        for (NSUInteger i = startIndex; i <= endIndex; i++)
        {
            [items addObject:[self.assets objectAtIndex:i]];
        }
    }
    
    return items;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AGGridCell *cell = (AGGridCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {		        
        cell = [[[AGGridCell alloc] initWithItems:[self itemsForRowAtIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }	
	else 
    {		
		cell.items = [self itemsForRowAtIndexPath:indexPath];
	}
    
    return cell;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadAssets];
    
    // Navigation Bar Items
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = doneButtonItem;
    [doneButtonItem release];
    
    // Toolbar Items
    UIBarButtonItem *selectAll = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"AGIPC.SelectAll", nil, [NSBundle mainBundle], @"Select All", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(selectAllAction:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *deselectAll = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"AGIPC.DeselectAll", nil, [NSBundle mainBundle], @"Deselect All", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(deselectAllAction:)];
    
    NSArray *toolbarItems = [[NSArray alloc] initWithObjects:selectAll, flexibleSpace, deselectAll, nil];
    self.toolbarItems = toolbarItems;
    [toolbarItems release];
    
    [selectAll release];
    [flexibleSpace release];
    [deselectAll release];
}

#pragma mark - Private

- (void)loadAssets
{
    [self.assets removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) 
            {
                return;
            }
            
            AGGridItem *gridItem = [[AGGridItem alloc] initWithAsset:result];
            [self.assets addObject:gridItem];
            [gridItem release];
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self reloadData];
            
        });
        
    });
}

- (void)reloadData
{
    [self.tableView reloadData];
    self.title = NSLocalizedStringWithDefaultValue(@"AGIPC.PickPhotos", nil, [NSBundle mainBundle], @"Pick Photos", nil);
}

- (void)doneAction:(id)sender
{
    [((AGImagePickerController *)self.navigationController) performSelector:@selector(didFinishPickingAssets:) withObject:self.selectedAssets];
}

- (void)selectAllAction:(id)sender
{
    for (AGGridItem *gridItem in self.assets) {
        gridItem.selected = YES;
    }
}

- (void)deselectAllAction:(id)sender
{
    for (AGGridItem *gridItem in self.assets) {
        gridItem.selected = NO;
    }
}

@end
