//
//  WOAContentModel.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 1/31/16.
//  Copyright (c) 2016 steven.zhuang. All rights reserved.
//

#import "WOAContentModel.h"


@implementation WOAContentModel


+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray
                   actionType: (WOAModelActionType)actionType
{
    WOAContentModel *model = [[WOAContentModel alloc] init];
    model.groupTitle = groupTitle;
    model.pairArray = pairArray;
    model.actionType = actionType;
    
    return model;
}

+ (instancetype) contentModel: (NSString *)groupTitle
                    pairArray: (NSArray *)pairArray
{
    return [self contentModel: groupTitle
                    pairArray: pairArray
                   actionType: WOAModelActionType_None];
}

- (void) addPair: (WOANameValuePair*)pair
{
    NSMutableArray *newArray = [NSMutableArray arrayWithArray: self.pairArray];
    
    if (pair)
    {
        [newArray addObject: pair];
    }
    
    self.pairArray = newArray;
}

- (WOANameValuePair*) pairForName: (NSString*)name;
{
    WOANameValuePair *firstPair = nil;
    
    if (name)
    {
        for (WOANameValuePair *pair in _pairArray)
        {
            if ([pair.name isEqualToString: name])
            {
                firstPair = pair;
                
                break;
            }
        }
    }
    
    return firstPair;
}

- (NSString*) stringValueForName: (NSString*)name
{
    WOANameValuePair *pair = [self pairForName: name];
    
    return [pair stringValue];
}

- (WOANameValuePair*) toNameValuePair
{
    WOANameValuePair *pair = [WOANameValuePair pairWithName: self.groupTitle
                                                      value: self
                                                   dataType: WOAPairDataType_ContentModel];
    pair.actionType = self.actionType;
    
    return pair;
}

#pragma mark -

- (NSString*) description
{
    NSMutableDictionary *descDict = [NSMutableDictionary dictionary];
    [descDict setValue: _groupTitle ? _groupTitle : @""
                forKey: @"groupTitle"];
    
    NSMutableArray *pairsDescArr = [NSMutableArray array];
    for (NSUInteger index = 0; index < [self.pairArray count]; index++)
    {
        WOANameValuePair *pair = [self.pairArray objectAtIndex: index];
        
        [pairsDescArr addObject: [pair stringValue]];
    }
    
    [descDict setValue: pairsDescArr
                forKey: @"pairArray"];
    
    [descDict setValue: [NSNumber numberWithInteger: self.actionType]
                forKey: @"actionType"];
    
    return [NSString stringWithFormat:@"%@: %@", [super description], descDict];
}

@end
