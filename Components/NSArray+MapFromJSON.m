//
//  NSArray+MapFromJSON.m
//  WingmenSociety
//
//  Created by Eduardo Costa on 18/03/13.
//
//

#import "NSArray+MapFromJSON.h"

@implementation NSArray (MapFromJSON)

- (NSArray *)mapUsingJSONClass:(Class)cls {
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    
    for (NSDictionary * jsonObject in self) {
        id obj = [cls alloc];
        [result addObject:[obj performSelector:@selector(initFromJSON:) withObject:jsonObject]];
    }
    
    return [result copy];
}

@end
