//
//  WOACheckForUpdate.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kSelfAppleID @"1090667418"

@interface WOACheckForUpdate : NSObject <UIAlertViewDelegate>

+ (void) checkingUpdateFromAppStore: (void (^)())startHandler endHandler: (void (^)(NSDictionary* appData))endHandler;

@end
