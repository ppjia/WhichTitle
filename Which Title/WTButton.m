//
//  WTButton.m
//  Which Title
//
//  Created by ray on 7/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#define kWTButtonCornerRadius 4

#import "WTButton.h"

@implementation WTButton

- (void)awakeFromNib
{
    self.layer.cornerRadius = kWTButtonCornerRadius;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
