//
//  UIView+IndexPathTag.m
//  WOAMobileStudent
//
//  Created by Steven (Shuliang) Zhuang on 2/13/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "UIView+IndexPathTag.h"

@implementation UIView (IndexPathTag)


+ (NSIndexPath*) indexPathByTag: (NSInteger)tag
{
    NSInteger maskBitCount = (sizeof(NSInteger) * 8 / 2);
    NSInteger lowMask = (((NSInteger)0x1) << maskBitCount) - 1;
    NSInteger highMask = NSIntegerMax - lowMask;
    
    NSInteger section = tag & highMask;
    NSInteger row = tag & lowMask;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row
                                                inSection: section];
    
    return indexPath;
}

+ (NSIndexPath*) indexPathByTagE: (NSInteger)tag
{
    NSIndexPath *indexPath = [self indexPathByTag: tag];
    NSInteger section = indexPath.section - 1;
    
    
    return [NSIndexPath indexPathForRow: indexPath.row
                              inSection: section];
}

+ (NSInteger) tagByIndexPath: (NSIndexPath*)indexPath
{
    NSInteger maskBitCount = (sizeof(NSInteger) * 8 / 2);
    NSInteger lowMask = (((NSInteger)0x1) << maskBitCount) - 1;
    NSInteger highMask = NSIntegerMax - lowMask;
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSInteger tag = (row & lowMask) + ((section << maskBitCount) & highMask);
    
    return tag;
}

+ (NSInteger) tagByIndexPathE: (NSIndexPath*)indexPath
{
    NSInteger section = indexPath.section + 1;
    NSIndexPath *indexPathE = [NSIndexPath indexPathForRow: indexPath.row
                                                 inSection: section];
    
    return [self tagByIndexPath: indexPathE];
}

@end
