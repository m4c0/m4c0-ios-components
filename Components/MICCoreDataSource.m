//
//  ROJCoreDataSource.m
//  Rojon
//
//  Created by Eduardo Mauricio da Costa on 16/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICCoreDataSource.h"

#import <CoreData/CoreData.h>

#import "MICManagedObjectContext.h"

@interface MICCoreDataSource ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, readonly) NSFetchedResultsController * controller;
@end

@implementation MICCoreDataSource {
    NSFetchedResultsController * _controller;
    
    NSMutableArray * indexPathChanges;
    NSMutableArray * sectionChanges;
}

- (NSFetchedResultsController *)controller {
    if (_controller) return _controller;
    
    NSFetchRequest * req = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    req.predicate = self.predicate;
    req.sortDescriptors = self.sortDescriptors;
    
    _controller = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                      managedObjectContext:[MICManagedObjectContext instance].context
                                                        sectionNameKeyPath:self.sectionNameKeyPath
                                                                 cacheName:nil];
    
    NSError * err;
    [_controller performFetch:&err];
    _controller.delegate = self;
    
    if (err) {
        NSLog(@"%@", err);
    }
    
    return _controller;
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self.controller sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[self.controller sections] objectAtIndex:section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setValue:[self.controller objectAtIndexPath:indexPath] forKey:@"object"];
    return cell;
}

- (id)collectionView:(UICollectionView *)collectionView objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.controller objectAtIndexPath:indexPath];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.controller sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.controller sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setValue:[self.controller objectAtIndexPath:indexPath] forKey:@"object"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.controller sections] objectAtIndex:section] name];
}

- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.controller objectAtIndexPath:indexPath];
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    indexPathChanges = [NSMutableArray new];
    sectionChanges = [NSMutableArray new];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (self.tableView) {
        [self.tableView beginUpdates];
        [self performBatchUpdates];
        [self.tableView endUpdates];
        if (!self.collectionView) {
            indexPathChanges = nil;
            sectionChanges = nil;
        }
    }
    if (self.collectionView) {
        [self.collectionView performBatchUpdates:^{
            [self performBatchUpdates];
        } completion:^(BOOL finished) {
            indexPathChanges = nil;
            sectionChanges = nil;
        }];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    indexPath    = indexPath    ? [self parentIndexPathFromIndexPath:indexPath]    : nil;
    newIndexPath = newIndexPath ? [self parentIndexPathFromIndexPath:newIndexPath] : nil;
    switch (type) {
        case NSFetchedResultsChangeInsert: [indexPathChanges addObject:@{@(type) : @[newIndexPath]}]; break;
        case NSFetchedResultsChangeDelete: [indexPathChanges addObject:@{@(type) : @[indexPath]}]; break;
        case NSFetchedResultsChangeUpdate: [indexPathChanges addObject:@{@(type) : @[indexPath]}]; break;
        case NSFetchedResultsChangeMove:   [indexPathChanges addObject:@{@(type) : @[indexPath, newIndexPath]}]; break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    sectionIndex = [self parentSectionFromSection:sectionIndex];
    [sectionChanges addObject:@{@(type) : [NSIndexSet indexSetWithIndex:sectionIndex]}];
}

- (void)performBatchUpdates {
    for (NSDictionary * change in sectionChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            switch ((NSFetchedResultsChangeType)[key intValue]) {
                case NSFetchedResultsChangeInsert:
                    [self.collectionView insertSections:obj];
                    [self.tableView insertSections:obj withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NSFetchedResultsChangeDelete:
                    [self.collectionView deleteSections:obj];
                    [self.tableView deleteSections:obj withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
            }
        }];
    }
    for (NSDictionary * change in indexPathChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            switch ((NSFetchedResultsChangeType)[key intValue]) {
                case NSFetchedResultsChangeInsert:
                    [self.collectionView insertItemsAtIndexPaths:obj];
                    [self.tableView insertRowsAtIndexPaths:obj withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NSFetchedResultsChangeDelete:
                    [self.collectionView deleteItemsAtIndexPaths:obj];
                    [self.tableView deleteRowsAtIndexPaths:obj withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NSFetchedResultsChangeUpdate:
                    [self.collectionView reloadItemsAtIndexPaths:obj];
                    [self.tableView reloadRowsAtIndexPaths:obj withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NSFetchedResultsChangeMove:
                    [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                    [self.tableView deleteRowsAtIndexPaths:obj[0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView insertRowsAtIndexPaths:obj[1] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
            }
        }];
    }
}

@end
