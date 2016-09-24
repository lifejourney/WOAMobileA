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
                 contentArray: (NSArray*)contentArray
                   actionType: (WOAModelActionType)actionType
                   actionName: (NSString*)actionName
                   isReadonly: (BOOL)isReadonly
                      subDict: (NSDictionary*)subDict
{
    WOAContentModel *model = [[WOAContentModel alloc] init];
    model.groupTitle = groupTitle;
    model.pairArray = pairArray;
    model.contentArray = contentArray;
    model.actionType = actionType;
    model.actionName = actionName;
    model.isReadonly = isReadonly;
    model.subDict = subDict;
    
    return model;
}

+ (instancetype) contentModel: (NSString*)groupTitle
                    pairArray: (NSArray*)pairArray
                   actionType: (WOAModelActionType)actionType
                   isReadonly: (BOOL)isReadonly
{
    return [self contentModel: groupTitle
                    pairArray: pairArray
                 contentArray: nil
                   actionType: actionType
                   actionName: @""
                   isReadonly: isReadonly
                      subDict: nil];
}

+ (instancetype) contentModel: (NSString*)groupTitle
                 contentArray: (NSArray*)contentArray
                   actionType: (WOAModelActionType)actionType
                   isReadonly: (BOOL)isReadonly
{
    return [self contentModel: groupTitle
                    pairArray: nil
                 contentArray: contentArray
                   actionType: actionType
                   actionName: @""
                   isReadonly: isReadonly
                      subDict: nil];
}

+ (instancetype) contentModel: (NSString *)groupTitle
                    pairArray: (NSArray *)pairArray
{
    return [self contentModel: groupTitle
                    pairArray: pairArray
                 contentArray: nil
                   actionType: WOAModelActionType_None
                   actionName: @""
                   isReadonly: YES
                      subDict: nil];
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
    [descDict setValue: self.actionName
                forKey: @"actionName"];
    [descDict setValue: [NSNumber numberWithInteger: self.isReadonly]
                forKey: @"isReadonly"];
    
    return [NSString stringWithFormat:@"%@: %@", [super description], descDict];
}

@end
