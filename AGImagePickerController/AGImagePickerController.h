//
//  AGImagePickerController.h
//  AGImagePickerController
//
//  Created by Artur Grigor on 2/16/12.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define IS_IPHONE() (![[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] || [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#warning Fix this detection issue

#if IS_IPHONE
    #define ALBUM_WIDTH         75.f
    #define ALBUM_HEIGHT        75.f
    #define ALBUM_LEFT_MARGIN   2.f
    #define ALBUM_TOP_MARGIN    4.f
#else
    #define ALBUM_WIDTH         140.f
    #define ALBUM_HEIGHT        140.f
    #define ALBUM_LEFT_MARGIN   58.f
    #define ALBUM_TOP_MARGIN    58.f
#endif

@interface AGImagePickerController : UINavigationController
{
    ALAssetsLibrary *assetsLibrary;
}

@property (nonatomic, readonly) ALAssetsLibrary *assetsLibrary;

@end
