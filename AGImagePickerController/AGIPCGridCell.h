//
//  AGIPCGridCell.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import <UIKit/UIKit.h>

@interface AGIPCGridCell : UITableViewCell
{
	NSArray *items;
}

- (id)initWithItems:(NSArray *)theItems reuseIdentifier:(NSString *)theIdentifier;

@property (retain) NSArray *items;

@end
