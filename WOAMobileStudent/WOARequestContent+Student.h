//
//  WOARequestContent+Student.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/19/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOARequestContent.h"

@interface WOARequestContent (Student)

+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                  optionDict: (NSDictionary*)optionDict;
+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                    paraDict: (NSDictionary*)paraDict;
+ (WOARequestContent*) contentForSimpleQuery: (NSString*)msgType
                                    fromDate: (NSString*)fromDate
                                      toDate: (NSString*)toDate;

@end
