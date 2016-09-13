//
//  NSMutableData+AppendString.m
//  WOAMobile
//
//  Created by steven.zhuang on 8/26/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "NSMutableData+AppendString.h"


@implementation NSMutableData (AppendString)

- (void) appendString: (NSString *)string
{
    if (string && [string length] > 0)
    {
        [self appendData: [string dataUsingEncoding: NSUTF8StringEncoding]];
    }
}

- (void) appendDataFromFile: (NSString *)filePath
{
    if (filePath && [filePath length] > 0)
    {
        [self appendData: [NSData dataWithContentsOfFile: filePath]];
    }
}

@end
