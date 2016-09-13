//
//  WOAListDetailViewController.h
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WOAListDetailStyle)
{
    WOAListDetailStyleSimple,
    WOAListDetailStyleSettings,
    WOAListDetailStyleSubtitle,
    WOAListDetailStyleContent
};

@interface WOAListDetailViewController : UIViewController

@property (nonatomic, strong) NSArray *pairArray;

+ (instancetype) listViewController: (NSString*)title
                          pairArray: (NSArray*)pairArray //array of WOANameValuePair, value of pair is array of WOAContentModel
                        detailStyle: (WOAListDetailStyle)detailStyle;

@end
