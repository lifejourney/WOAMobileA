//
//  VSSelectedTableViewCell.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "VSSelectedTableViewCell.h"

@implementation VSSelectedTableViewCell

- (id) initWithStyle: (UITableViewCellStyle)style
     reuseIdentifier: (NSString *)reuseIdentifier
       checkedButton: (BOOL)checkedButton
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectButton = [UIButton buttonWithType: UIButtonTypeCustom];
        
        _selectButton.selected = checkedButton;
        
        UIImage *selectedImage = [[UIImage imageNamed: @"checkedIcon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [_selectButton setImage: nil forState: UIControlStateNormal];
        [_selectButton setImage: selectedImage forState: UIControlStateSelected];
        [_selectButton setAdjustsImageWhenHighlighted: NO];
        [_selectButton addTarget: self action: @selector(selectButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: _selectButton];
        
        self.contentLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview: _contentLabel];
    }
    return self;
}

- (instancetype) initWithStyle: (UITableViewCellStyle)style
               reuseIdentifier: (NSString *)reuseIdentifier
                       section: (NSInteger)section
                           row: (NSInteger)row
                 checkedButton: (BOOL)checkedButton
                      delegate: (NSObject<VSSelectedTableViewCellDelegate>*)delegate
{
    if (self = [self initWithStyle: style reuseIdentifier: reuseIdentifier checkedButton: checkedButton])
    {
        self.section = section;
        self.row = row;
        self.delegate = delegate;
    }
    
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftMargin = 10;
    CGFloat topMargin = 6;
    CGFloat imgWidth = 20;
    CGFloat labelHeight = 32;
    CGFloat labelOriginX = leftMargin + imgWidth + 1;
    CGFloat labelWidth = self.contentView.frame.size.width - labelOriginX;
    self.selectButton.frame = CGRectMake(leftMargin, topMargin, imgWidth, labelHeight);
    self.contentLabel.frame = CGRectMake(labelOriginX, topMargin, labelWidth, labelHeight);
}

- (void)setSelected: (BOOL)selected animated: (BOOL)animated
{
    [super setSelected: selected animated: animated];

    // Configure the view for the selected state
}

- (void) selectButtonAction: (id)sender
{   
    if (_delegate && [_delegate respondsToSelector: @selector(actionForTableViewCell:)])
    {
        [_delegate actionForTableViewCell: self];
    }
}

@end
