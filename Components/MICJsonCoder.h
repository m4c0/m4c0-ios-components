//
//  MICJsonCoder.h
//  Components
//
//  Created by Eduardo Costa on 27/02/14.
//  Copyright (c) 2014 Eduardo Mauricio da Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICJsonCoder : NSCoder
+ (NSString *)encodeJSONObject:(id<NSCoding>)obj;
@end
