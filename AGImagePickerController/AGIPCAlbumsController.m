//
//  AGIPCAlbumsController.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import "AGIPCAlbumsController.h"

#import "AGImagePickerController.h"
#import "AGIPCAssetsController.h"

@interface AGIPCAlbumsController ()

@property (nonatomic, readonly) NSMutableArray *assetsGroups;

@end

@interface AGIPCAlbumsController (Private)

- (void)createNotifications;
- (void)destroyNotifications;

- (void)didChangeLibrary:(NSNotification *)notification;

- (void)loadAssetsGroups;
- (void)reloadData;

- (void)cancelAction:(id)sender;

@end

@implementation AGIPCAlbumsController

#pragma mark - Properties

@synthesize tableView;
@synthesize savedPhotosOnTop;

- (NSMutableArray *)assetsGroups
{
    if (assetsGroups == nil)
    {
        assetsGroups = [[NSMutableArray alloc] init];
        [self loadAssetsGroups];
    }
    
    return assetsGroups;
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [tableView release];
    [assetsGroups release];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Fullscreen
    if (((AGImagePickerController *)self.navigationController).shouldChangeStatusBarStyle) {
        self.wantsFullScreenLayout = YES;
    }
    
    // Setup Notifications
    [self createNotifications];
    
    // Navigation Bar Items
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Destroy Notifications
    [self destroyNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
    self.title = NSLocalizedStringWithDefaultValue(@"AGIPC.Loading", nil, [NSBundle mainBundle], @"Loading...", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ALAssetsGroup *group = [self.assetsGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSUInteger numberOfAssets = group.numberOfAssets;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [group valueForProperty:ALAssetsGroupPropertyName]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", numberOfAssets];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetsGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	AGIPCAssetsController *controller = [[AGIPCAssetsController alloc] initWithAssetsGroup:[self.assetsGroups objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 57;
}

#pragma mark - Private

- (void)loadAssetsGroups
{
    [self.assetsGroups removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        @autoreleasepool {
            
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
            {
                if (group == nil) 
                {
                    return;
                }
                
                if (savedPhotosOnTop) {
                    if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                        [self.assetsGroups insertObject:group atIndex:0];
                    } else if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] > ALAssetsGroupSavedPhotos) {
                        [self.assetsGroups insertObject:group atIndex:1];
                    } else {
                        [self.assetsGroups addObject:group];
                    }
                } else {
                    [self.assetsGroups addObject:group];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            };
            
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                NSLog(@"A problem occured. Error: %@", error.localizedDescription);
                [((AGImagePickerController *)self.navigationController) performSelector:@selector(didFail:) withObject:error];
            };	
            
            [[AGImagePickerController defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:assetGroupEnumerator 
                                 failureBlock:assetGroupEnumberatorFailure];
            
        }
        
    });
}

- (void)reloadData
{
    [self.tableView reloadData];
    self.title = NSLocalizedStringWithDefaultValue(@"AGIPC.Albums", nil, [NSBundle mainBundle], @"Albums", nil);
}

- (void)cancelAction:(id)sender
{
    [((AGImagePickerController *)self.navigationController) performSelector:@selector(didCancelPickingAssets)];
}

#pragma mark - Notifications

- (void)createNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didChangeLibrary:) 
                                                 name:ALAssetsLibraryChangedNotification 
                                               object:[AGImagePickerController defaultAssetsLibrary]];
}

- (void)destroyNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:ALAssetsLibraryChangedNotification 
                                                  object:[AGImagePickerController defaultAssetsLibrary]];
}

- (void)didChangeLibrary:(NSNotification *)notification
{
    [self loadAssetsGroups];
}

@end
