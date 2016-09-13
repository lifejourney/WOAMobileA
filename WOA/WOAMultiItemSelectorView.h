//
//  WOAMultiItemSelectorView.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/18/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAHostNavigationDelegate.h"
#import <UIKit/UIKit.h>


@interface WOAMultiItemSelectorView : UIView

@property (nonatomic, weak) id<WOAHostNavigationDelegate> delegate;

@property (nonatomic, strong) NSArray *selectedValueArray;

- (instancetype) initWithFrame: (CGRect)frame
                      delegate: (id<WOAHostNavigationDelegate>)delegate
                     itemArray: (NSArray*)itemArray
                  defaultArray: (NSArray*)defaultArray;

@end
