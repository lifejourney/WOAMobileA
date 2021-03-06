//
//  WOAPropertyInfo.m
//  WOAMobile
//
//  Created by steven.zhuang on 5/31/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAPropertyInfo.h"
#import "WOATargetInfo.h"

@implementation WOAPropertyInfo

+ (void) saveObject: (id)value key: (NSString*)key subKey: (NSString*)subKey
{
    if (key && [key length] > 0 && subKey && [subKey length] > 0)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *prevInfo = [userDefaults objectForKey: key];
        NSMutableDictionary *currentInfo = [NSMutableDictionary dictionaryWithDictionary: prevInfo];
        
        if (value)
        {
            [currentInfo setObject: value forKey: subKey];
        }
        else
        {
            [currentInfo removeObjectForKey: subKey];
        }
        
        [userDefaults setObject: currentInfo forKey: key];
        [userDefaults synchronize];
    }
}

+ (NSString*) stringValueFromKey: (NSString*)key subKey: (NSString*)subKey
{
    NSString *value = nil;
    
    if (key && [key length] > 0 && subKey && [subKey length] > 0)
    {
        NSDictionary *prevInfo = [[NSUserDefaults standardUserDefaults] objectForKey: key];
        
        if (prevInfo)
        {
            value = [prevInfo valueForKey: subKey];
        }
    }
    
    return value;
}

+ (NSString*) defaultServerAddress
{
#ifdef DEBUG
    return [WOATargetInfo defaultServerAddrForTest];
#else
    return [WOATargetInfo defaultServerAddrForProduction];
#endif
}

+ (NSString*) serverAddress
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *addr = [userDefaults stringForKey: @"serverAddress"];
    
    if (!addr || ([addr length] == 0))
    {
        addr = [self defaultServerAddress];
    }
    
    return addr;
}

+ (void) setServerAddress: (NSString*)addr
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue: addr forKey: @"serverAddress"];
    [userDefaults synchronize];
}

+ (void) resetServerAddress
{
    [self setServerAddress: [self defaultServerAddress]];
}

+ (WOAAccountCredential*) latestLoginedAccount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *latestAccount = [userDefaults dictionaryForKey: @"latestAccount"];
    
    return [WOAAccountCredential accountCredentialWithAccountID: [latestAccount valueForKey: @"account"]
                                                       password: [latestAccount valueForKey: @"pwd"]];
}
+ (NSString*) latestAccountID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *latestAccount = [userDefaults dictionaryForKey: @"latestAccount"];
    
    return [latestAccount valueForKey: @"account"];
}

+ (NSString*) latestAccountPassword
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *latestAccount = [userDefaults dictionaryForKey: @"latestAccount"];
    
    return [latestAccount valueForKey: @"pwd"];
}

+ (void) saveLatestLoginAccount: (WOAAccountCredential*)account
{
    NSDictionary *latestAccount = [NSDictionary dictionaryWithObjectsAndKeys: account.accountID, @"account",
                                                                              account.password, @"pwd",
                                                                              nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: latestAccount forKey: @"latestAccount"];
    [userDefaults synchronize];
}

+ (void) saveLatestLoginAccountID: (NSString*)accountID password: (NSString*)password
{
    WOAAccountCredential *account = [WOAAccountCredential accountCredentialWithAccountID: accountID password: password];
    
    [self saveLatestLoginAccount: account];
}

+ (NSString*) latestDeviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey: @"deviceToken"];
}

+ (void) saveLatestDeviceToken: (NSString*)deviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue: deviceToken forKey: @"deviceToken"];
    [userDefaults synchronize];
}

+ (NSString*) latestSessionID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey: @"latestSessionID"];
}

+ (void) saveLatestSessionID: (NSString*)sessionID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue: sessionID forKey: @"latestSessionID"];
    [userDefaults synchronize];
}

+ (NSString*) latestWorkID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey: @"latestWorkID"];
}

+ (void) saveLatestWorkID: (NSString*)workID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue: workID forKey: @"latestWorkID"];
    [userDefaults synchronize];
}

@end



