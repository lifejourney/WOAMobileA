//
//  VSSelectedTableViewCell.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VSSelectedTableViewCell;

@protocol VSSelectedTableViewCellDelegate <NSObject>

- (void) actionForTableViewCell: (VSSelectedTableViewCell*)tableViewCell;

@end

@interface VSSelectedTableViewCell : UITableViewCell

@property (nonatomic, weak) NSObject<VSSelectedTableViewCellDelegate> *delegate;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *contentLabel;

- (instancetype) initWithStyle: (UITableViewCellStyle)style
               reuseIdentifier:(NSString *)reuseIdentifier
                       section: (NSInteger)section
                           row: (NSInteger)row
                 checkedButton: (BOOL)checkedButton
                      delegate: (NSObject<VSSelectedTableViewCellDelegate>*)delegate;

@end
