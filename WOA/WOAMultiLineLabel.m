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
#import "WOAPacketHelper.h"
#import "WOAPropertyInfo.h"


@interface WOAMultiLineLabel () <WOALinkLabelDelegate>

@property (nonatomic, assign) BOOL isAttachment;

@end


@implementation WOAMultiLineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (NSString*) titleByIndex: (NSInteger)index
{
    NSString *title;
    
    if (index >= 0 & index < [_textsArray count])
    {
        NSDictionary *info = [_textsArray objectAtIndex: index];
        title = [WOAPacketHelper attachmentTitleFromDictionary: info];
    }
    else
        title = nil;
    
    return title;
}

- (NSString*) URLByIndex: (NSInteger)index
{
    NSString *URLString;
    
    if (index >= 0 & index < [_textsArray count])
    {
        NSDictionary *info = [_textsArray objectAtIndex: index];
        URLString = [WOAPacketHelper attachmentURLFromDictionary: info];
    }
    else
        URLString = nil;
    
    return URLString;
}

- (instancetype) initWithFrame: (CGRect)frame
                    textsArray: (NSArray*)textsArray
                  isAttachment: (BOOL)isAttachment
{
    if (self = [self initWithFrame: frame])
    {
        self.textsArray = textsArray;
        self.isAttachment = isAttachment;
        
        CGFloat originY = 0;
        
        UILabel *testLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        UIFont *labelFont = [testLabel.font fontWithSize: kWOALayout_DetailItemFontSize];
        
        CGFloat lineMargin = kWOALayout_ItemTopMargin;
        CGFloat viewWidth = frame.size.width;
        CGFloat viewHeight = 0;
        CGFloat onelineWidth = viewWidth;
        CGSize onelineSize;
        for (NSInteger index = 0; index < [textsArray count]; index++)
        {
            NSString *textContent = isAttachment ? [self titleByIndex: index] : [textsArray objectAtIndex: index];
            onelineSize = [WOALayout sizeForText: textContent
                                           width: onelineWidth
                                            font: labelFont];
            
            viewHeight += onelineSize.height + lineMargin;
        }
        
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, viewWidth, viewHeight);
        [self setFrame: selfRect];
        
        for (NSInteger index = 0; index < [textsArray count]; index++)
        {
            NSString *textContent = isAttachment ? [self titleByIndex: index] : [textsArray objectAtIndex: index];
            
            originY += lineMargin;
            
            onelineSize = [WOALayout sizeForText: textContent
                                           width: onelineWidth
                                            font: labelFont];
            CGRect textRect = CGRectMake(0, originY, onelineSize.width, onelineSize.height);
            
            UILabel *oneLineLabel;
            if (isAttachment)
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
            oneLineLabel.userInteractionEnabled = isAttachment;
            
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
    NSString *URLString = [self URLByIndex: tag];
    
    if (URLString)
    {
        URLString = [NSString stringWithFormat: @"%@%@", [WOAPropertyInfo serverAddress], URLString];
        
        NSURL *url = [NSURL URLWithString: URLString];
        
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

@end
