//
//  ROJManagedObjectContext.h
//  Rojon
//
//  Created by Eduardo Mauricio da Costa on 16/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICManagedObjectContext : NSObject
@property (nonatomic, readonly) NSManagedObjectContext * context;

+ (instancetype)instance;

@end
