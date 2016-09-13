//
//  UIColor+AppTheme.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "UIColor+AppTheme.h"


@implementation UIColor (AppTheme)

+ (UIColor*) mainItemBgColor
{
    return [UIColor colorWithRed: 242/255.f green: 90/255.f blue: 41/255.f alpha: 1.0];
}

+ (UIColor*) mainItemColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) navigationItemNormalColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) tabbarItemNormalColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) tabbarItemSelectedColor
{
    return [UIColor colorWithRed: 231/255.f green: 222/255.f blue: 127/255.f alpha: 1.0];
}

+ (UIColor*) filterViewBgColor
{
    return [UIColor colorWithRed: 240/255.f green: 240/255.f blue: 240/255.f alpha: 1.0f];
}

+ (UIColor*) textNormalColor
{
    return [UIColor blackColor];
}

+ (UIColor*) textHighlightedColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) listLightBgColor
{
    return [UIColor whiteColor];
}

+ (UIColor*) listDarkBgColor
{
    return [UIColor colorWithRed: 255/255.f green: 250/255.f blue: 244/255.f alpha: 1.0f];
}

+ (UIColor*) listSelectedBgColor
{
    return [UIColor mainItemBgColor];
}

+ (UIColor*) workflowTitleViewBgColor
{
    return [UIColor colorWithRed: 239/255.f green: 161/255.f blue: 25/255.f alpha: 1.0f];
}

@end
