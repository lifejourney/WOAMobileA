//
//  UILabel+Utility.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "UILabel+Utility.h"
#import "WOALayout.h"

@implementation UILabel (Utility)

+ (UIFont*) defaultLabelFont
{
    UILabel *testLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    
    return testLabel.font;
}

+ (UIFont*) defaultLabelFontWithSize: (CGFloat)fontSize
{
    UILabel *testLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    UIFont *labelFont = [testLabel.font fontWithSize: fontSize];
    
    return labelFont;
}

+ (UILabel*) labelByFixWidth: (CGFloat)width
                    fontSize: (CGFloat)fontSize
                       title: (NSString*)title
{
    UIFont *labelFont = [self defaultLabelFontWithSize: fontSize];
    CGSize labelSize = [WOALayout sizeForText: title
                                        width: width
                                         font: labelFont];
    UILabel *resultLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, labelSize.width, labelSize.height)];
    resultLabel.font = labelFont;
    resultLabel.lineBreakMode = NSLineBreakByWordWrapping;
    resultLabel.numberOfLines = 0;
    resultLabel.text = title;
    resultLabel.textAlignment = NSTextAlignmentLeft;
    
    return resultLabel;
}

@end
