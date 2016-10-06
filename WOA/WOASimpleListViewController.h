//
//  WOASimpleListViewController.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOAContentModel.h"


@interface WOASimpleListViewController : UIViewController

@property (nonatomic, assign) BOOL shouldShowBackBarItem;

+ (instancetype) listViewController: (WOAContentModel*)contentModel //WOAContentModel values in contentArray
                          cellStyle: (UITableViewCellStyle)cellStyle;

@end
