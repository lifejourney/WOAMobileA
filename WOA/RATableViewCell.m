//
//  RATableViewCell.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 10/30/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//


#import "RATableViewCell.h"
#import "UIColor+AppTheme.h"


@interface RATableViewCell ()

@property (nonatomic, assign) CGFloat leftIndent;

@end

@implementation RATableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.expandedButton.hidden = NO;
    self.selectedButton.hidden = NO;
}

- (void) updateComponentsPosition
{
    CGFloat left = self.leftIndent;
    
    if (!self.selectedButton.hidden)
    {
        CGRect frame = self.selectedButton.frame;
        frame.origin.x = left;
        self.selectedButton.frame = frame;
        
        left += frame.size.width;
    }
    
    if (!self.expandedButton.hidden)
    {
        CGRect frame = self.expandedButton.frame;
        frame.origin.x = left;
        self.expandedButton.frame = frame;
        
        left += frame.size.width;
    }
    
    CGRect titleFrame = self.customTitleLabel.frame;
    titleFrame.origin.x = left;
    self.customTitleLabel.frame = titleFrame;
    
    //    CGRect detailsFrame = self.detailedLabel.frame;
    //    detailsFrame.origin.x = left;
    //    self.detailedLabel.frame = detailsFrame;
    
}

- (void) setupWithTitle: (NSString *)title
             detailText: (NSString *)detailText
                  level: (NSInteger)level
           expandHidden: (BOOL)expandHidden
           selectHidden: (BOOL)selectHidden
{
    self.customTitleLabel.text = title;
    
    self.expandedButton.hidden = expandHidden;
    self.selectedButton.hidden = selectHidden;
    
    if (level == 0)
    {
        //self.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    if (level == 0)
    {
        self.backgroundColor = [UIColor colorFromRGB: 0xF7F7F7];
    }
    else if (level == 1)
    {
        self.backgroundColor = [UIColor colorFromRGB: 0xD1EEFC];
    }
    else if (level >= 2)
    {
        self.backgroundColor = [UIColor colorFromRGB: 0xE0F8D8];
    }
    
    self.leftIndent = 11 + 20 * level;
    
    [self updateComponentsPosition];
}

#pragma mark - Actions

- (IBAction) expandButtonTapped: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(onRATableViewCellTapExpandButton:)])
    {
        [self.delegate onRATableViewCellTapExpandButton: self];
    }
}

- (IBAction) selectButtonTapped: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(onRATableViewCellTapSelectButton:)])
    {
        [self.delegate onRATableViewCellTapSelectButton: self];
    }
}

@end






