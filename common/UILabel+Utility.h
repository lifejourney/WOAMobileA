//
//  UILabel+Utility.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utility)

+ (UIFont*) defaultLabelFont;
+ (UIFont*) defaultLabelFontWithSize: (CGFloat)fontSize;
+ (UILabel*) labelByFixWidth: (CGFloat)width
                    fontSize: (CGFloat)fontSize
                       title: (NSString*)title;

@end
