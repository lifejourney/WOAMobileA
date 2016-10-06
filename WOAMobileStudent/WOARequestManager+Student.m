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

- (void) simpleQuery: (NSString*)msgType
          optionDict: (NSDictionary*)optionDict
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
{
    WOARequestContent *requestContent = [WOARequestContent contentForSimpleQuery: msgType
                                                                      optionDict: optionDict];

    [self sendRequest: requestContent
           onSuccuess: successHandler
            onFailure: ^(WOAResponeContent *responseContent)
     {
         NSLog(@"Request [%@] fail: %lu, HTTPStatus=%ld", msgType, (unsigned long)responseContent.requestResult, (long)responseContent.HTTPStatus);
     }];
}

- (void) simpleQuery: (NSString*)msgType
            paraDict: (NSDictionary*)paraDict
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
{
    WOARequestContent *requestContent = [WOARequestContent contentForSimpleQuery: msgType
                                                                        paraDict: paraDict];

    [self sendRequest: requestContent
           onSuccuess: successHandler
            onFailure: ^(WOAResponeContent *responseContent)
     {
         NSLog(@"Request [%@] fail: %lu, HTTPStatus=%ld", msgType, (unsigned long)responseContent.requestResult, (long)responseContent.HTTPStatus);
     }];
}

- (void) simpleQuery: (NSString*)msgType
            fromDate: (NSString*)fromDate
              toDate: (NSString*)toDate
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler
{
    WOARequestContent *requestContent = [WOARequestContent contentForSimpleQuery: msgType
                                                                        fromDate: fromDate
                                                                          toDate: toDate];

    [self sendRequest: requestContent
           onSuccuess: successHandler
            onFailure: ^(WOAResponeContent *responseContent)
     {
         NSLog(@"Request [%@] fail: %lu, HTTPStatus=%ld", msgType, (unsigned long)responseContent.requestResult, (long)responseContent.HTTPStatus);
     }];
}

@end
