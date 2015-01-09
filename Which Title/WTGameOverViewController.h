//
//  WTGameOverViewController.h
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNews.h"

@interface WTGameOverViewController : UIViewController

- (instancetype)initWithTotalScore:(NSInteger)totalScore withNews:(WTNews *)news;

@end
