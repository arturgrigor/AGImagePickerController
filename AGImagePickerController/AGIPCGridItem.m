//
//  AGIPCGridItem.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCGridItem.h"

@implementation AGGridItem

#pragma mark - Properties

@synthesize selected;

- (void)setSelected:(BOOL)isSelected
{
    if (selected != isSelected)
    {
        selected = isSelected;
        [self setNeedsDisplay];
    }
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.selected = NO;
    }
    
    return self;
}

#pragma mark - Others

- (void)tap
{
    self.selected = !self.selected;
}

@end
