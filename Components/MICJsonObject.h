//
//  MICJsonObject.h
//  Components
//
//  Created by Eduardo Costa on 30/01/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICJsonObject : NSObject<NSCoding>
- (instancetype)initFromJSON:(NSDictionary *)json;
@end
