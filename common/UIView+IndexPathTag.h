//
//  UIView+IndexPathTag.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 2/13/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IndexPathTag)

+ (NSIndexPath*) indexPathByTag: (NSInteger)tag;
+ (NSIndexPath*) indexPathByTagE: (NSInteger)tag;
+ (NSInteger) tagByIndexPath: (NSIndexPath*)indexPath;
+ (NSInteger) tagByIndexPathE: (NSIndexPath*)indexPath;

@end
