//
//  WTNewsManager.h
//  Which Title
//
//  Created by ray on 7/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTNews.h"

@interface WTNewsManager : NSObject

+ (instancetype)sharedManager;

- (void)loadNews:(void (^)(WTNews *news, BOOL success))completionBlock;

@end
