//
//  WOAFlowController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOARequestContent.h"
#import "WOAResponeContent.h"


@interface WOAFlowController : NSOperation

+ (void) sendAsynRequestWithContent: (WOARequestContent*)requestContent
                              queue: (NSOperationQueue*)queue
                completeOnMainQueue: (BOOL)completeOnMainQueue
                  completionHandler: (void (^)(WOAResponeContent *responseContent))handler;

@end
