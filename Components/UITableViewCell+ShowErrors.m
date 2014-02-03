//
//  UITableViewCell+ShowErrors.m
//  Components
//
//  Created by Eduardo Costa on 03/02/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "UITableViewCell+ShowErrors.h"

#import <CoreData/CoreData.h>
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
    NSArray * errors = (self.error.code == NSValidationMultipleErrorsError) ? self.error.userInfo[NSDetailedErrorsKey] : @[self.error];
    
    for (NSError * err in errors) {
        NSString * key = [NSString stringWithFormat:@"%@.%d", err.domain, err.code];
        NSString * msg = NSLocalizedStringFromTable(key, @"ValidationErrors", key);
        [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
