//
//  WOAFlowListViewController.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@protocol WOAFlowListViewControllerDelegate <NSObject>

- (void) flowListViewControllerSelectRowAtIndexPath: (NSIndexPath*)indexPath //Notice: indexPath for filtered Array.
                                       selectedPair: (WOANameValuePair*)selectedPair
                                        relatedDict: (NSDictionary*)relatedDict
                                              navVC: (UINavigationController*)navVC;

@end

@interface WOAFlowListViewController : UIViewController

@property (nonatomic, assign) BOOL shouldShowSearchBar;
@property (nonatomic, strong) UIFont *textLabelFont;

//For contentModel.pairArray
//If pairArray[].value is a ContentModel type, it would be a grounped list. M(T, [(Name, M(T, [Name, Value]))])
//Else M(T, [Name, Value])
+ (instancetype) flowListViewController: (WOAContentModel*)contentModel //M(T, [M(T, [M(T, S])])
                               delegate: (NSObject<WOAFlowListViewControllerDelegate> *)delegate
                            relatedDict: (NSDictionary*)relatedDict;

@end
