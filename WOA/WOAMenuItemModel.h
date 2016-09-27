//
//  WOAMenuItemModel.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/4/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WOAMenuItemModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *itemID; //funcName
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) BOOL showAccessory;
@property (nonatomic, weak) NSObject *delegate;
@property (nonatomic, assign) SEL selector;

+ (WOAMenuItemModel*) menuItemModel: (NSString*)title
                             itemID: (NSString*)itemID
                          imageName: (NSString*)imageName
                      showAccessory: (BOOL)showAccessory
                           delegate: (NSObject*)delegate
                           selector: (SEL)selector;

+ (WOAMenuItemModel*) menuItemModel: (NSString *)title
                          imageName: (NSString *)imageName
                      showAccessory: (BOOL)showAccessory
                           delegate: (NSObject *)delegate
                           selector: (SEL)selector;

+ (WOAMenuItemModel*) menuItemModel: (NSString *)title
                      showAccessory: (BOOL)showAccessory
                           delegate: (NSObject *)delegate
                           selector: (SEL)selector;

+ (WOAMenuItemModel*) menuItemModel: (NSString *)title
                           delegate: (NSObject *)delegate
                           selector: (SEL)selector;

+ (WOAMenuItemModel*) seperatorItemModel;

@end
