//
//  WOATargetInfo.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef WOAMobileTeacher

#define kWOASrvKeyForResultDescription @"description"

#elif defined(WOAMobileStudent)

#define kWOASrvKeyForResultDescription @"prompt"

#endif

@interface WOATargetInfo : NSObject

+ (NSString*) appStoreID;
+ (NSString*) defaultServerAddrForTest;
+ (NSString*) defaultServerAddrForProduction;

+ (NSString*) rootViewControllerClassName;
+ (NSUInteger) defaultTabID;

@end

