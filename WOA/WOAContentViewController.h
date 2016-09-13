//
//  WOAContentViewController.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/31/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WOAContentModel.h"

@interface WOAContentViewController : UIViewController

@property (nonatomic, strong) NSDictionary *baseRequestDict;
@property (nonatomic, assign) WOAModelActionType rightButtonAction;
@property (nonatomic, copy) NSString *rightButtonTitle;

+ (instancetype) contentViewController: (NSString*)title
                            isEditable: (BOOL)isEditable //Content view is in readonly model or not
                            modelArray: (NSArray*)modelArray; //Array of WOAContentModel

@end

