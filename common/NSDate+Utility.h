//
//  NSDate+Utility.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 10/1/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultDateFormatStr @"YYYY-MM-dd"
#define kDefaultTimeFormatStr @"hh:mm"

@interface NSDate (Utility)

+ (NSDate*) dateFromString: (NSString*)dateStr
              formatString: (NSString*)formatStr;
- (NSString*) dateStringWithFormat: (NSString*)formatStr;

@end
