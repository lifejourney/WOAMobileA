//
//  WOARequestManager.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOARequestContent.h"
#import "WOAResponeContent.h"

@interface WOARequestManager : NSObject

+ (instancetype) sharedInstance;

#pragma mark -

- (void) showLoadingViewController;
- (void) showTransparentLoadingView;
- (void) hideLoadingViewController;

#pragma mark -

- (void) sendRequest: (WOARequestContent*)requestContent
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
           onFailure: (void (^)(WOAResponeContent *responseContent))failureHandler;


#pragma mark - 

- (void) sendLoginRequest: (NSString*)accountID
                 password: (NSString*)password
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
           onFailure: (void (^)(WOAResponeContent *responseContent))failureHandler;

#pragma mark -

- (void) simpleQueryActionType: (WOAActionType)actionType
             additionalHeaders: (NSDictionary*)additionalHeaders
                additionalDict: (NSDictionary*)additionalDict
                    onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler;

@end



