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

#pragma mark -

- (BOOL) hasContainSubString: (NSString*)subString
                     options: (NSStringCompareOptions)options
{
    NSRange foundRange = [self rangeOfString: subString options: options];
    
    return (foundRange.length > 0);
}

#pragma mark -

- (NSString*) rightPaddingWhitespace: (NSUInteger)fixedLength
{
    NSString *paddingStr = [NSString stringWithFormat: @"%@%*s", self, (int)fixedLength, " "];
    
    return [paddingStr substringToIndex: fixedLength];
}

#pragma mark - - (BOOL) isPureIntegerString: (NSString*)src

- (BOOL) isPureIntegerString
{
    NSScanner *scanner = [NSScanner scannerWithString: self];
    NSInteger val;
    
    return ([scanner scanInteger: &val] && [scanner isAtEnd]);
}

- (NSString*) removeNumberOrderPrefixWithDelimeter: (NSString*)delimeter
{
    NSString *retString = self;
    
    NSRange range = [self rangeOfString: delimeter];
    if (range.length > 0)
    {
        NSString *prefix = [self substringToIndex: range.location];
        if (prefix && [prefix length] > 0)
        {
            if ([prefix isPureIntegerString])
            {
                NSUInteger fromIndex = range.location + range.length;
                
                retString = [self substringFromIndex: fromIndex];
            }
        }
    }
    
    return retString;
}


@end








