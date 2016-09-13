//
//  WOALabelButtonTableViewCell.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WOALabelButtonTableViewCell;

@protocol WOALabelButtonTableViewCellDelegate <NSObject>

- (void) labelButtuonTableViewCell: (WOALabelButtonTableViewCell*)cell buttonClick: (NSInteger)tag;

@end


@interface WOALabelButtonTableViewCell : UITableViewCell

@property (nonatomic, weak) NSObject<WOALabelButtonTableViewCellDelegate> *delegate;
@property (nonatomic, strong) UILabel *theLabel;
@property (nonatomic, strong) UIButton *theButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;

- (instancetype) initWithDelegate: (NSObject<WOALabelButtonTableViewCellDelegate>*)delegate
                          section: (NSInteger)section
                              row: (NSInteger)row
                    theLabelTitle: (NSString*)theLabelTitle
                   theButtonTitle: (NSString*)theButtonTitle;

@end
