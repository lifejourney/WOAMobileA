//
//  WOAAccountCredential.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/3/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOAAccountCredential : NSObject

@property (nonatomic, copy) NSString *accountID;
@property (nonatomic, copy) NSString *password;

+ (instancetype) accountCredentialWithAccountID: (NSString *)accID password: (NSString *)pwd;
- (instancetype) initAccountID: (NSString *)accID password: (NSString *)pwd;
- (BOOL) isEqualAccountCredentials: (WOAAccountCredential *)acc;

@end
