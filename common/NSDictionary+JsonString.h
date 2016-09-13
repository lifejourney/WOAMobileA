//
//  NSDictionary+JsonString.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/7/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (JsonString)

+ (NSDictionary*) fromJsonString: (NSString*)jsonString;
- (NSString*) toJsonString;

@end
