//
//  WOATargetInfo.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//


#import "WOATargetInfo.h"


#define kRootKey @"WOATargetInfo"


@implementation WOATargetInfo

+ (NSDictionary*) targetInfoDict
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults dictionaryForKey: kRootKey];
}

#pragma mark -

+ (NSString*) appStoreID
{
    return [self targetInfoDict][@"AppStoreID"];
}

+ (NSString*) defaultServerAddrForTest
{
    NSDictionary *serverAddrDict = [self targetInfoDict][@"DefaultServerAddress"];
    
    return serverAddrDict[@"Test"];
}

+ (NSString*) defaultServerAddrForProduction
{
    NSDictionary *serverAddrDict = [self targetInfoDict][@"DefaultServerAddress"];
    
    return serverAddrDict[@"Production"];
}
@end








