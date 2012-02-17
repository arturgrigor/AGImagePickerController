//
//  AGIPCAlbumItem.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCAlbumItem.h"

@implementation AGAlbumItem

#pragma mark - Properties

@synthesize assets, title;

- (void)setAssets:(NSArray *)theAssets
{
    if (assets != theAssets)
    {
        [assets release];
        assets = [theAssets retain];
        
        [self setNeedsDisplay];
    }
}

- (void)setTitle:(NSString *)theTitle
{
    if (title != theTitle)
    {
        [title release];
        title = [theTitle retain];
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [assets release];
    [title release];
    
    [super dealloc];
}

- (id)initWithAssets:(NSArray *)theAssets andTitle:(NSString *)theTitle
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.assets = theAssets;
        self.title = theTitle;
        
#if IS_IPHONE
    self.frame = CGRectMake(0, 0, 82.f, 82.f);  
#else
    self.frame = CGRectMake(0, 0, 140.f, 140.f);
#endif
    }
    
    return self;
}

#pragma mark - Draw

- (CGRect)rect:(CGRect)theRect thatFits:(CGRect)toRect
{
    CGFloat width = 0, height = 0, x = 0, y = 0;
    if (theRect.size.width > theRect.size.height) {
        width = toRect.size.width;
        height = theRect.size.height / theRect.size.width * width;
        
        x = 0;
        y = round(abs(toRect.size.height - height) / 2);
    } else {
        height = toRect.size.height;
        width = theRect.size.width / theRect.size.height * height;
        
        x = round(abs(toRect.size.width - width) / 2);
        y = 0;
    }
 
    return CGRectMake(x + toRect.origin.x, y + toRect.origin.y, round(width), round(height));
}

- (void)drawRect:(CGRect)rect
{
    CGFloat angle = 0.f;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    
    [[UIColor whiteColor] set];
    
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    for (ALAsset *asset in self.assets) {
        CGSize imageSize = CGSizeMake(CGImageGetWidth(asset.aspectRatioThumbnail), CGImageGetHeight(asset.aspectRatioThumbnail));
        CGRect contentRect = CGRectMake(6.f, 6.f, rect.size.width - 12.f, rect.size.height - 12.f);
        CGRect imageRect = [self rect:CGRectMake(0, 0, imageSize.width, imageSize.height) thatFits:contentRect];
        @autoreleasepool {
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:imageRect];
            bezierPath.lineWidth = 6.f;
            [bezierPath stroke];
        }
        
        CGContextRotateCTM(contextRef, angle);
        CGContextDrawImage(contextRef, imageRect, asset.aspectRatioThumbnail);
        
        angle -= 10.f;
    }
    CGContextRestoreGState(contextRef);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.f];
    [self.title drawInRect:rect withFont:font];
}

@end
