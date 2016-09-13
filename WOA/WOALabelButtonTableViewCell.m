//
//  WOALabelButtonTableViewCell.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOALabelButtonTableViewCell.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOALabelButtonTableViewCell ()

@property (nonatomic, assign) NSInteger itemHeight;

@end


@implementation WOALabelButtonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithDelegate: (NSObject<WOALabelButtonTableViewCellDelegate> *)delegate
                          section: (NSInteger)section
                              row: (NSInteger)row
                    theLabelTitle: (NSString*)theLabelTitle
                   theButtonTitle: (NSString*)theButtonTitle
{
    if (self = [self initWithStyle: UITableViewCellStyleDefault reuseIdentifier: nil])
    {
        self.delegate = delegate;
        self.section = section;
        self.row = row;
        
        UIFont *itemFont = [UIFont systemFontOfSize: kWOALayout_DetailItemFontSize];
        CGSize testSize = [WOALayout sizeForText: @"T" width: 20 font: itemFont];
        self.itemHeight = ceilf(testSize.height);
        
        NSDictionary *attribute = @{NSFontAttributeName: itemFont,
                                    NSForegroundColorAttributeName: [UIColor whiteColor]};
        NSAttributedString *buttonAttributedString = [[NSAttributedString alloc] initWithString: theButtonTitle attributes: attribute];
        
        self.theButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_theButton setBackgroundColor: [UIColor redColor]];
        [_theButton setAttributedTitle: buttonAttributedString forState: UIControlStateNormal];
        [_theButton setAttributedTitle: buttonAttributedString forState: UIControlStateHighlighted];
        [_theButton addTarget: self action: @selector(onButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _theButton];
        
        self.theLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        _theLabel.text = theLabelTitle;
        _theLabel.font = itemFont;
        _theLabel.textColor = [UIColor textNormalColor];
        _theLabel.highlightedTextColor = [UIColor textHighlightedColor];
        _theLabel.backgroundColor = [UIColor clearColor];
        _theLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview: _theLabel];
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftMargin = 12;
    CGFloat rightMargin = 4;
    CGFloat itemMargin = 1;
    CGFloat topMargin = 2;
    CGFloat buttonWidth = 40;
    CGFloat buttonOriginX = self.contentView.frame.size.width - rightMargin - buttonWidth;
    CGFloat labelWidth = buttonOriginX - itemMargin -leftMargin;
    
    _theButton.frame = CGRectMake(buttonOriginX, topMargin, buttonWidth, _itemHeight);
    _theLabel.frame = CGRectMake(leftMargin, topMargin, labelWidth, _itemHeight);
}

- (void) onButtonClicked: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(labelButtuonTableViewCell:buttonClick:)])
    {
        [self.delegate labelButtuonTableViewCell: self buttonClick: [(UIButton*)sender tag]];
    }
}

@end
