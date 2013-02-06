//
//  ALAsset+AGIPC.m
//  AGImagePickerController Demo
//
//  Created by Artur Grigor on 19.06.2012.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//

#import "ALAsset+AGIPC.h"

@implementation ALAsset (AGIPC)

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    ALAsset *otherAsset = (ALAsset *)other;
    NSDictionary *selfUrls = [self valueForProperty:ALAssetPropertyURLs];
    NSDictionary *otherUrls = [otherAsset valueForProperty:ALAssetPropertyURLs];
    
    return [selfUrls isEqualToDictionary:otherUrls];
}

@end
