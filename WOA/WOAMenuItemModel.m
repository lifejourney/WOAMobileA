//
//  WOAMenuItemModel.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAMenuItemModel.h"


@implementation WOAMenuItemModel

+ (WOAMenuItemModel*) menuItemModel: (NSString*)title
                             itemID: (NSString*)itemID
                          imageName: (NSString*)imageName
                      showAccessory: (BOOL)showAccessory
                           delegate: (NSObject*)delegate
                           selector: (SEL)selector
{
    WOAMenuItemModel *item = [[WOAMenuItemModel alloc] init];
    
    item.title = title;
    item.itemID = itemID;
    item.imageName = imageName;
    item.showAccessory = showAccessory;
    item.delegate = delegate;
    item.selector = selector;
    
    return item;
}

+ (WOAMenuItemModel*) menuItemModel: (NSString *)title
                          imageName: (NSString *)imageName
                      showAccessory: (BOOL)showAccessory
                           delegate: (NSObject *)delegate
                           selector: (SEL)selector
{
    return [self menuItemModel: title
                        itemID: nil
                     imageName: imageName
                 showAccessory: showAccessory
                      delegate: delegate
                      selector: selector];
}

+ (WOAMenuItemModel*) menuItemModel: (NSString *)title
                      showAccessory: (BOOL)showAccessory
                           delegate: (NSObject *)delegate
                           selector: (SEL)selector
{
    return [self menuItemModel: title
                        itemID: nil
                     imageName: nil
                 showAccessory: showAccessory
                      delegate: delegate
                      selector: selector];
}

+ (WOAMenuItemModel*) menuItemModel: (NSString *)title
                           delegate: (NSObject *)delegate
                           selector: (SEL)selector
{
    return [self menuItemModel: title
                        itemID: nil
                     imageName: nil
                 showAccessory: NO
                      delegate: delegate
                      selector: selector];
}

+ (WOAMenuItemModel*) seperatorItemModel
{
    return [self menuItemModel: @""
                        itemID: nil
                     imageName: nil
                 showAccessory: NO
                      delegate: nil
                      selector: nil];
}


@end
