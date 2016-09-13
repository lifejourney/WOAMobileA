//
//  WOALayout.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/8/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@implementation WOALayout

+ (CGRect) rectForNavigationTitleView
{
    return CGRectMake(0, 0, 100, 30);
}

+ (CGSize) sizeForText: (NSString*)text width: (CGFloat)width font: (UIFont*)font
{
    CGFloat height = kWOALayout_ItemCommonHeight;
    CGSize size;
    
    if (text && font)
    {
        NSDictionary *attribute = @{NSFontAttributeName: font};
        
        CGRect rect = [text boundingRectWithSize: CGSizeMake(width, 0)
                                         options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes: attribute
                                         context: nil];
        
        size = rect.size;
    }
    else
    {
        size = CGSizeMake(width, height);
    }
    
    return size;
}

+ (CGFloat) simpleMaxHeightForTextArray: (NSArray*)textArray
                             fixedWidth: (CGFloat)fixedWidth
                                   font: (UIFont*)font
{
    NSString *maxLengthText = @"";
    NSUInteger length = 0;
    for (NSInteger index = 0; index < textArray.count; index++)
    {
        NSUInteger textLength = [textArray[index] length];
        if (textLength > length)
        {
            length = textLength;
            maxLengthText = textArray[index];
        }
    }
    
    CGSize size = [self sizeForText: maxLengthText
                              width: fixedWidth
                               font: font];
    
    return size.height;
}

+ (UILabel*) lableForNavigationTitleView: (NSString*)text
{
    UILabel *titleView = [[UILabel alloc] initWithFrame: [WOALayout rectForNavigationTitleView]];
    titleView.textColor = [UIColor navigationItemNormalColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = text;
    
    return titleView;
}

+ (UIBarButtonItem*) backBarButtonItemWithTarget:(id)target action:(SEL)action
{
    UIImage *img = [[UIImage imageNamed: @"BackIndicatorIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    
    UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 44, 44)];
    [btn setImage: img forState: UIControlStateNormal];
    [btn setImage: img forState: UIControlStateHighlighted];
    [btn setTitle: @"返回" forState: UIControlStateNormal];
    //TO-DO: highlighted
    [btn addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView: btn];
    
    
    return barButtonItem;
}

@end
