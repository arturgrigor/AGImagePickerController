//
//  AGIPCToolbarItem.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 05.03.2012.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import "AGIPCToolbarItem.h"

@implementation AGIPCToolbarItem

#pragma mark - Properties

@synthesize assetIsSelectedBlock, barButtonItem;

#pragma mark - Object Lifecycle


#pragma mark - Designated Initializer

- (id)initWithBarButtonItem:(UIBarButtonItem *)theBarButtonItem andSelectionBlock:(AGIPCAssetIsSelectedBlock)theSelectionBlock
{
    self = [super init];
    if (self)
    {
        self.barButtonItem = theBarButtonItem;
        self.assetIsSelectedBlock = theSelectionBlock;
    }
    
    return self;
}

#pragma mark - Initializers

- (id)initWithBarButtonItem:(UIBarButtonItem *)theBarButtonItem
{
    return [self initWithBarButtonItem:theBarButtonItem andSelectionBlock:nil];
}

@end
