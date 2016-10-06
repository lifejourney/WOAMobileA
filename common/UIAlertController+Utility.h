//
//  UIAlertController+Utility.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 10/5/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Utility)

+ (UIAlertController*) alertControllerWithTitle: (nullable NSString*)alertTitle
                                   alertMessage: (nullable NSString*)alertMessage
                                     actionText: (NSString*)actionText
                                  actionHandler: (void (^ __nullable)(UIAlertAction *action))actionHandler;
@end

NS_ASSUME_NONNULL_END




