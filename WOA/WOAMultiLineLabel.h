//
//  WOAMultiLineLabel.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAHostNavigationDelegate.h"
#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@interface WOAMultiLineLabel : UIView

@property (nonatomic, weak) NSObject<WOAHostNavigationDelegate> *delegate;
@property (nonatomic, strong) WOAContentModel *contentModel;

- (instancetype) initWithFrame: (CGRect)frame
                  contentModel: (WOAContentModel*)contentModel;

@end
