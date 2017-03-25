//
//  WOAURLNavigationViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"
#import <UIKit/UIKit.h>

@class WOAURLNavigationViewController;

@protocol WOAURLNavigationViewControllerDelegate <NSObject>

@optional

- (void) urlNavigationViewController: (WOAURLNavigationViewController*)vc
                          actionType: (WOAActionType)actionType
                         relatedDict: (NSDictionary*)relatedDict;

@end

@interface WOAURLNavigationViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@property (nonatomic, weak) NSObject<WOAURLNavigationViewControllerDelegate> *delegate;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *urlTitle;
@property (nonatomic, strong) WOAContentModel *contentModel;

- (void) navigateURL: (NSURL*)url;

@end
