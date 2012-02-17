//
//  AGIPCGridItem.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGGridItem : UIView
{
	BOOL selected;
}

@property (nonatomic, assign) BOOL selected;

- (void)tap;

@end
