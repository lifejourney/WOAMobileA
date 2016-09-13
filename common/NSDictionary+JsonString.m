//
//  NSDictionary+JsonString.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/7/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "NSDictionary+JsonString.h"


@implementation NSDictionary (JsonString)

+ (NSDictionary*) fromJsonString: (NSString*)jsonString
{
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: jsonData
                                                         options: 0
                                                           error: &error];
    
    return dict;
}

- (NSString*) toJsonString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: self
                                                       options: 0
                                                         error: &error];
    NSString *jsonString = [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
    
    return jsonString;
}

@end
