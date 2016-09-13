//
//  WOAResponeContent.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/5/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WOAFlowDefine.h"


@interface WOAResponeContent : NSObject

@property (nonatomic, assign) WOAFLowActionType flowActionType;

@property (nonatomic, assign) NSInteger HTTPStatus;
@property (nonatomic, assign) WOAHTTPRequestResult requestResult;
@property (nonatomic, copy) NSString *resultDescription;

@property (nonatomic, strong) NSDictionary *bodyDictionary;
@property (nonatomic, strong) NSMutableArray *multiBodyArray;

@end
