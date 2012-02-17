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

@synthesize selected, asset;

- (void)setSelected:(BOOL)isSelected
{
    if (selected != isSelected)
    {
        selected = isSelected;
        
        [self setNeedsDisplay];
    }
}

- (void)setAsset:(ALAsset *)theAsset
{
    if (asset != theAsset)
    {
        [asset release];
        asset = [theAsset retain];
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [asset release];
    
    [super dealloc];
}

- (id)initWithAsset:(ALAsset *)theAsset
{
    self = [super init];
    if (self)
    {
        self.selected = NO;
        self.asset = theAsset;
    }
    
    return self;
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGContextDrawImage(contextRef, rect, self.asset.thumbnail);
        
    CGContextRestoreGState(contextRef);
}

#pragma mark - Others

- (void)tap
{
    self.selected = !self.selected;
}

@end
