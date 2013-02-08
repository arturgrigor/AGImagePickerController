//
//  AGIPCGridItem.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import "AGIPCGridItem.h"


#import "AGImagePickerController+Helper.h"

@interface AGIPCGridItem ()
{
    AGImagePickerController *_imagePickerController;
    ALAsset *_asset;
    id<AGIPCGridItemDelegate> __ag_weak _delegate;
    
    BOOL _selected;
    
    UIImageView *_thumbnailImageView;
    UIView *_selectionView;
    UIImageView *_checkmarkImageView;
}

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UIView *selectionView;
@property (nonatomic, strong) UIImageView *checkmarkImageView;

+ (void)resetNumberOfSelections;

@end

static NSUInteger numberOfSelectedGridItems = 0;

@implementation AGIPCGridItem

#pragma mark - Properties

@synthesize imagePickerController = _imagePickerController, delegate = _delegate, asset = _asset, selected = _selected, thumbnailImageView = _thumbnailImageView, selectionView = _selectionView, checkmarkImageView = _checkmarkImageView;

- (void)setSelected:(BOOL)selected
{
    @synchronized (self)
    {
        if (_selected != selected)
        {
            if (selected) {
                // Check if we can select
                if ([self.delegate respondsToSelector:@selector(agGridItemCanSelect:)])
                {
                    if (![self.delegate agGridItemCanSelect:self])
                        return;
                }
            }
            
            _selected = selected;
            
            self.selectionView.hidden = !_selected;
            self.checkmarkImageView.hidden = !_selected;
            
            if (_selected)
            {
                numberOfSelectedGridItems++;
            }
            else
            {
                if (numberOfSelectedGridItems > 0)
                    numberOfSelectedGridItems--;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if ([self.delegate respondsToSelector:@selector(agGridItem:didChangeSelectionState:)])
                {
                    [self.delegate performSelector:@selector(agGridItem:didChangeSelectionState:) withObject:self withObject:@(_selected)];
                }
                
                if ([self.delegate respondsToSelector:@selector(agGridItem:didChangeNumberOfSelections:)])
                {
                    [self.delegate performSelector:@selector(agGridItem:didChangeNumberOfSelections:) withObject:self withObject:@(numberOfSelectedGridItems)];
                }
                
            });
        }
    }
}

- (BOOL)selected
{
    BOOL ret;
    @synchronized (self) { ret = _selected; }
    
    return ret;
}

- (void)setAsset:(ALAsset *)asset
{
    @synchronized (self)
    {
        if (_asset != asset)
        {
            _asset = asset;
            self.thumbnailImageView.image = [UIImage imageWithCGImage:_asset.thumbnail];
        }
    }
}

- (ALAsset *)asset
{
    ALAsset *ret = nil;
    @synchronized (self) { ret = _asset; }
    
    return ret;
}

#pragma mark - Object Lifecycle

- (id)initWithImagePickerController:(AGImagePickerController *)imagePickerController andAsset:(ALAsset *)asset
{
    self = [self initWithImagePickerController:imagePickerController asset:asset andDelegate:nil];
    return self;
}

- (id)initWithImagePickerController:(AGImagePickerController *)imagePickerController asset:(ALAsset *)asset andDelegate:(id<AGIPCGridItemDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.imagePickerController = imagePickerController;
        
        self.selected = NO;
        self.delegate = delegate;
        
        CGRect frame = self.imagePickerController.itemRect;
        CGRect checkmarkFrame = [self.imagePickerController checkmarkFrameUsingItemFrame:frame];
        
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
            self.checkmarkImageView.image = [UIImage imageNamed:@"AGImagePickerController.bundle/AGIPC-Checkmark-iPad"];
        else
            self.checkmarkImageView.image = [UIImage imageNamed:@"AGImagePickerController.bundle/AGIPC-Checkmark-iPhone"];
        self.checkmarkImageView.hidden = !self.selected;
		[self addSubview:self.checkmarkImageView];
        
        self.asset = asset;
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
