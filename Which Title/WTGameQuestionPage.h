//
//  WTGamePage.h
//  Which Title
//
//  Created by ray on 7/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNewsItem.h"

@protocol WTGameQuestionPageDelegate <NSObject>

- (void)handleAnsweredItem:(WTNewsItem *)theItem;
- (void)handleGiveupItem:(WTNewsItem *)theItem;

@end

@interface WTGameQuestionPage : UIView

@property (nonatomic, strong) id<WTGameQuestionPageDelegate> delegate;

//- (instancetype)initWithNewsItem:(WTNewsItem *)item;
- (void)setupWithNewsItem:(WTNewsItem *)item;
- (void)startQuestion;

@end
