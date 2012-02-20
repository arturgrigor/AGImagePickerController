//
//  AGIPCGridItem.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import "AGIPCGridItem.h"

@interface AGIPCGridItem ()

@property (nonatomic, retain) UIImageView *thumbnailImageView;
@property (nonatomic, retain) UIView *selectionView;
@property (nonatomic, retain) UIImageView *checkmarkImageView;

+ (void)resetNumberOfSelections;

@end

static NSUInteger numberOfSelectedGridItems = 0;

@implementation AGIPCGridItem

#pragma mark - Properties

@synthesize delegate, selected, asset, thumbnailImageView, selectionView, checkmarkImageView;

- (void)setSelected:(BOOL)isSelected
{
    if (selected != isSelected)
    {
        selected = isSelected;
        
        self.selectionView.hidden = !selected;
        self.checkmarkImageView.hidden = !selected;
        
        if (selected)
        {
            numberOfSelectedGridItems++;
        }
        else
        {
            if (numberOfSelectedGridItems > 0)
                numberOfSelectedGridItems--;
        }
        
        if ([self.delegate respondsToSelector:@selector(agGridItem:didChangeSelectionState:)])
        {
            [self.delegate performSelector:@selector(agGridItem:didChangeSelectionState:) withObject:self withObject:[NSNumber numberWithBool:selected]];
        }
        
        if ([self.delegate respondsToSelector:@selector(agGridItem:didChangeNumberOfSelections:)])
        {
            [self.delegate performSelector:@selector(agGridItem:didChangeNumberOfSelections:) withObject:self withObject:[NSNumber numberWithUnsignedInteger:numberOfSelectedGridItems]];
        }
    }
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

- (id)init
{
    self = [self initWithAsset:nil andDelegate:nil];
    return self;
}

- (id)initWithAsset:(ALAsset *)theAsset
{
    self = [self initWithAsset:theAsset andDelegate:nil];
    return self;
}

- (id)initWithAsset:(ALAsset *)theAsset andDelegate:(id<AGIPCGridItemDelegate>)theDelegate
{
    self = [super init];
    if (self)
    {
        self.selected = NO;
        self.delegate = theDelegate;
        
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
        self.selectionView.hidden = !self.selected;
        [self addSubview:self.selectionView];
        
        // Position the checkmark image in the bottom right corner
        self.checkmarkImageView = [[UIImageView alloc] initWithFrame:checkmarkFrame];
        if (IS_IPAD())
            self.checkmarkImageView.image = [UIImage imageNamed:@"AGIPC-Checkmark-iPad"];
        else
            self.checkmarkImageView.image = [UIImage imageNamed:@"AGIPC-Checkmark-iPhone"];
        self.checkmarkImageView.hidden = !self.selected;
		[self addSubview:self.checkmarkImageView];
        
        self.asset = theAsset;
    }
    
    return self;
}

#pragma mark - Others

- (void)tap
{
    self.selected = !self.selected;
}

#pragma mark - Private

+ (void)resetNumberOfSelections
{
    numberOfSelectedGridItems = 0;
}

+ (NSUInteger)numberOfSelections
{
    return numberOfSelectedGridItems;
}

@end
