//
//  UIImage+Utility.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/17/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

+ (UIImage*) originalImageWithName: (NSString*)name
{
    return [[UIImage imageNamed: name] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
}

@end
