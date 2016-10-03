//
//  WOASinglePickViewController.h
//  WOAMobile
//
//  Created by Steven (Shuliang) Zhuang on 9/25/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@class WOASinglePickViewController;

@protocol WOASinglePickViewControllerDelegate <NSObject>

@required

- (void) singlePickViewControllerSelected: (WOASinglePickViewController*)vc
                                indexPath: (NSIndexPath*)indexPath //Notice: indexPath for filtered Array.
                             selectedPair: (WOANameValuePair*)selectedPair
                              relatedDict: (NSDictionary*)relatedDict
                                    navVC: (UINavigationController*)navVC;

- (void) singlePickViewControllerSubmit: (WOASinglePickViewController*)vc
                           contentModel: (WOAContentModel*)contentModel
                            relatedDict: (NSDictionary*)relatedDict
                                  navVC: (UINavigationController*)navVC;

@end

@interface WOASinglePickViewController : UIViewController

@property (nonatomic, weak) NSObject<WOASinglePickViewControllerDelegate> *delegate;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WOAContentModel *contentModel;

@property (nonatomic, assign) BOOL shouldShowBackBarItem;
@property (nonatomic, strong) UIFont *textLabelFont;

- (void) refreshTableList;

@end
