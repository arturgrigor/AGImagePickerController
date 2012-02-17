//
//  AGIPCGridCell.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCGridCell.h"
#import "AGIPCGridItem.h"

@implementation AGGridCell

#pragma mark - Properties

@synthesize items;

- (void)setItems:(NSArray *)theItems
{
    if (items != theItems)
    {
        for (UIView *view in [self subviews]) 
        {		
            [view removeFromSuperview];
        }
        
        [items release];
        items = [theItems retain];
    }
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [items release];
    
    [super dealloc];
}

- (id)initWithItems:(NSArray *)theItems reuseIdentifier:(NSString *)theIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:theIdentifier];
    if(self)
    {    
		self.items = theItems;
	}
	
	return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{    
#if IS_IPHONE
    CGFloat leftMargin = 4.f;
	CGRect frame = CGRectMake(leftMargin, 2.f, 75.f, 75.f);
#else
    CGFloat leftMargin = 58.f;
    CGRect frame = CGRectMake(leftMargin, 10.f, 140.f + leftMargin, 140.f);
#endif
    
	for (AGGridItem *gridItem in self.items)
    {	
		[gridItem setFrame:frame];
        UITapGestureRecognizer *selectionGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:gridItem action:@selector(toggleSelection)];
		[gridItem addGestureRecognizer:selectionGestureRecognizer];
        [selectionGestureRecognizer release];
        
		[self addSubview:gridItem];
		
		frame.origin.x = frame.origin.x + frame.size.width + leftMargin;
	}
}

@end
