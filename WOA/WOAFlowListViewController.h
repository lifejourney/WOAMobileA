//
//  WOAFlowListViewController.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import "WOASinglePickerViewControllerDelegate.h"
#import <UIKit/UIKit.h>


@interface WOAFlowListViewController : UIViewController

@property (nonatomic, assign) BOOL shouldShowSearchBar;
@property (nonatomic, assign) BOOL shouldShowBackBarItem;

@property (nonatomic, assign) UITableViewCellStyle cellStyleForDictValue;
@property (nonatomic, strong) UIFont *textLabelFont;
@property (nonatomic, assign) CGFloat rowHeight;

//For contentModel.pairArray
//If pairArray[].value is a ContentModel type, it would be a grounped list. M(T, [(Name, M(T, [Name, Value]))])
//Else M(T, [Name, Value])
+ (instancetype) flowListViewController: (WOAContentModel*)contentModel //M(T, [M(T, [M(T, S])])
                               delegate: (NSObject<WOASinglePickerViewControllerDelegate> *)delegate
                            relatedDict: (NSDictionary*)relatedDict;

@end
