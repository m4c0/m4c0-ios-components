//
//  UITableViewCell+ShowErrors.m
//  Components
//
//  Created by Eduardo Costa on 03/02/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "UITableViewCell+ShowErrors.h"

#import <objc/runtime.h>

static const char kUITableViewCellShowErrorsError;

@implementation UITableViewCell (ShowErrors)

- (NSError *)error {
    return objc_getAssociatedObject(self, &kUITableViewCellShowErrorsError);
}
- (void)setError:(NSError *)error {
    objc_setAssociatedObject(self, &kUITableViewCellShowErrorsError, error, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!error) {
        self.accessoryView = nil;
    } else {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.tintColor = [UIColor redColor];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(showError:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = btn;
    }
}

- (IBAction)showError:(id)sender {
    NSLog(@"%@", self.error);
}

@end
