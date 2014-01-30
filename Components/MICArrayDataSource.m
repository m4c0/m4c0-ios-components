//
//  ROJArrayDataSource.m
//  Rojon
//
//  Created by Eduardo Costa on 23/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICArrayDataSource.h"

@implementation MICArrayDataSource

- (void)setObjects:(NSArray *)objects {
    _objects = objects;
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (id)collectionView:(UICollectionView *)collectionView objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.objects[indexPath.row];
}
- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.objects[indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.objects ? 1 : 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.objects ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.objects count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitle;
}

@end
