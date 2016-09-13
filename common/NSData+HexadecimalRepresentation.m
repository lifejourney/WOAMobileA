//
//  NSData+HexadecimalRepresentation.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/16/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "NSData+HexadecimalRepresentation.h"


@implementation NSData (HexadecimalRepresentation)

- (NSString*) hexadecimalRepresentation
{
    NSMutableString *rep = [[NSMutableString alloc] initWithCapacity: self.length * 2];
    const char *charString = [self bytes];
    
    for (NSUInteger i = 0; i < self.length; i++)
    {
        unsigned char c = charString[i];
        [rep appendFormat: @"%02x", (int)c];
    }
    
    return rep;
}

@end
