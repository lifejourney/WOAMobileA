//
//  RATableViewCell.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 10/30/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RATableViewCell;

@protocol RATableViewCellDelegate <NSObject>

- (void) onRATableViewCellTapExpandButton: (RATableViewCell*)cell;
- (void) onRATableViewCellTapSelectButton: (RATableViewCell*)cell;

@end

@interface RATableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *customTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandedButton;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (nonatomic, weak) NSObject<RATableViewCellDelegate> *delegate;

- (void) setupWithTitle: (NSString *)title
             detailText: (NSString *)detailText
                  level: (NSInteger)level
             isExpanded: (BOOL)isExpanded
           expandHidden: (BOOL)expandHidden
             isSelected: (BOOL)isSelected
           selectHidden: (BOOL)selectHidden;

@end
