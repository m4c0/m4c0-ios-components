//
//  ROJCompositeDataSource.h
//  Rojon
//
//  Created by Eduardo Costa on 23/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICBaseDataSource.h"

@interface MICCompositeDataSource : MICBaseDataSource
@property (nonatomic, strong) IBOutletCollection(MICBaseDataSource) NSArray * dataSources;
@end
