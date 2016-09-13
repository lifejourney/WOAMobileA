//
//  WOASessionTokens.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/3/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WOASessionTokens : NSObject

@property (nonatomic, copy) NSString *accessToken;

- (void) reset;
- (BOOL) isAccessTokenExpired;

@end
