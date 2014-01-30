//
//  UIImageView+LoadUrl.m
//  WingmenSociety
//
//  Created by Eduardo Costa on 03/09/13.
//  Copyright (c) 2013 Eduardo Costa. All rights reserved.
//

#import "UIImageView+LoadUrl.h"

#import <objc/runtime.h>

static const char kUIImageViewLoadUrlCurrentSessionTask;
static const char kUIImageViewLoadUrlPlaceholder;

@interface UIImageView (_LoadUrl)
@property (nonatomic, strong) NSURLSessionTask * currentSessionTask;
@end

@implementation UIImageView (_LoadUrl)

- (NSURLSessionTask *)currentSessionTask {
    return objc_getAssociatedObject(self, &kUIImageViewLoadUrlCurrentSessionTask);
}
- (void)setCurrentSessionTask:(NSURLSessionTask *)currentSessionTask {
    objc_setAssociatedObject(self, &kUIImageViewLoadUrlCurrentSessionTask, currentSessionTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIImageView (LoadUrl)

+ (NSURLSession *)sharedUrlSession {
    static NSURLSession * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024 diskCapacity:10 * 1024 * 1024 diskPath:@"imageCache"];
        instance = [NSURLSession sessionWithConfiguration:config];
    });
    return instance;
}

- (UIImage *)placeholder {
    return objc_getAssociatedObject(self, &kUIImageViewLoadUrlPlaceholder);
}
- (void)setPlaceholder:(UIImage *)placeholder {
    objc_setAssociatedObject(self, &kUIImageViewLoadUrlPlaceholder, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)loadAsynchronousURL:(NSURL *)url {
    [self loadAsynchronousURL:url completion:nil];
}

- (void)loadAsynchronousURL:(NSURL *)url completion:(void (^)(UIImage *))completion {
    [self.currentSessionTask cancel];
    
    self.image = self.placeholder;
    if (!url) return;
    
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];
    req.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    void (^callback)(NSURL *, NSURLResponse *, NSError *) = ^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            if (completion) completion(nil);
            return;
        }
        
        NSData * data = [NSData dataWithContentsOfURL:location];
        
        NSCachedURLResponse * c = [[NSCachedURLResponse alloc] initWithResponse:response
                                                                           data:data
                                                                       userInfo:nil
                                                                  storagePolicy:NSURLCacheStorageAllowed];
        [[UIImageView sharedUrlSession].configuration.URLCache storeCachedResponse:c forRequest:req];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self setImageFromData:data completion:completion];
        }];
    };
    
    self.currentSessionTask = [[UIImageView sharedUrlSession] downloadTaskWithRequest:req completionHandler:callback];
    [self.currentSessionTask resume];
}

- (void)setImageFromData:(NSData *)data completion:(void(^)(UIImage *))completion {
    UIImage * img = [UIImage imageWithData:data];
    if (img) self.image = img;
    if (completion) completion(img);
}

@end
