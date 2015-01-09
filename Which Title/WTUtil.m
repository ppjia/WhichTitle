//
//  WTUtil.m
//  Which Title
//
//  Created by ray on 8/01/2015.
//  Copyright (c) 2015 ruijia. All rights reserved.
//

#import "WTUtil.h"

@implementation WTUtil

+ (NSCache *)wtCache
{
    static NSCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}

+ (void)loadImage:(NSString *)imageUrl withCompletionBlock:(void (^)(UIImage *))completionBlock;
{
    UIImage *img = [[WTUtil wtCache] objectForKey:imageUrl];
    if (img) {
        if (completionBlock) {
            completionBlock(img);
        }
        return;
    }
    // load image and save in NSCache
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        // render image
        NSURL *imgUrl = [NSURL URLWithString:imageUrl];
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl options:kNilOptions error:nil];
        UIImage *img = [UIImage imageWithData:imgData];
        
        // save in cache
        [[WTUtil wtCache] setObject:img forKey:imageUrl];
        
        if (completionBlock) {
            completionBlock(img);
        }
        
    });
}

+ (void)blurImageView:(UIImageView *)imageView
{
    // only for iOS8, it adds effect view to the imageview
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        // check if effectView exists
        UIView *existedEffectView = nil;
        for (UIView *view in imageView.subviews) {
            if ([view isKindOfClass:[UIVisualEffectView class]]) {
                existedEffectView = view;
                break;
            }
        }
        
        if (existedEffectView) {
            return;
        }
        
        // add new effectView
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = imageView.bounds;
        [imageView addSubview:effectView];
    }
    
    // for iOS7, use another solution
    else {
        UIImage *bluredImage = [WTUtil blur:imageView.image];
        imageView.image = bluredImage;
    }
}

// this bluring effect is for iOS7 using gaussian filter, it's slower than the bluring API in iOS8
+ (UIImage*)blur:(UIImage*)theImage
{
    // create blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    //release CGImageRef because ARC doesn't manage this on its own.
    CGImageRelease(cgImage);
    
    return returnImage;
}


+ (NSAttributedString *)attributedText:(NSString *)text withRange:(NSRange)range withRegularFontSize:(NSInteger)regularFontSize withBoldFontSize:(NSInteger)boldFontSize
{
    UIFont *boldFont = [UIFont boldSystemFontOfSize:boldFontSize];
    UIFont *regularFont = [UIFont systemFontOfSize:regularFontSize];
    UIColor *foregroundColor = [UIColor whiteColor];
    
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldFont, NSFontAttributeName,
                           foregroundColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, nil];
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:subAttrs];
    [attributedText setAttributes:attrs range:range];
    
    return attributedText;
}

@end
