//
//  WOAAccountCredential.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/3/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAAccountCredential.h"


@implementation WOAAccountCredential

+ (instancetype) accountCredentialWithAccountID: (NSString *)accID password: (NSString *)pwd
{
    return [[WOAAccountCredential alloc] initAccountID: accID password: pwd];
}

- (instancetype) initAccountID: (NSString *)accID password: (NSString *)pwd
{
    if (self = [super init])
    {
        self.accountID = accID;
        self.password = pwd;
    }
    
    return self;
}

- (BOOL) isEqualAccountCredentials: (WOAAccountCredential *)acc
{
    BOOL isAccountIDEqual = ((!self.accountID && !acc.accountID)
                               || [self.accountID isEqualToString: acc.accountID]);
    BOOL isPasswordEqual = ((!self.password && !acc.password)
                            || [self.password isEqualToString: acc.password]);
    
	return (acc && isAccountIDEqual && isPasswordEqual);
}

@end
