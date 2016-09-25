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

+ (NSArray*) itemPairsForTchrQueryOAList: (NSDictionary*)respDict
                          pairActionType: (WOAModelActionType)pairActionType
{
    NSMutableArray *pairArray = [NSMutableArray array];
    NSArray *itemsArray = [self itemsArrayFromPacketDictionary: respDict];
    
    for (NSDictionary *itemDict in itemsArray)
    {
        NSString *itemName = [self formTitleFromDictionary: itemDict];
        NSString *itemID = [self itemIDFromDictionary: itemDict];
        NSString *pinyinInitial = [itemName pinyinInitials];
        
        NSString *abstractText = [self abstractFromDictionary: itemDict];
        NSString *createTime = [self createTimeFromDictionary: itemDict];
        NSString *spacingText = (abstractText && createTime) ? @" " : @"";
        NSString *subValue = [NSString stringWithFormat: @"%@%@%@",
                              abstractText ? abstractText : @"",
                              spacingText,
                              createTime ? createTime: @""];
        
        NSMutableDictionary *pairValue = [NSMutableDictionary dictionary];
        [pairValue setValue: itemID forKey: kWOAKeyForItemID];
        [pairValue setValue: subValue forKey: kWOAKeyForSubValue];
        [pairValue setValue: pinyinInitial forKey: kWOAKeyForPinyinInitial];
        
        WOANameValuePair *pair = [WOANameValuePair pairWithName: itemName
                                                          value: pairValue
                                                     isWritable: NO
                                                       subArray: nil
                                                        subDict: nil
                                                       dataType: WOAPairDataType_Dictionary
                                                     actionType: pairActionType];
        
        [pairArray addObject: pair];
    }
    
    return pairArray;
}

@end






