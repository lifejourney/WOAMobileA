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
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    
//    return [userDefaults dictionaryForKey: kRootKey];
    
#ifdef WOAMobileTeacher
    
    return @{@"AppStoreID": @"908853362",
             @"DefaultServerAddress": @{@"Production": @"http://www.qz5z.com",
                                        @"Test": @"http://120.43.238.29:8086"},
             @"DefaultTabID": @(0),
             @"RootViewControllerClass": @"WOATeacherRootViewController"};
    
#elif defined(WOAMobileStudent)
    
    return @{@"AppStoreID": @"908853362",
             @"DefaultServerAddress": @{@"Production": @"http://www.qz5z.com",
                                        @"Test": @"http://220.162.12.166:8080/jsonS.php"},
             @"DefaultTabID": @(0),
             @"RootViewControllerClass": @"WOAStudentRootViewController"};
    
#endif
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

+ (NSString*) rootViewControllerClassName
{
    return [self targetInfoDict][@"RootViewControllerClass"];
}

+ (NSUInteger) defaultTabID
{
    NSNumber *defaultTabID = [self targetInfoDict][@"DefaultTabID"];
    
    return [defaultTabID unsignedIntegerValue];
}

@end








