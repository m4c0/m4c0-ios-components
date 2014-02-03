//
//  NSManagedObject+Validation.h
//  Components
//
//  Created by Eduardo Costa on 03/02/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Validation)

- (BOOL)validate:(NSError **)error;

@end
