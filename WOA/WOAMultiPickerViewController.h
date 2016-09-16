//
//  WOAMultiPickerViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@class WOAMultiPickerViewController;

@protocol WOAMultiPickerViewControllerDelegate <NSObject>

- (void) multiPickerViewController: (WOAMultiPickerViewController*)pickerViewController
                        actionType: (WOAModelActionType)actionType
                 selectedPairArray: (NSArray*)selectedPairArray
                       relatedDict: (NSDictionary*)relatedDict
                             navVC: (UINavigationController*)navVC;

- (void) multiPickerViewControllerCancelled: (WOAMultiPickerViewController*)pickerViewController
                                      navVC: (UINavigationController*)navVC;

@end

@interface WOAMultiPickerViewController : UIViewController

//For contentModel.pairArray
//If pairArray[].value is a ContentModel type, it would be a grounped list. M(T, [(Name, M(T, [Name, Value]))])
//Else M(T, [Name, Value])

+ (instancetype) multiPickerViewController: (WOAContentModel*)contentModel //M(T, [M(T, [M(T, S])])
                    selectedIndexPathArray: (NSArray*)selectedIndexPathArray
                                  delegate: (NSObject<WOAMultiPickerViewControllerDelegate>*)delegate
                               relatedDict: (NSDictionary*)relatedDict;

@end
