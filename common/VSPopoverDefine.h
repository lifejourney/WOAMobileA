//
//  VSPopoverDefine.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultPopoverArrowHeight 8.0f
#define kDefaultPopoverCornerRadius 10.0f

typedef NS_OPTIONS (NSUInteger, VSPopoverArrowDirection)
{
    VSPopoverArrowDirectionUp     = 1UL << 0,
    VSPopoverArrowDirectionDown   = 1UL << 1,
    VSPopoverArrowDirectionLeft   = 1UL << 2,
    VSPopoverArrowDirectionRight  = 1UL << 3,
    VSPopoverArrowDirectionAny    = (VSPopoverArrowDirectionUp       |
                                       VSPopoverArrowDirectionDown     |
                                       VSPopoverArrowDirectionLeft     |
                                       VSPopoverArrowDirectionRight),
    VSPopoverArrowDirectionUnknown = NSUIntegerMax,
};