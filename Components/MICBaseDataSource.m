//
//  ROJBaseDataSource.m
//  Rojon
//
//  Created by Eduardo Costa on 23/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICBaseDataSource.h"

@implementation MICBaseDataSource

- (id)init {
    self = [super init];
    if (self) {
        self.cellIdentifier = @"Cell";
    }
    return self;
}

- (NSIndexPath *)indexPathForSender:(id)sender {
    if (self.tableView) {
        CGPoint p = [sender convertPoint:CGPointZero toView:self.tableView];
        return [self.tableView indexPathForRowAtPoint:p];
    } else if (self.collectionView) {
        CGPoint p = [sender convertPoint:CGPointZero toView:self.collectionView];
        return [self.collectionView indexPathForItemAtPoint:p];
    } else {
        return nil;
    }
}

#pragma mark objectForSender

- (id)collectionView:(UICollectionView *)collectionView objectForSender:(id)sender {
    return [self collectionView:collectionView objectAtIndexPath:[self indexPathForSender:sender]];
}
- (id)tableView:(UITableView *)tableView objectForSender:(id)sender {
    return [self tableView:tableView objectAtIndexPath:[self indexPathForSender:sender]];
}

#pragma mark cellIdentifierForIndexPath

- (NSString *)collectionView:(UICollectionView *)collectionView cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return self.cellIdentifier;
}
- (NSString *)tableView:(UITableView *)tableView cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return self.cellIdentifier;
}

#pragma mark objectAtIndex

- (id)collectionView:(UICollectionView *)collectionView objectAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark numberOfSections

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark numberOfRowsInSection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark cellForRowAtIndexPath

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * ci = [self collectionView:collectionView cellIdentifierForIndexPath:indexPath];
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ci forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setObject:)]) {
        [cell setValue:[self collectionView:collectionView objectAtIndexPath:indexPath] forKey:@"object"];
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * ci = [self tableView:tableView cellIdentifierForIndexPath:indexPath];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ci forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setObject:)]) {
        [cell setValue:[self tableView:tableView objectAtIndexPath:indexPath] forKey:@"object"];
    }
    return cell;
}

@end
