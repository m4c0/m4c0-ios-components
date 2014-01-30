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

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.controller objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForSender:(id)sender {
    if (self.collectionView) {
        CGPoint p = [sender convertPoint:CGPointZero toView:self.collectionView];
        return [self.collectionView indexPathForItemAtPoint:p];
    } else {
        return nil;
    }
}

- (id)objectForSender:(id)sender {
    return [self objectAtIndexPath:[self indexPathForSender:sender]];
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    indexPathChanges = [NSMutableArray new];
    sectionChanges = [NSMutableArray new];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        [self performBatchUpdates];
    } completion:^(BOOL finished) {
        indexPathChanges = nil;
        sectionChanges = nil;
    }];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
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
    [sectionChanges addObject:@{@(type) : [NSIndexSet indexSetWithIndex:sectionIndex]}];
}

- (void)performBatchUpdates {
    for (NSDictionary * change in sectionChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            switch ((NSFetchedResultsChangeType)[key intValue]) {
                case NSFetchedResultsChangeInsert: [self.collectionView insertSections:obj]; break;
                case NSFetchedResultsChangeDelete: [self.collectionView deleteSections:obj]; break;
            }
        }];
    }
    for (NSDictionary * change in indexPathChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            switch ((NSFetchedResultsChangeType)[key intValue]) {
                case NSFetchedResultsChangeInsert: [self.collectionView insertItemsAtIndexPaths:obj]; break;
                case NSFetchedResultsChangeDelete: [self.collectionView deleteItemsAtIndexPaths:obj]; break;
                case NSFetchedResultsChangeUpdate: [self.collectionView reloadItemsAtIndexPaths:obj]; break;
                case NSFetchedResultsChangeMove:   [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]]; break;
            }
        }];
    }
}

@end
