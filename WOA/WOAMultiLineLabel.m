//
//  WOAMultiLineLabel.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMultiLineLabel.h"
#import "WOAURLNavigationViewController.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "WOALinkLabel.h"
#import "WOAPropertyInfo.h"
#import "NSString+Utility.h"


@interface WOAMultiLineLabel () <WOALinkLabelDelegate>

@end


@implementation WOAMultiLineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype) initWithFrame: (CGRect)frame
                  contentModel: (WOAContentModel*)contentModel
{
    if (self = [self initWithFrame: frame])
    {
        self.contentModel = contentModel;
        
        CGFloat originY = 0;
        
        UILabel *testLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        UIFont *labelFont = [testLabel.font fontWithSize: kWOALayout_DetailItemFontSize];
        
        CGFloat lineMargin = kWOALayout_ItemTopMargin;
        CGFloat viewWidth = frame.size.width;
        CGFloat viewHeight = 0;
        CGFloat onelineWidth = viewWidth;
        CGSize onelineSize;
        
        NSArray *pairArray = self.contentModel.pairArray;
        
        for (NSInteger index = 0; index < [pairArray count]; index++)
        {
            WOANameValuePair *pair = pairArray[index];
            
            NSString *textContent = pair.name;
            onelineSize = [WOALayout sizeForText: textContent
                                           width: onelineWidth
                                            font: labelFont];
            
            viewHeight += onelineSize.height + lineMargin;
        }
        
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, viewWidth, viewHeight);
        [self setFrame: selfRect];
        
        for (NSInteger index = 0; index < [pairArray count]; index++)
        {
            WOANameValuePair *pair = pairArray[index];
            NSString *textContent = pair.name;
            
            originY += lineMargin;
            
            onelineSize = [WOALayout sizeForText: textContent
                                           width: onelineWidth
                                            font: labelFont];
            CGRect textRect = CGRectMake(0, originY, onelineSize.width, onelineSize.height);
            
            UILabel *oneLineLabel;
            if (pair.actionType == WOAModelActionType_OpenUrl)
            {
                WOALinkLabel *linkLabel = [[WOALinkLabel alloc] initWithFrame: textRect];
                linkLabel.delegate = self;
                
                oneLineLabel = (UILabel*)linkLabel;
            }
            else
            {
                oneLineLabel = [[UILabel alloc] initWithFrame: textRect];
            }
            oneLineLabel.font = labelFont;
            oneLineLabel.lineBreakMode = NSLineBreakByWordWrapping;
            oneLineLabel.numberOfLines = 0;
            oneLineLabel.text = textContent;
            oneLineLabel.tag = index;
            oneLineLabel.textAlignment = NSTextAlignmentLeft;
            oneLineLabel.userInteractionEnabled = (pair.actionType == WOAModelActionType_OpenUrl);
            
            [self addSubview: oneLineLabel];
            
            originY += onelineSize.height;
        }
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void) label: (WOALinkLabel *)label touchesWithTag: (NSInteger)tag
{
    WOANameValuePair *pair = self.contentModel.pairArray[tag];
    
    if (pair.actionType == WOAModelActionType_OpenUrl)
    {
        NSString *urlString = [pair stringValue];
        
        if ([NSString isNotEmptyString: urlString])
        {
            urlString = [NSString stringWithFormat: @"%@%@", [WOAPropertyInfo serverAddress], urlString];
            
            NSURL *url = [NSURL URLWithString: urlString];
            
            if (self.delegate && [self.delegate respondsToSelector: @selector(hostNavigation)])
            {
                WOAURLNavigationViewController *navigationVC = [[WOAURLNavigationViewController alloc] init];
                navigationVC.url = url;
                navigationVC.urlTitle = label.text;
                
                [[self.delegate hostNavigation] pushViewController: navigationVC animated: YES];
            }
            else
            {
                [[UIApplication sharedApplication] openURL: url];
        }
        }
    }
}

@end
