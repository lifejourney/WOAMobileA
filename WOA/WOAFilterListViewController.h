//
//  WOAFilterListViewController.h
//  WOAMobile
//
//  Created by Steven (Shuliang) Zhuang on 9/25/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@protocol WOAFilterListViewControllerDelegate <NSObject>

- (void) filterListViewControllerSelectRowAtIndexPath: (NSIndexPath*)indexPath //Notice: indexPath for filtered Array.
                                         selectedPair: (WOANameValuePair*)selectedPair
                                          relatedDict: (NSDictionary*)relatedDict
                                                navVC: (UINavigationController*)navVC;

@end

@interface WOAFilterListViewController : UIViewController

@property (nonatomic, strong) UIFont *textLabelFont;

//For contentModel.pairArray
//pairArray[].value is a ContentModel type, it is a grounped list. M(T, [(Name, M(T, [Name, Value]))])
+ (instancetype) filterListViewController: (WOAContentModel*)contentModel //M(T, [M(T, [M(T, S])])
                                 delegate: (NSObject<WOAFilterListViewControllerDelegate> *)delegate
                              relatedDict: (NSDictionary*)relatedDict;

@end
