//
//  NSString+Utility.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/31/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

+ (BOOL) isEmptyString: (NSString*)str;
+ (BOOL) isNotEmptyString: (NSString*)str;

- (NSString*) trim;
- (BOOL) isNotEmpty;

@end
