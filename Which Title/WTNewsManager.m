//
//  WTNewsManager.m
//  Which Title
//
//  Created by ray on 7/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define NEWS_FEED_URL @"https://dl.dropboxusercontent.com/u/30107414/game.json"

#import "WTNewsManager.h"
#import "WTNewsItem.h"

@implementation WTNewsManager

+ (instancetype)sharedManager
{
    static id controller;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[WTNewsManager alloc] init];
    });
    return controller;
}

- (void)loadNews:(void (^)(WTNews *, BOOL))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:NEWS_FEED_URL]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, NO);
            });
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            WTNews *news = [self parseNews:json];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(news, YES);
            });
        }
    }];
}

- (WTNews *)parseNews:(NSDictionary *)json
{
    WTNews *news = [WTNews new];
    news.product = [json objectForKey:@"product"];
    news.resultSize = [[json objectForKey:@"resultSize"] integerValue];
    news.version = [json objectForKey:@"version"];
    
    static NSString *JSON_ITEMS = @"items";
    id newsDict = [json objectForKey:JSON_ITEMS];
    NSMutableArray *newsItems = [[NSMutableArray alloc] initWithCapacity:[newsDict count]];
    
    @autoreleasepool {
        for (id newsItemJson in newsDict) {
            WTNewsItem *newsItem = [[WTNewsItem alloc] init];
            newsItem.correctAnswerIndex = [[newsItemJson objectForKey:@"correctAnswerIndex"] integerValue];
            newsItem.imageUrl = [newsItemJson objectForKey:@"imageUrl"];
            newsItem.standFirst = [newsItemJson objectForKey:@"standFirst"];
            newsItem.storyUrl = [newsItemJson objectForKey:@"storyUrl"];
            newsItem.section = [newsItemJson objectForKey:@"section"];
            newsItem.headlines = [newsItemJson objectForKey:@"headlines"];
            
            [newsItems addObject:newsItem];
        }
    }
    
    news.items = newsItems;
    return news;
}

@end
