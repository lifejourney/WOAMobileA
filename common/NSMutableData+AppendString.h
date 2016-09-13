//
//  NSMutableData+AppendString.h
//  WOAMobile
//
//  Created by steven.zhuang on 8/26/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableData (AppendString)

- (void) appendString: (NSString *)string;
- (void) appendDataFromFile: (NSString *)filePath;

@end
