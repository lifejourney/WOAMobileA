//
//  WOARequestManager+Student.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 10/5/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOARequestManager+Student.h"
#import "WOARequestContent+Student.h"


@implementation WOARequestManager (Student)


- (void) simpleQuery: (WOAActionType)actionType
            paraDict: (NSDictionary*)paraDict
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
{
    WOARequestContent *requestContent = [WOARequestContent studContentForSimpleQuery: actionType
                                                                            paraDict: paraDict];

    [self sendRequest: requestContent
           onSuccuess: successHandler
            onFailure: ^(WOAResponeContent *responseContent)
     {
         NSLog(@"Request [%@] fail: %lu, HTTPStatus=%ld",
               [WOAActionDefine msgTypeByActionType: actionType],
               (unsigned long)responseContent.requestResult,
               (long)responseContent.HTTPStatus);
     }];
}

- (void) simpleQuery: (WOAActionType)actionType
            fromDate: (NSString*)fromDate
              toDate: (NSString*)toDate
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
{
    WOARequestContent *requestContent = [WOARequestContent studCententForSimpleQuery: actionType
                                                                            fromDate: fromDate
                                                                              toDate: toDate];

    [self sendRequest: requestContent
           onSuccuess: successHandler
            onFailure: ^(WOAResponeContent *responseContent)
     {
         NSLog(@"Request [%@] fail: %lu, HTTPStatus=%ld",
               [WOAActionDefine msgTypeByActionType: actionType],
               (unsigned long)responseContent.requestResult,
               (long)responseContent.HTTPStatus);
     }];
}

@end






