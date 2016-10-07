//
//  WOARequestManager+Student.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 10/5/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOARequestManager.h"

@interface WOARequestManager (Student)

- (void) simpleQuery: (WOAActionType)actionType
            paraDict: (NSDictionary*)paraDict
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler;
- (void) simpleQuery: (WOAActionType)actionType
            fromDate: (NSString*)fromDate
              toDate: (NSString*)toDate
          onSuccuess: (void (^)(WOAResponeContent *responseContent))successHandler;

@end
