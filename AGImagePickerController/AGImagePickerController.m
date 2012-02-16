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

@implementation AGImagePickerController

#pragma mark - Properties

@synthesize assetsLibrary;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [assetsLibrary release];
    
    [super dealloc];
}

- (id)init
{
    UIViewController *rootViewController = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        rootViewController = [[AGIPCAlbumsController alloc] initWithNibName:@"AGIPCAlbumsController_iPhone" bundle:nil];
    } else {
        rootViewController = [[AGIPCAlbumsController alloc] initWithNibName:@"AGIPCAlbumsController_iPad" bundle:nil];
    }
    self = [super initWithRootViewController:rootViewController];
    [rootViewController release];
    if (self)
    {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
