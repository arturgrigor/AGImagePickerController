//
//  AGIPCGridCell.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGIPCGridCell : UITableViewCell
{
	NSArray *items;
}

- (id)initWithItems:(NSArray *)theItems reuseIdentifier:(NSString *)theIdentifier;

@property (nonatomic, retain) NSArray *items;

@end
