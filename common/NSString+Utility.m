//
//  NSString+Utility.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/31/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

+ (BOOL) isEmptyString: (NSString*)str
{
    return ((str == nil) ||
            ([str length] == 0));
}

+ (BOOL) isNotEmptyString: (NSString*)str
{
    return ![self isEmptyString: str];
}

- (NSString*) trim
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL) isNotEmpty
{
    return [self length] > 0;
}

@end
