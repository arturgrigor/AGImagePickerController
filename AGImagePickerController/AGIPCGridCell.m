//
//  AGIPCGridCell.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCGridCell.h"
#import "AGIPCGridItem.h"
#import "AGImagePickerController.h"

@implementation AGIPCGridCell

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
        
        UIView *emptyView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView = emptyView;
        [emptyView release];
	}
	
	return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{   
    CGFloat leftMargin = 0;
    CGRect frame = CGRectZero;
    
    if (IS_IPAD())
    {
        leftMargin = AGIPC_ITEM_LEFT_MARGIN_IPAD;
        frame = CGRectMake(leftMargin, AGIPC_ITEM_TOP_MARGIN_IPAD, AGIPC_ITEM_WIDTH_IPAD, AGIPC_ITEM_HEIGHT_IPAD);
    }
    else
    {
        leftMargin = AGIPC_ITEM_LEFT_MARGIN_IPHONE;
        frame = CGRectMake(leftMargin, AGIPC_ITEM_TOP_MARGIN_IPHONE, AGIPC_ITEM_WIDTH_IPHONE, AGIPC_ITEM_HEIGHT_IPHONE);
    }
    
	for (AGIPCGridItem *gridItem in self.items)
    {	
		[gridItem setFrame:frame];
        UITapGestureRecognizer *selectionGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:gridItem action:@selector(tap)];
        selectionGestureRecognizer.numberOfTapsRequired = 1;
		[gridItem addGestureRecognizer:selectionGestureRecognizer];
        [selectionGestureRecognizer release];
        
		[self addSubview:gridItem];
		
		frame.origin.x = frame.origin.x + frame.size.width + leftMargin;
	}
}

@end
