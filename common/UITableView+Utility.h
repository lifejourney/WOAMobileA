//
//  UITableView+Utility.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/25/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Utility)

- (UITableViewCell*) cellWithIdentifier: (NSString*)identifier
                              cellStyle: (UITableViewCellStyle)cellStyle;

@end
