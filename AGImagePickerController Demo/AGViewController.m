//
//  AGViewController.m
//  AGImagePickerController Demo
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGViewController.h"

#import "AGIPCToolbarItem.h"

@interface AGViewController (Private)

- (void)centerButtonForInterfaceOrientation:(UIInterfaceOrientation)orientation;
- (void)openAction:(id)sender;

@end

@implementation AGViewController

#pragma mark - Properties

@synthesize selectedPhotos;

- (UIButton *)openButton
{
    if (openButton == nil)
    {
        openButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [self centerButtonForInterfaceOrientation:self.interfaceOrientation];
        [openButton setTitle:@"Open" forState:UIControlStateNormal];
        
        [openButton addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return openButton;
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [selectedPhotos release];
    [openButton release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.selectedPhotos = [NSMutableArray array];
        
        [self.view addSubview:self.openButton];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self centerButtonForInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Private

- (void)centerButtonForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        width = bounds.size.height;
        height = bounds.size.width;
    }
    
    CGRect frame = CGRectMake((width - 72.f) / 2, (height - 37.f) / 2, 72.f, 37.f);
    self.openButton.frame = frame;
}

- (void)openAction:(id)sender
{
    AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
        NSLog(@"Fail. Error: %@", error);
        
        if (error == nil) {
            [self.selectedPhotos removeAllObjects];
            NSLog(@"User has cancelled.");
            [self dismissModalViewControllerAnimated:YES];
        } else {
            
            // We need to wait for the view controller to appear first.
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissModalViewControllerAnimated:YES];
            });
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    } andSuccessBlock:^(NSArray *info) {
        [self.selectedPhotos setArray:info];
        
        NSLog(@"Info: %@", info);
        [self dismissModalViewControllerAnimated:YES];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
    
    // Show saved photos on top
    imagePickerController.shouldShowSavedPhotosOnTop = YES;
    imagePickerController.selection = self.selectedPhotos;
    
    // Custom toolbar items
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"+ Select All" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease] andSelectionBlock:nil]; 
    AGIPCToolbarItem *selectOdd = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"+ Select Odd" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return !(index % 2);
    }];
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"- Deselect All" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];  
    imagePickerController.toolbarItemsForSelection = [NSArray arrayWithObjects:selectAll, flexible, selectOdd, flexible, deselectAll, nil];
//    imagePickerController.toolbarItemsForSelection = [NSArray array];
    [selectOdd release];
    [flexible release];
    [selectAll release];
    [deselectAll release];
    
//    imagePickerController.maximumNumberOfPhotos = 3;
    [self presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
}

@end
