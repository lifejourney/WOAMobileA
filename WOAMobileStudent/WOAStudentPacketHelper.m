//
//  WOAStudentPacketHelper.m
//  WOAMobile
//
//  Created by steven.zhuang on 6/6/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAStudentPacketHelper.h"
#import "CommonCrypto/CommonDigest.h"
#import "WOAPropertyInfo.h"
#import "WOANameValuePair.h"
#import "WOAContentModel.h"
#import "NSString+Utility.h"


@interface WOAStudentPacketHelper ()

@end


@implementation WOAStudentPacketHelper

@end







//NSString *labelText = [WOAPacketHelper itemNameFromDictionary: itemModel];
//id itemValue = [WOAPacketHelper itemValueFromDictionary: itemModel];
//self.pairType = [WOANameValuePair pairTypeFromTextType: [WOAPacketHelper itemTypeFromDictionary: itemModel]];
//BOOL isWritable = [WOAPacketHelper itemWritableFromDictionary: itemModel];
//self.optionArray = [WOAPacketHelper optionArrayFromDictionary: itemModel];
//
//isWritable = isWritable && (_pairType != WOAPairDataType_FlowText);


////TO-DO, temporarily
//if (pairDataType == WOAPairDataType_CheckUserList)
//{
//    if (!arrayValue && textValue)
//        arrayValue = @[textValue];
//        }


//
//- (NSString*) titleByIndex: (NSInteger)index arrayValue: (NSArray*)arrayValue
//{
//    NSString *title;
//    
//    if (index >= 0 & index < [arrayValue count])
//    {
//        NSDictionary *info = [arrayValue objectAtIndex: index];
//        title = [WOAPacketHelper attachmentTitleFromDictionary: info];
//    }
//    else
//        title = nil;
//        
//        return title;
//}
//
//- (NSString*) URLByIndex: (NSInteger)index arrayValue: (NSArray*)arrayValue
//{
//    NSString *URLString;
//    
//    if (index >= 0 & index < [arrayValue count])
//    {
//        NSDictionary *info = [arrayValue objectAtIndex: index];
//        URLString = [WOAPacketHelper attachmentURLFromDictionary: info];
//    }
//    else
//        URLString = nil;
//        
//        return URLString;
//}


//- (NSDictionary*) toDataModelWithIndexPath
//{
//    //    NSNumber *sectionNum = [NSNumber numberWithInteger: self.section];
//    //    NSNumber *rowNum = [NSNumber numberWithInteger: self.row];
//    //
//    //    id value;
//    //
//    //    if (_isWritable && (_pairType == WOAPairDataType_SinglePicker))
//    //    {
//    //        value = [self removeNumberOrderPrefix: self.lineTextField.text];
//    //    }
//    //    else if (!_isWritable && (_pairType == WOAPairDataType_Normal))
//    //    {
//    //        value = self.lineLabel.text;
//    //    }
//    //    else if (!_isWritable && (_pairType == WOAPairDataType_TitleKey))
//    //    {
//    //        value = nil;
//    //    }
//    //    else if (_pairType == WOAPairDataType_AttachFile)
//    //    {
//    //        if (_isWritable)
//    //        {
//    //            NSMutableArray *attachmentArray = [[NSMutableArray alloc] initWithCapacity: _imageURLArray.count];
//    //
//    //            for (NSInteger index = 0; index < _imageURLArray.count; index++)
//    //            {
//    //                NSDictionary *attachmentInfo = @{@"title": self.imageTitleArray[index],
//    //                                                 @"url": self.imageURLArray[index]};
//    //
//    //                [attachmentArray addObject: attachmentInfo];
//    //            }
//    //
//    //            value = attachmentArray;
//    //        }
//    //        else
//    //        {
//    //            value = nil;
//    //            //TO-DO:
//    //            //value = self.multiLabel.textsArray;
//    //        }
//    //    }
//    //    else if (0 && _isWritable && (_pairType == WOAPairDataType_Normal ||
//    //                             _pairType == WOAPairDataType_TextList ||
//    //                             _pairType == WOAPairDataType_CheckUserList))
//    //    {
//    //        value = self.lineTextView.text;
//    //    }
//    ////TO-DO:
//    ////    else if (_pairType == WOAPairDataType_TextList)
//    ////    {
//    ////        NSString *userInputValue = self.lineTextField.text;
//    ////        NSMutableArray *arrayValue = [[NSMutableArray alloc] initWithArray: self.multiLabel.textsArray];
//    ////        if (userInputValue && [userInputValue length] > 0)
//    ////        {
//    ////            [arrayValue addObject: userInputValue];
//    ////        }
//    ////
//    ////        value = arrayValue;
//    ////    }
//    ////    else if (_pairType == WOAPairDataType_CheckUserList)
//    ////    {
//    ////        value = self.multiLabel.textsArray;
//    ////    }
//    //    else
//    //    {
//    //        value = self.lineTextField.text;
//    //    }
//    //
//    ////    return [WOAPacketHelper packetForItemWithKey: self.titleLabel.text
//    ////                                           value: value
//    ////                                      typeString: self.pairTypeString
//    ////                                         section: sectionNum
//    ////                                             row: rowNum];
//    
//    return nil;
//}
//
//- (NSString*) toSimpleDataModelValue
//{
//    NSString *textValue;
//    
//    if (_lineLabel)
//    {
//        textValue = _lineLabel.text;
//    }
//    else if (_lineTextField)
//    {
//        textValue = _lineTextField.text;
//    }
//    else if (_lineTextView)
//    {
//        textValue = _lineTextView.text;
//    }
//    else if (_fileSelectorView)
//    {
//        //TODO
//        textValue = nil;
//    }
//    else if (_multiSelectorView)
//    {
//        NSArray *valueArray = [_multiSelectorView selectedValueArray];
//        
//        textValue = [valueArray componentsJoinedByString: kWOA_Level_2_Seperator];
//    }
//    else
//    {
//        textValue = nil;
//    }
//    
//    if (_pairType == WOAPairDataType_TextList ||
//        _pairType == WOAPairDataType_CheckUserList ||
//        _pairType == WOAPairDataType_AttachFile ||
//        _pairType == WOAPairDataType_MultiPicker)
//    {
//        if (_multiLabel)
//        {
//            //NSArray *valueArray = [_multiLabel textsArray];
//            NSMutableArray *valueArray = [NSMutableArray array];
//            for (WOANameValuePair *pair in _multiLabel.contentModel.pairArray)
//            {
//                [valueArray addObject: [pair stringValue]];
//            }
//            
//            NSString *fixedValue = [valueArray componentsJoinedByString: kWOA_Level_2_Seperator];
//            
//            NSMutableArray *combinedArray = [NSMutableArray array];
//            if (fixedValue && [fixedValue length] > 0)
//            {
//                [combinedArray addObject: fixedValue];
//            }
//            if (textValue && [textValue length] > 0)
//            {
//                [combinedArray addObject: textValue];
//            }
//            
//            textValue = [combinedArray componentsJoinedByString: kWOA_Level_2_Seperator];
//        }
//    }
//    
//    return textValue;
//}
