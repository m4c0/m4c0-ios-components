//
//  ROJCoreDataSource.h
//  Rojon
//
//  Created by Eduardo Mauricio da Costa on 16/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICBaseDataSource.h"

@interface MICCoreDataSource : MICBaseDataSource<UICollectionViewDataSource, UITableViewDataSource>

@property (nonatomic, strong) NSString * entityName;
@property (nonatomic, strong) NSString * sectionNameKeyPath;
@property (nonatomic, strong) NSPredicate * predicate;
@property (nonatomic, strong) NSArray * sortDescriptors;

@end
