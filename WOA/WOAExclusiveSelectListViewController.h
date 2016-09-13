//
//  WOAExclusiveSelectListViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@protocol WOAExclusiveSelectListViewControllerDelegate <NSObject>

- (void) listViewControllerClickOnRowOnIndexPath: (NSIndexPath*)row;

@end

@interface WOAExclusiveSelectListViewController : UIViewController

@property (nonatomic, strong) NSDictionary *baseRequestDict;

+ (instancetype) listWithItemArray: (NSArray *)itemArray //Array of WOAContentModel
                          delegate: (NSObject<WOAExclusiveSelectListViewControllerDelegate> *)delegate
                  defaultIndexPath: (NSIndexPath *)defaultIndexPath;

- (void) selectIndexPath: (NSIndexPath*)indexPath;

@end
