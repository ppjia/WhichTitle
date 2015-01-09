//
//  WTNews.h
//  Which Title
//
//  Created by ray on 7/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTNewsItem : NSObject

@property (nonatomic) NSInteger correctAnswerIndex;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *standFirst;
@property (nonatomic, strong) NSString *storyUrl;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSArray *headlines;

// this property is not from server, it's used for recording each question user gains
@property (nonatomic) NSInteger score;

@end
