//
//  ROJClientDataSource.h
//  Rojon
//
//  Created by Eduardo Costa on 09/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICBaseDataSource.h"

@interface MICClientDataSource : MICBaseDataSource<UICollectionViewDataSource>
@property (nonatomic, strong) NSString * resultKeyPath;

- (void)loadFirstPage;

// "Protected"
- (void)loadPage:(int)number completion:(void(^)(id))completion;

@end
