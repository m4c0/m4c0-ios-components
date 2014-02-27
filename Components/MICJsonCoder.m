//
//  MICJsonCoder.m
//  Components
//
//  Created by Eduardo Costa on 27/02/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "MICJsonCoder.h"

@implementation MICJsonCoder {
    NSMutableArray * stack;
    NSDateFormatter * dateFormatter;
    id rootObject;
}

// Baseado/cheirado a partir de:
// https://github.com/mikeabdullah/KSPropertyListEncoder/blob/master/KSPropertyListEncoder.m

+ (NSData *)encodeJSONObject:(id<NSCoding>)obj {
    MICJsonCoder * c = [MICJsonCoder new];
    [c encodeRootObject:obj];
    
    NSError * err;
    NSData * data = [NSJSONSerialization dataWithJSONObject:c->rootObject options:0 error:&err];
    if (err) {
        NSLog(@"%@", err);
        return nil;
    }
    
    return data;
}
+ (id)decodeJSONObject:(NSData *)json {
    MICJsonCoder * c = [MICJsonCoder new];
    
    NSError * err;
    c->rootObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&err];
    if (err) {
        NSLog(@"%@", err);
        return nil;
    }
    
    return [c decodeObject];
}

- (BOOL)allowsKeyedCoding {
    return YES;
}

- (void)encodeRootObject:(id)obj {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    stack = [NSMutableArray new];
    [self encodeObject:obj forKey:nil];
}

- (void)encodeObject:(id)objv forKey:(NSString *)key {
    if (!objv) {
        [[stack lastObject] removeObjectForKey:key];
        return;
    }
    if ([objv isKindOfClass:[NSArray class]]) {
        [self pushObject:[NSMutableArray new] forKey:key];
        for (id child in objv) {
            [self encodeObject:child forKey:nil];
        }
        [stack removeLastObject];
        return;
    }
    if ([objv isKindOfClass:[NSDictionary class]]) {
        [self pushObject:[NSMutableDictionary new] forKey:key];
        [objv enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self encodeObject:obj forKey:key];
        }];
        [stack removeLastObject];
        return;
    }
    if ([objv isKindOfClass:[NSNumber class]] || [objv isKindOfClass:[NSString class]]) {
        [[stack lastObject] setObject:objv forKey:key];
        return;
    }
    if ([objv isKindOfClass:[NSDate class]]) {
        [[stack lastObject] setObject:[dateFormatter stringFromDate:objv] forKey:key];
        return;
    }
    
    [self pushObject:[NSMutableDictionary new] forKey:key];
    [objv encodeWithCoder:self];
    [stack removeLastObject];
}

- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key {
    [[stack lastObject] setObject:@(boolv) forKey:key];
}

- (void)encodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key {
    [[stack lastObject] setObject:[[NSString alloc] initWithBytes:bytesp length:lenv encoding:NSUTF8StringEncoding] forKey:key];
}

- (void)encodeDouble:(double)realv forKey:(NSString *)key {
    [[stack lastObject] setObject:@(realv) forKey:key];
}

- (void)encodeFloat:(float)realv forKey:(NSString *)key {
    [[stack lastObject] setObject:@(realv) forKey:key];
}

- (void)encodeInt32:(int32_t)intv forKey:(NSString *)key {
    [[stack lastObject] setObject:@(intv) forKey:key];
}

- (void)pushObject:(id)object forKey:(NSString *)key {
    if (key) {
        [[stack lastObject] setObject:object forKey:key];
    } else {
        [[stack lastObject] addObject:object];
    }
    [stack addObject:object];
    if (!rootObject) {
        rootObject = object;
    }
}

@end
