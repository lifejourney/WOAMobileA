//
//  WOALevel3TreeViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/25/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import <UIKit/UIKit.h>


@class WOALevel3TreeViewController;

@protocol WOALevel3TreeViewControllerDelegate <NSObject>

- (void) level3TreeViewControllerSubmit: (WOAContentModel*)contentModel
                            relatedDict: (NSDictionary*)relatedDict
                                  navVC: (UINavigationController*)navVC;

- (void) level3TreeViewControllerCancelled: (WOAContentModel*)contentModel
                                     navVC: (UINavigationController*)navVC;

@end

@interface WOALevel3TreeViewController : UIViewController

@property (nonatomic, assign) BOOL shouldShowBackBarItem;

/*For contentModel.pairArray
 name->value
       subArray: name-> value
                        subArray: name->value
 NOTE: the tagNumber could be modified.
 */
+ (instancetype) level3TreeViewController: (WOAContentModel*)contentModel
                                 delegate: (NSObject<WOALevel3TreeViewControllerDelegate>*)delegate
                              relatedDict: (NSDictionary*)relatedDict;

@end
