//
//  WOAListDetailViewController.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/23/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAListDetailViewController.h"
#import "WOASimpleListViewController.h"
#import "WOAContentViewController.h"
#import "WOAContentModel.h"
#import "WOANameValuePair.h"
#import "WOALayout.h"
#import "UITableView+Utility.h"
#import "UILabel+Utility.h"
#import "UIColor+AppTheme.h"
#import "NSString+Utility.h"


@interface WOAListDetailViewController () <UITableViewDataSource, UITableViewDelegate,
                                            WOAContentViewControllerDelegate,
                                            WOAUploadAttachmentRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) WOAListDetailStyle detailStyle;

@end

@implementation WOAListDetailViewController

#pragma mark - lifecycle

+ (instancetype) listViewController: (NSString*)title
                          pairArray: (NSArray*)pairArray
                        detailStyle: (WOAListDetailStyle)detailStyle
{
    WOAListDetailViewController *vc = [[WOAListDetailViewController alloc] init];
    vc.title = title;
    vc.pairArray = pairArray;
    vc.detailStyle = detailStyle;
    
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype) init
{
    if (self = [self initWithNibName: nil bundle: nil])
    {
        
    }
    
    return self;
}

#pragma mark - private

#pragma mark - delegte

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [WOALayout lableForNavigationTitleView: self.title];
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect visibleRect = self.view.frame;
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    visibleRect.size.height -= tabbarHeight;
    [_tableView setFrame: visibleRect];
    
    [self.view addSubview: _tableView];
    
    [self.tableView reloadData];
}

#pragma mark - table view datasource

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    return self.pairArray ? [self.pairArray count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellWithIdentifier: @"listDetailTableViewCellIdentifier"
                                                cellStyle: UITableViewCellStyleValue1];
    
    WOANameValuePair *pair = [self.pairArray objectAtIndex: indexPath.row];
    NSString *rowTitle = pair.name;
    NSArray *modelArray = (NSArray*)pair.value;
    
    cell.textLabel.text = rowTitle;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    cell.accessoryType = (modelArray && [modelArray count] > 0) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor mainItemBgColor];
    cell.textLabel.highlightedTextColor = [UIColor mainItemColor];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    WOANameValuePair *pair = [self.pairArray objectAtIndex: indexPath.row];
    NSString *rowTitle = pair.name;
    
    return (rowTitle && ([rowTitle length] > 0)) ? 44 : 20;
}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
    
    WOANameValuePair *pair = [self.pairArray objectAtIndex: indexPath.row];
    NSString *rowTitle = pair.name;
    NSArray *modelArray = (NSArray*)pair.value;
    
    if (modelArray && [modelArray count] > 0)
    {
        UIViewController *detailVC = nil;
        
        WOAContentModel *contentModel = [WOAContentModel contentModel: rowTitle
                                                         contentArray: modelArray];
        
        if (_detailStyle == WOAListDetailStyleSimple)
        {
            detailVC = [WOASimpleListViewController listViewController: contentModel
                                                             cellStyle: UITableViewCellStyleDefault];
        }
        else if (_detailStyle == WOAListDetailStyleSettings)
        {
            detailVC = [WOASimpleListViewController listViewController: contentModel
                                                             cellStyle: UITableViewCellStyleValue1];
        }
        else if (_detailStyle == WOAListDetailStyleSubtitle)
        {
            detailVC = [WOASimpleListViewController listViewController: contentModel
                                                             cellStyle: UITableViewCellStyleSubtitle];
        }
        else if (_detailStyle == WOAListDetailStyleContent)
        {
            detailVC = [WOAContentViewController contentViewController: contentModel
                                                              delegate: self];
        }
        
        if (detailVC)
        {
            [self.navigationController pushViewController: detailVC animated: YES];
        }
    }
}


#pragma mark - WOAUploadAttachmentRequestDelegate

- (void) requestUploadAttachment: (WOAActionType)contentActionType
                   filePathArray: (NSArray*)filePathArray
                      titleArray: (NSArray*)titleArray
                  additionalDict: (NSDictionary*)additionalDict
                    onCompletion: (void (^)(BOOL isSuccess, NSArray *urlArray))completionHandler
{
}

#pragma mark - WOAContentViewControllerDelegate

- (void) contentViewController: (WOAContentViewController*)vc
//              rightButtonClick: (WOAContentModel*)contentModel
                    actionType: (WOAActionType)actionType
                 submitContent: (NSDictionary*)contentDict
                   relatedDict: (NSDictionary*)relatedDict
{
}

#pragma mark - public


@end
