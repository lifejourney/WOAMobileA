//
//  WOASessionTokens.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/3/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOASessionTokens.h"


@implementation WOASessionTokens

- (instancetype) init
{
    if (self = [super init])
    {
        [self reset];
    }
    
    return self;
}

- (void) reset
{
    self.accessToken = nil;
}

- (BOOL) isAccessTokenExpired
{
    return NO;
}

@end
