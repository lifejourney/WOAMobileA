//
//  WOAURLNavigationViewController.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/20/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WOAURLNavigationViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *urlTitle;

- (void) navigateURL: (NSURL*)url;

@end
