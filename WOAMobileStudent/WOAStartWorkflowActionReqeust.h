//
//  WOAStartWorkflowActionReqeust.h
//  WOAMobile
//
//  Created by steven.zhuang on 6/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WOAStartWorkflowActionReqeust <NSObject>

@required

- (void) sendRequestByActionType;

@end
