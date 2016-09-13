//
//  NSFileManager+AppFolder.m
//  WOAMobile
//
//  Created by steven.zhuang on 8/26/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "NSFileManager+AppFolder.h"


@implementation NSFileManager (AppFolder)

+ (NSString*) currentAccountIDWithDefaultValue
{
//    WOAAccountCredential *accountCredential = [WOAPropertyInfo latestLoginedAccount];
//    NSString *accountID = accountCredential.accountID;
//    if (!accountID || ([accountID length] == 0))
//    {
//        accountID = @"0";
//    }
//    
//    return accountID;
    return nil;
}

+ (NSString*) absoluteAppDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
    
    return [paths lastObject];
}

+ (NSString*) absoluteAccountDocumentPath: (NSString*)accountID
{
    NSString *appDocumentPath = [self absoluteAppDocumentPath];
    
    return [NSString stringWithFormat: @"%@/%@/Document", appDocumentPath, accountID];
}

+ (NSString*) currentAccountDocumentPath
{
    return [self absoluteAccountDocumentPath: [self currentAccountIDWithDefaultValue]];
}

+ (NSString*) absoluteAccountTempPath: (NSString *)accountID
{
    NSString *appDocumentPath = [self absoluteAppDocumentPath];
    
    return [NSString stringWithFormat: @"%@/%@/Temp", appDocumentPath, accountID];
}

+ (NSString*) currentAccountTempPath
{
    return [self absoluteAccountTempPath: [self currentAccountIDWithDefaultValue]];
}

+ (void) createDirectoryIfNotExists: (NSString*)dir
{
    if (![[NSFileManager defaultManager] fileExistsAtPath: dir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath: dir
                                  withIntermediateDirectories: YES
                                                   attributes: nil
                                                        error: nil];
    }
}

@end
