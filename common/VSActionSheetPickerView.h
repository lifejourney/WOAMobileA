//
//  VSActionSheetPickerView.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/12/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface VSActionSheetPickerView : NSObject

- (void) shownPickerViewInView: (UIView*)view
                     dataModel: (NSArray*)dataModel
                   selectedRow: (NSInteger) selectedRow
               selectedHandler: (void (^)(NSInteger row))selectedHandler
              cancelledHandler: (void (^)())cancelledHandler;
@end
