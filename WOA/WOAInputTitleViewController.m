//
//  WOAInputTitleViewController.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/15/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAInputTitleViewController.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"


@interface WOAInputTitleViewController ()

@property (nonatomic, strong) UITextField *titleTextField;

@property (nonatomic, weak) id<WOAInputTitleViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) CGFloat itemHeight;

@end


@implementation WOAInputTitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype) initWithFilePath: (NSString*)filePath delegate: (id<WOAInputTitleViewControllerDelegate>)delegate
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        self.filePath = filePath;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"确定"
                                                                           style: UIBarButtonItemStylePlain
                                                                          target: self
                                                                          action: @selector(submitAction:)];
    self.navigationItem.leftBarButtonItem = [WOALayout backBarButtonItemWithTarget: self action: @selector(backAction:)];
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: @""];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIFont *itemFont = [UIFont systemFontOfSize: kWOALayout_DetailItemFontSize];
    CGSize testSize = [WOALayout sizeForText: @"T" width: 20 font: itemFont];
    self.itemHeight = ceilf(testSize.height);
    
    CGRect navRect = self.navigationController.navigationBar.frame;
    CGFloat contentTopMargin = self.navigationController.navigationBar.isHidden ? 0 : (navRect.origin.y + navRect.size.height);
    CGFloat textWidth = 280;
    CGFloat labelHeight = self.itemHeight;
    CGRect labelRect = CGRectMake(kWOALayout_DefaultLeftMargin,
                                  contentTopMargin + kWOALayout_DefaultTopMargin,
                                  textWidth,
                                  labelHeight);
    CGRect titleRect = CGRectMake(kWOALayout_DefaultLeftMargin,
                                  contentTopMargin + kWOALayout_DefaultTopMargin + labelHeight,
                                  textWidth,
                                  kWOALayout_ItemCommonHeight);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: labelRect];
    titleLabel.font = itemFont;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"输入附件标题:";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview: titleLabel];
    
    self.titleTextField = [[UITextField alloc] initWithFrame: titleRect];
    _titleTextField.text = [self.filePath lastPathComponent];
    _titleTextField.font = itemFont;
    _titleTextField.borderStyle = UITextBorderStyleRoundedRect;
    _titleTextField.backgroundColor = [UIColor whiteColor];
    [_titleTextField setTextColor: [UIColor blackColor]];
    [self.view addSubview: _titleTextField];
    
    [self.view setBackgroundColor: [UIColor listDarkBgColor]];
    
    [self.titleTextField becomeFirstResponder];
}

- (void) submitAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(inputTitleViewController:commitedWithTitle:filePath:)])
    {
        [self.delegate inputTitleViewController: self commitedWithTitle: self.titleTextField.text filePath: self.filePath];
    }
}

- (void) backAction: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(inputTitleViewControllerCancelled:)])
    {
        [self.delegate inputTitleViewControllerCancelled: self];
    }
}

@end
