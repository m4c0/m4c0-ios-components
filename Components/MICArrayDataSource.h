//
//  ROJArrayDataSource.h
//  Rojon
//
//  Created by Eduardo Costa on 23/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICBaseDataSource.h"

@interface MICArrayDataSource : MICBaseDataSource
@property (nonatomic, strong) NSArray * objects;
@property (nonatomic, strong) NSString * sectionTitle;
@end
