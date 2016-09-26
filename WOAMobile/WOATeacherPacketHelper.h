//
//  WOATeacherPacketHelper.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/16/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOAPacketHelper.h"


@interface WOATeacherPacketHelper: WOAPacketHelper

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryOAList: (NSDictionary*)respDict
                          pairActionType: (WOAModelActionType)pairActionType;
+ (NSArray*) itemPairsForTchrQueryOATableList: (NSDictionary*)respDict
                               pairActionType: (WOAModelActionType)pairActionType;
+ (NSArray*) itemPairsForTchrNewOATask: (NSDictionary*)respDict
                        pairActionType: (WOAModelActionType)pairActionType;

@end






