//
//  WOAAppDelegate.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/16/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOARequestContent.h"
#import "WOAResponeContent.h"
#import "UIColor+AppTheme.h"


@class WOARootViewController;

@interface WOAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;



@property (nonatomic, strong, readonly) WOARootViewController *rootViewController;

@property (copy) NSString *sessionID;
@property (nonatomic, strong) WOARequestContent *latestLoginRequestContent;
@property (nonatomic, assign) BOOL isLaunchByAPNS;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (UIViewController*) presentedViewController;

- (void) presentLoginViewController: (BOOL)loginImmediately animated: (BOOL)animated;
- (void) dismissLoginViewController: (BOOL)animated;
- (void) showLoadingViewController;
- (void) showTransparentLoadingView;
- (void) hideLoadingViewController;

- (void) sendRequest: (WOARequestContent*)requestContent
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
           onFailure: (void (^)(WOAResponeContent *responseContent))failureHandler;

- (void) simpleQuery: (NSString*)msgType
          optionDict: (NSDictionary*)optionDict
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler;
- (void) simpleQuery: (NSString*)msgType
            paraDict: (NSDictionary*)paraDict
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler;
- (void) simpleQuery: (NSString*)msgType
            fromDate: (NSString*)fromDate
              toDate: (NSString*)toDate
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler;

- (void) getOATableWithID: (NSString*)transID
                    navVC: (UINavigationController*)navVC;

@end

