//
//  WOATeacherPacketHelper.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/16/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "WOATeacherPacketHelper.h"
#import "NSString+PinyinInitial.h"


@interface WOATeacherPacketHelper ()

@end


@implementation WOATeacherPacketHelper

#pragma mark -

+ (NSArray*) itemPairsForTchrQueryTodoOA: (NSDictionary*)respDict
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *itemName = [self formTitleFromDictionary: itemDict];
        NSString *itemID = [self itemIDFromDictionary: itemDict];
        NSString *pinyinInitial = [itemName pinyinInitials];
        NSString *subValue = [NSString stringWithFormat: @"%@ %@",
                              [self abstractFromDictionary: itemDict],
                              [self createTimeFromDictionary: itemDict]];
        NSDictionary *pairValue = @{kWOAKeyForItemID: itemID,
                                    kWOAKeyForSubValue: subValue,
                                    kWOAKeyForPinyinInitial: pinyinInitial};
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: pairValue
                                                     isWritable: NO
                                                       subArray: nil
                                                        subDict: nil
                                                       dataType: WOAPairDataType_Dictionary
                                                     actionType: WOAModelActionType_TeacherQueryOADetail];
        
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

@end






