//
//  ROJManagedObjectContext.m
//  Rojon
//
//  Created by Eduardo Mauricio da Costa on 16/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICManagedObjectContext.h"

#import <CoreData/CoreData.h>

@interface MICManagedObjectContext ()
@property (nonatomic, strong) NSManagedObjectContext * context;
@end

@implementation MICManagedObjectContext

+ (instancetype)instance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:nil] init];
    });
    return instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self instance];
}

- (NSManagedObjectContext *)context {
    if (_context) return _context;
    
    NSURL * momurl = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    NSManagedObjectModel * mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momurl];
    
    NSPersistentStoreCoordinator * psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory
                                                          inDomains:NSUserDomainMask] firstObject];
    
    NSError * err;
    [psc addPersistentStoreWithType:NSSQLiteStoreType
                      configuration:nil
                                URL:[url URLByAppendingPathComponent:@"Model.sqlite"]
                            options:nil
                              error:&err];
    if (err) {
        NSLog(@"%@", err);
        return nil;
    }
    
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.persistentStoreCoordinator = psc;
    return _context;
}

- (NSEntityDescription *)entityDescriptionForName:(NSString *)name {
    return [NSEntityDescription entityForName:name inManagedObjectContext:self.context];
}

- (id)insertNewObjectForEntityForName:(NSString *)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.context];
}

- (void)rollbackContext {
    if (_context && [_context hasChanges]) {
        [_context rollback];
    }
}

- (void)saveContext {
    NSError * err;
    if (_context && [_context hasChanges] && ![_context save:&err]) {
        NSLog(@"%@", err);
    }
}

@end
