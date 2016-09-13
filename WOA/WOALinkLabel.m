//
//  WOALinkLabel.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/14/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOALinkLabel.h"
#import "WOALayout.h"


@implementation WOALinkLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setLineBreakMode: NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail];
        self.font = [self.font fontWithSize: kWOALayout_DetailItemFontSize];
        [self setBackgroundColor: [UIColor clearColor]];
        [self setTextColor: [UIColor blueColor]];
        [self setUserInteractionEnabled: YES];
        [self setNumberOfLines: 0];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                     action:@selector(onTaped:)];
        [self addGestureRecognizer: tapGesture];
    }
    
    return self;
}

- (void) onTaped: (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(label:touchesWithTag:)])
    {
        [self.delegate label: self touchesWithTag: self.tag];
    }
}

@end
