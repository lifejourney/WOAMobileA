//
//  WOALinkLabel.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WOALinkLabel;

@protocol WOALinkLabelDelegate <NSObject>

- (void) label: (WOALinkLabel*)label touchesWithTag: (NSInteger)tag;

@end

@interface WOALinkLabel : UILabel

@property (nonatomic, weak) id <WOALinkLabelDelegate> delegate;

@end
