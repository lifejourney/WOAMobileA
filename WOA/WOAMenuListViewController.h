//
//  WOAMenuListViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/1/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOAMenuListViewController : UIViewController

@property (nonatomic, strong) NSArray *itemArray;

+ (WOAMenuListViewController*) menuListViewController: (NSString*)title
                                            itemArray: (NSArray*)itemArray;

@end
