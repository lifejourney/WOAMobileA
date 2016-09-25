//
//  UITableView+Utility.m
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/25/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import "UITableView+Utility.h"

@implementation UITableView (Utility)

- (UITableViewCell*) cellWithIdentifier: (NSString*)identifier
                              cellStyle: (UITableViewCellStyle)cellStyle
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier: identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: cellStyle reuseIdentifier: identifier];
    }
    else
    {
        UIView *subview;
        
        do
        {
            subview = [cell.contentView.subviews lastObject];
            
            if (subview)
                [subview removeFromSuperview];
        }
        while (!subview);
    }
    
    return cell;
}

@end
