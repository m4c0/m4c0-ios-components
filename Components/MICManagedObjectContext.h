//
//  ROJManagedObjectContext.h
//  Rojon
//
//  Created by Eduardo Mauricio da Costa on 16/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSEntityDescription;

@interface MICManagedObjectContext : NSObject
@property (nonatomic, readonly) NSManagedObjectContext * context;

+ (instancetype)instance;

- (NSEntityDescription *)entityDescriptionForName:(NSString *)name;
- (id)insertNewObjectForEntityForName:(NSString *)name;
- (void)saveContext;
- (void)rollbackContext;

@end
