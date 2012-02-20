//
//  AGIPCGridItem.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCGridItem.h"

@interface AGGridItem ()

@property (nonatomic, retain) UIImageView *thumbnailImageView;
@property (nonatomic, retain) UIView *selectionView;
@property (nonatomic, retain) UIImageView *checkmarkImageView;

@end

@implementation AGGridItem

#pragma mark - Properties

@synthesize selected, asset, thumbnailImageView, selectionView, checkmarkImageView;

- (void)setSelected:(BOOL)isSelected
{
    selected = isSelected;
    
    self.selectionView.hidden = !selected;
    self.checkmarkImageView.hidden = !selected;
}

- (void)setAsset:(ALAsset *)theAsset
{
    if (asset != theAsset)
    {
        [asset release];
        asset = [theAsset retain];
        
        self.thumbnailImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    }
}

#pragma mark - Object Lifecycle

- (void)dealloc
{
    [asset release];
    [thumbnailImageView release];
    [selectionView release];
    [checkmarkImageView release];
    
    [super dealloc];
}

- (id)initWithAsset:(ALAsset *)theAsset
{
    self = [super init];
    if (self)
    {
        CGRect frame = CGRectZero, checkmarkFrame = CGRectZero;
        if (IS_IPAD())
        {
            frame = CGRectMake(AGIPC_ITEM_LEFT_MARGIN_IPAD, AGIPC_ITEM_TOP_MARGIN_IPAD, AGIPC_ITEM_WIDTH_IPAD, AGIPC_ITEM_HEIGHT_IPAD);
            checkmarkFrame = CGRectMake(frame.size.width - AGIPC_CHECKMARK_WIDTH - AGIPC_CHECKMARK_RIGHT_MARGIN_IPAD, frame.size.height - AGIPC_CHECKMARK_HEIGHT - AGIPC_CHECKMARK_BOTTOM_MARGIN_IPAD, AGIPC_CHECKMARK_WIDTH, AGIPC_CHECKMARK_HEIGHT);        }
        else
        {
            frame = CGRectMake(AGIPC_ITEM_LEFT_MARGIN_IPHONE, AGIPC_ITEM_TOP_MARGIN_IPHONE, AGIPC_ITEM_WIDTH_IPHONE, AGIPC_ITEM_HEIGHT_IPHONE);
            checkmarkFrame = CGRectMake(frame.size.width - AGIPC_CHECKMARK_WIDTH - AGIPC_CHECKMARK_RIGHT_MARGIN_IPHONE, frame.size.height - AGIPC_CHECKMARK_HEIGHT - AGIPC_CHECKMARK_BOTTOM_MARGIN_IPHONE, AGIPC_CHECKMARK_WIDTH, AGIPC_CHECKMARK_HEIGHT);
        }
        
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:self.thumbnailImageView];
        
        self.selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.selectionView.backgroundColor = [UIColor whiteColor];
        self.selectionView.alpha = .5f;
        [self addSubview:self.selectionView];
        
        // Position the checkmark image in the bottom right corner
        self.checkmarkImageView = [[UIImageView alloc] initWithFrame:checkmarkFrame];
        if (IS_IPAD())
            self.checkmarkImageView.image = [UIImage imageNamed:@"AGIPC-Checkmark-iPad"];
        else
            self.checkmarkImageView.image = [UIImage imageNamed:@"AGIPC-Checkmark-iPhone"];
		[self addSubview:self.checkmarkImageView];
        
        self.selected = NO;
        self.asset = theAsset;
    }
    
    return self;
}

#pragma mark - Others

- (void)tap
{
    self.selected = !self.selected;
}

@end
