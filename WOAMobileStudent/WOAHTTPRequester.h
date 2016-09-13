//
//  WOAHTTPRequester.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOAHTTPRequester : NSObject

+ (NSMutableURLRequest*) URLRequestWithBodyData: (NSData*)bodyData;
+ (NSMutableURLRequest*) URLRequestWithBodyString: (NSString*)bodyString;

+ (NSMutableURLRequest*) URLRequestForUploadAttachment: (NSDictionary*)bodyDict;

@end
