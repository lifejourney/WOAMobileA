//
//  WOARequestManager.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOARequestManager.h"
#import "WOAHttpOperation.h"
#import "WOALoadingViewController.h"
#import "WOAAppDelegate.h"

static WOARequestManager *requestManager = nil;


@interface WOARequestManager ()

@property (nonatomic, strong) WOALoadingViewController *loadingVC;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end


@implementation WOARequestManager

+ (instancetype) sharedInstance
{
    if (requestManager == nil)
    {
        requestManager = [[WOARequestManager alloc] init];
    }
    
    return requestManager;
}

- (instancetype) init
{
    if (self = [super init])
    {
        self.loadingVC = [[WOALoadingViewController alloc] init];
        
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount: 1];
    }
    
    return self;
}

#pragma mark -

- (void) showLoadingViewController: (CGFloat)backgroundAlpha
{
    self.loadingVC.view.alpha = backgroundAlpha;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview: self.loadingVC.view];
}

- (void) showLoadingViewController
{
    [self showLoadingViewController: 0.3];
}

- (void) showTransparentLoadingView
{
    [self showLoadingViewController: 0];
}

- (void) hideLoadingViewController
{
    [self.loadingVC.view removeFromSuperview];
}

#pragma mark -

- (void) sendRequest: (WOARequestContent*)requestContent
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
           onFailure: (void (^)(WOAResponeContent *responseContent))failureHandler
{
    [self showLoadingViewController];
    
    [WOAHttpOperation sendAsynRequestWithContent: requestContent
                                           queue: self.operationQueue
                             completeOnMainQueue: YES
                               completionHandler: ^(WOAResponeContent *responseContent)
     {
         [self hideLoadingViewController];
         
         if ((responseContent.requestResult == WOAHTTPRequestResult_Success) && successHandler)
         {
             successHandler(responseContent);
         }
         else if (failureHandler)
         {
             failureHandler(responseContent);
         }
     }];
}

#pragma mark -

- (void) sendLoginRequest: (NSString*)accountID
                 password: (NSString*)password
               onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
                onFailure: (void (^)(WOAResponeContent *responseContent))failureHandler
{
    WOARequestContent *requestContent = [WOARequestContent contentForLogin: accountID
                                                                  password: password];
    
    [self sendRequest: requestContent
           onSuccuess: successHandler
            onFailure: failureHandler];
}

#pragma mark -

- (void) simpleQueryActionType: (WOAActionType)actionType
             additionalHeaders: (NSDictionary*)additionalHeaders
                additionalDict: (NSDictionary*)additionalDict
                    onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
{
    WOARequestContent *requestContent = [WOARequestContent contentForSimpleQuery: actionType
                                                               additionalHeaders: additionalHeaders
                                                                  additionalDict: additionalDict];
    
    [self sendRequest: requestContent
           onSuccuess: successHandler
            onFailure: ^(WOAResponeContent *responseContent)
     {
         NSString *msgType = [requestContent msgType];
         
         NSLog(@"Request [%@] fail: %lu, HTTPStatus=%ld", msgType, (unsigned long)responseContent.requestResult, (long)responseContent.HTTPStatus);
     }];
}

#pragma mark -

@end





