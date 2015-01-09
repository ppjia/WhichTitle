//
//  WTIndicatorView.m
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import "WTIndicatorView.h"

@interface WTIndicatorView()

@property (nonatomic, strong) UIView *animationView;

@end

@implementation WTIndicatorView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGRect rectangle = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
//    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextFillRect(context, rectangle);
}

- (void)animateInTime:(NSInteger)seconds
{
    if (!self.self.animationView) {
        self.animationView = [[UIView alloc] init];
        self.animationView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.animationView];
    }
    self.animationView.frame = CGRectMake(0, 0, 1, CGRectGetHeight(self.bounds));
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:seconds animations:^{
        self.animationView.frame = frame;
    }];
}

@end
