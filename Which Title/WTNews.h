//
//  WTNews.h
//  Which Title
//
//  Created by ray on 7/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTNews : NSObject

@property (nonatomic, strong) NSString *product;
@property (nonatomic) NSInteger resultSize;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSArray *items;

@end
