//
//  NSManagedObject+Validation.m
//  Components
//
//  Created by Eduardo Costa on 03/02/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "NSManagedObject+Validation.h"

@implementation NSManagedObject (Validation)

- (BOOL)validate:(NSError *__autoreleasing *)error {
    if ([self isInserted]) {
        return [self validateForInsert:error];
    } else if ([self isUpdated]) {
        return [self validateForUpdate:error];
    } else if ([self isDeleted]) {
        return [self validateForDelete:error];
    } else {
        return YES;
    }
}

@end
