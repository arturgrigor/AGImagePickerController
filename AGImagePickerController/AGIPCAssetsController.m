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
    
	for (AGIPCGridItem *gridItem in self.assets) 
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
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:AGIPC_ITEMS_PER_ROW];
    
    NSUInteger startIndex = indexPath.row * AGIPC_ITEMS_PER_ROW, endIndex = startIndex + AGIPC_ITEMS_PER_ROW - 1;
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
    
    AGIPCGridCell *cell = (AGIPCGridCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {		        
        cell = [[[AGIPCGridCell alloc] initWithItems:[self itemsForRowAtIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }	
	else 
    {		
		cell.items = [self itemsForRowAtIndexPath:indexPath];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD())
        return AGIPC_ITEM_HEIGHT_IPAD + AGIPC_ITEM_TOP_MARGIN_IPAD;
    else
        return AGIPC_ITEM_HEIGHT_IPHONE + AGIPC_ITEM_TOP_MARGIN_IPHONE;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // Reset the number of selections
    [AGIPCGridItem performSelector:@selector(resetNumberOfSelections)];
    
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadAssets];
    
    // Navigation Bar Items
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    doneButtonItem.enabled = NO;
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
            
            AGIPCGridItem *gridItem = [[AGIPCGridItem alloc] initWithAsset:result andDelegate:self];
            [self.assets addObject:gridItem];
            [gridItem release];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self reloadData];
            
        });
        
    });
}

- (void)reloadData
{
    [self.tableView reloadData];
    self.title = [NSString stringWithFormat:@"%@ (%d/%d)", NSLocalizedStringWithDefaultValue(@"AGIPC.PickPhotos", nil, [NSBundle mainBundle], @"Pick Photos", nil), [AGIPCGridItem numberOfSelections], self.assets.count];
}

- (void)doneAction:(id)sender
{
    [((AGImagePickerController *)self.navigationController) performSelector:@selector(didFinishPickingAssets:) withObject:self.selectedAssets];
}

- (void)selectAllAction:(id)sender
{
    for (AGIPCGridItem *gridItem in self.assets) {
        gridItem.selected = YES;
    }
}

- (void)deselectAllAction:(id)sender
{
    for (AGIPCGridItem *gridItem in self.assets) {
        gridItem.selected = NO;
    }
}

#pragma mark - AGGridItemDelegate Methods

- (void)agGridItem:(AGIPCGridItem *)gridItem didChangeNumberOfSelections:(NSNumber *)numberOfSelections
{
    self.navigationItem.rightBarButtonItem.enabled = (numberOfSelections.unsignedIntegerValue > 0);
    
    self.title = [NSString stringWithFormat:@"%@ (%d/%d)", NSLocalizedStringWithDefaultValue(@"AGIPC.PickPhotos", nil, [NSBundle mainBundle], @"Pick Photos", nil), [AGIPCGridItem numberOfSelections], self.assets.count];
}

@end
