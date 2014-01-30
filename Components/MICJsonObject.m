//
//  MICJsonObject.m
//  Components
//
//  Created by Eduardo Costa on 30/01/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import "MICJsonObject.h"

#import <objc/runtime.h>

@implementation MICJsonObject

- (instancetype)initFromJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        [json enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            objc_property_t p = class_getProperty([self class], [[key description] cStringUsingEncoding:NSUTF8StringEncoding]);
            if (!p) return;
            
            const char * attr = property_getAttributes(p);
            if (strstr(attr, ",R")) return;
            
            if (strstr(attr, "T@\"") == attr) {
                char className[1024];
                memset(className, 0, 1024);
                strncpy(className, attr + 3, strchr(attr + 3, '"') - attr - 3);
                
                if (!strcmp(className, "NSNumber")) {
                    NSAssert([obj isKindOfClass:[NSNumber class]], @"'%@' is not a number", key);
                    [self setValue:obj forKey:key];
                } else if (!strcmp(className, "NSString")) {
                    NSAssert([obj isKindOfClass:[NSString class]], @"'%@' is not a string", key);
                    [self setValue:obj forKey:key];
                } else if (!strcmp(className, "NSURL")) {
                    NSAssert([obj isKindOfClass:[NSString class]], @"'%@' is not an URL string", key);
                    [self setValue:[NSURL URLWithString:obj] forKey:key];
                } else if (!strcmp(className, "NSArray")) {
                    NSAssert([obj isKindOfClass:[NSArray class]], @"'%@' is not an array", key);
                    [self setValue:obj forKey:key];
                } else {
                    NSAssert([obj isKindOfClass:[NSDictionary class]], @"'%@' is not a dictionary", key);
                    Class clz = NSClassFromString([NSString stringWithCString:className encoding:NSUTF8StringEncoding]);
                    if (class_respondsToSelector(clz, @selector(initFromJSON:))) {
                        [self setValue:[[clz alloc] initFromJSON:obj] forKey:key];
                    } else {
                        NSAssert(false, @"'%@' has unknown type: %s", key, className);
                    }
                }
            }
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count;
    objc_property_t * props = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char * cname = property_getName(props[i]);
        NSString * name = [NSString stringWithCString:cname encoding:NSUTF8StringEncoding];
        [aCoder encodeObject:[self valueForKey:name] forKey:name];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        unsigned int count;
        objc_property_t * props = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char * cname = property_getName(props[i]);
            NSString * name = [NSString stringWithCString:cname encoding:NSUTF8StringEncoding];
            [self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
        }
    }
    return self;
}

@end
