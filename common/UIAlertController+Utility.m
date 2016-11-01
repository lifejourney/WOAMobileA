//
//  UIAlertController+Utility.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 10/5/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "UIAlertController+Utility.h"

@implementation UIAlertController (Utility)

+ (UIAlertController*) alertControllerWithTitle: (nullable NSString*)alertTitle
                                   alertMessage: (nullable NSString*)alertMessage
                                     actionText: (NSString*)actionText
                                  actionHandler: (void (^ __nullable)(UIAlertAction *action))actionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: alertTitle
                                                                             message: alertMessage
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: actionText
                                                          style: UIAlertActionStyleDefault
                                                        handler: actionHandler];
    
    [alertController addAction: alertAction];
    
    return alertController;
}

+ (void) presentAlertOnVC: (UIViewController*)vc
                    title: (nullable NSString*)alertTitle
             alertMessage: (nullable NSString*)alertMessage
               actionText: (NSString*)actionText
            actionHandler: (void (^ __nullable)(UIAlertAction *action))actionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: alertTitle
                                                                             message: alertMessage
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: actionText
                                                          style: UIAlertActionStyleDefault
                                                        handler: actionHandler];
    
    [alertController addAction: alertAction];
    
    [vc presentViewController: alertController
                     animated: YES
                   completion: nil];
}

@end






