//
//  WTUtil.h
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WTUtil : NSObject

+ (NSCache *)wtCache;
+ (void)loadImage:(NSString *)imageUrl withCompletionBlock:(void (^)(UIImage *image))completionBlock;
+ (UIImage*)blur:(UIImage*)theImage;
+ (void)blurImageView:(UIImageView *)imageView;
+ (NSAttributedString *)attributedText:(NSString *)text withRange:(NSRange)range withRegularFontSize:(NSInteger)regularFontSize withBoldFontSize:(NSInteger)boldFontSize;

@end
