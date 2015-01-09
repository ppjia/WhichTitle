//
//  WTGameAnswerPage.h
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNewsItem.h"

@protocol WTGameAnswerPageDelegate <NSObject>

- (void)handleNextQuestion;
- (void)handleReadArticle;

@end

@interface WTGameAnswerPage : UIView

@property (nonatomic, strong) id<WTGameAnswerPageDelegate> delegate;

- (void)setupWithNewsItem:(WTNewsItem *)item andTotalScore:(NSInteger)totalScore;

@end
