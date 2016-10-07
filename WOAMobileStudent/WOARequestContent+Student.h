//
//  WOARequestContent+Student.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/19/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOARequestContent.h"

@interface WOARequestContent (Student)

+ (WOARequestContent*) studContentForSimpleQuery: (WOAActionType)actionType
                                        paraDict: (NSDictionary*)paraDict;
+ (WOARequestContent*) studCententForSimpleQuery: (WOAActionType)actionType
                                        fromDate: (NSString*)fromDate
                                          toDate: (NSString*)toDate;

@end
