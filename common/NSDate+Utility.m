//
//  NSDate+Utility.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 10/1/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

+ (NSDate*) dateFromString: (NSString*)dateStr
              formatString: (NSString*)formatStr
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    
    formatter.dateFormat = formatStr;
    
    return [formatter dateFromString: dateStr];
}

- (NSString*) dateStringWithFormat: (NSString*)formatStr
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    
    formatter.dateFormat = formatStr;
    
    return [formatter stringFromDate: self];
}

@end
