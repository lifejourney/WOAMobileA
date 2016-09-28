//
//  WOASinglePickerViewControllerDelegate.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/27/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol WOASinglePickerViewControllerDelegate <NSObject>

@required

- (void) singlePickerViewControllerSelected: (NSIndexPath*)indexPath //Notice: indexPath for filtered Array.
                               selectedPair: (WOANameValuePair*)selectedPair
                                relatedDict: (NSDictionary*)relatedDict
                                      navVC: (UINavigationController*)navVC;

@end



