//
//  WOALayout.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/8/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#define kWOALayout_DefaultLeftMargin 10
#define kWOALayout_DefaultRightMargin 10
#define kWOALayout_DefaultTopMargin 10
#define kWOALayout_DefaultBottomMargin 10

#define kWOALayout_ItemCommonHeight (24)
#define kWOALayout_ItemDetailHeight (16)
#define kWOALayout_ItemLabelWidth (80)
#define kWOALayout_ItemTopMargin (4)
#define kWOALayout_ItemLabelTextField_Gap (2)

#define kWOALayout_TitleItemFontSize (18.0f)
#define kWOALayout_DetailItemFontSize (12.0f)

#define kWOADefaultDateFormat @"YYYY-MM-dd"
#define kWOADefaultTimeFormat @"hh:mm"
#define kWOADefaultDateTimeFormat @"YYYY-MM-dd hh:mm"

@interface WOALayout : NSObject

+ (CGRect) rectForNavigationTitleView;
+ (CGSize) sizeForText: (NSString*)text
                 width: (CGFloat)width
                  font: (UIFont*)font;
+ (CGFloat) simpleMaxHeightForTextArray: (NSArray*)textArray
                             fixedWidth: (CGFloat)fixedWidth
                                   font: (UIFont*)font;
+ (UILabel*) lableForNavigationTitleView: (NSString*)text;
+ (UIBarButtonItem*) backBarButtonItemWithTarget:(id)target action:(SEL)action;

+ (UIFont*) flowCellTextFont;

@end
