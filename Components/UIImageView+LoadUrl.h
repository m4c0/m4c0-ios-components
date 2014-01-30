//
//  UIImageView+LoadUrl.h
//  WingmenSociety
//
//  Created by Eduardo Costa on 03/09/13.
//  Copyright (c) 2013 Eduardo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadUrl)
@property (nonatomic, strong) UIImage * placeholder;

- (void)loadAsynchronousURL:(NSURL *)url;
- (void)loadAsynchronousURL:(NSURL *)url completion:(void(^)(UIImage * image))completion;

@end
