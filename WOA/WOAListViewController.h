//
//  WOAListViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WOAListViewControllerDelegate <NSObject>

- (void) listViewControllerClickOnRow: (NSInteger)row;

@end

@interface WOAListViewController : UIViewController

- (id) initWithItemArray: (NSArray*)itemArray delegate: (NSObject<WOAListViewControllerDelegate>*)delegate;
- (void) selectRow: (NSInteger)row;

@end
