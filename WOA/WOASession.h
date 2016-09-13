//
//  WOASession.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOASessionTokens.h"
#import "WOAAccountCredential.h"


@interface WOASession : NSObject

@property (strong) WOASessionTokens *sessionTokens;
@property (nonatomic, strong) WOAAccountCredential *accountCredential;

@end
