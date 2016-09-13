//
//  WOAFileSelectorView.h
//  WOAMobile
//
//  Created by steven.zhuang on 9/18/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAHostNavigationDelegate.h"
#import <UIKit/UIKit.h>


@class WOAFileSelectorView;

@protocol WOAFileSelectorViewDelegate <WOAHostNavigationDelegate>

@required

- (NSArray*) fileInfoArray;

@optional

- (void) fileSelectorView: (WOAFileSelectorView*)fileSelectorView
              addFilePath: (NSString*)filePath
                withTitle: (NSString*)title;

- (void) fileSelectorView: (WOAFileSelectorView*)fileSelectorView
              deleteAtRow: (NSInteger)row;

@end


@interface WOAFileSelectorView : UIView

@property (nonatomic, weak) id<WOAFileSelectorViewDelegate> delegate;

- (instancetype) initWithFrame: (CGRect)frame
                      delegate: (id<WOAFileSelectorViewDelegate>)delegate;

- (void) fileInfoUpdated;

@end
