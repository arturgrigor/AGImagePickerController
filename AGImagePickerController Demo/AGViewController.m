//
//  AGViewController.m
//  AGImagePickerController Demo
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGViewController.h"

@interface AGViewController (Private)

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
        [openButton setFrame:CGRectMake((self.view.frame.size.width - 72.f) / 2, (self.view.frame.size.height - 37.f) / 2, 72.f, 37.f)];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Private

- (void)openAction:(id)sender
{
    AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
        NSLog(@"Fail. Error: %@", error);
        
        if (error == nil)
            NSLog(@"User has cancelled.");
        
        [self dismissModalViewControllerAnimated:YES];
    } andSuccessBlock:^(NSArray *info) {
        NSLog(@"Info: %@", info);
        [self dismissModalViewControllerAnimated:YES];
    }];
    [self presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
}

@end
