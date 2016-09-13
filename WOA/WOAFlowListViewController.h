//
//  WOAFlowListViewController.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WOAFlowListViewController : UIViewController

@property (nonatomic, strong) NSArray *pairArray;

+ (instancetype) flowListViewController: (NSString*)title
                              pairArray: (NSArray*)pairArray; //array of WOANameValuePair, value of pair is array of WOAContentModel;

@end
