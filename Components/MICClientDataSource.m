//
//  ROJClientDataSource.m
//  Rojon
//
//  Created by Eduardo Costa on 09/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICClientDataSource.h"

@implementation MICClientDataSource {
    NSMutableArray * sections;
    BOOL doneLoading;
    BOOL ocupado;
}

- (id)init {
    self = [super init];
    if (self) {
        sections = [NSMutableArray new];
        doneLoading = YES;
    }
    return self;
}

- (id)collectionView:(UICollectionView *)collectionView objectAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section >= [sections count]) ? nil : sections[indexPath.section][indexPath.row];
}
- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section >= [sections count]) ? nil : sections[indexPath.section][indexPath.row];
}

- (void)loadFirstPage {
    if (ocupado) return;

    doneLoading = NO;
    sections = [NSMutableArray new];
    [self.collectionView reloadData];
    [self.tableView reloadData];
    
    [self loadNextPage];
}

- (void)loadNextPage {
    if (ocupado) return;
    
    ocupado = YES;
    [self loadPage:[sections count]+1 completion:^(id res) {
        [self processResult:res];
        ocupado = NO;
    }];
}

- (void)loadPage:(int)number completion:(void (^)(id))completion {
    @throw @"dev must implement loadPage:completion:";
}

- (void)processResult:(id)result {
    if (!result) {
        doneLoading = YES;
        
        [self.collectionView reloadData];
        [self.tableView reloadData];
        return;
    }
    if ([result isKindOfClass:[NSError class]]) {
#warning how to deal with errors?
        NSLog(@"%@", result);
        
        doneLoading = YES;
        
        [self.collectionView reloadData];
        [self.tableView reloadData];
        return;
    }
    
    int page = [[result valueForKey:@"page"] intValue];
    if (page != [sections count] + 1) return;
    
    NSArray * prods = [result valueForKeyPath:@"data"];
    if (!prods || ![prods count]) {
        doneLoading = YES;
        
        [self.collectionView reloadData];
        [self.tableView reloadData];
        return;
    }
    [sections addObject:prods];
    
    int total = [[result valueForKey:@"totalpages"] intValue];
        
    doneLoading = (total == page);
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [sections count] + (doneLoading?0:1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (section == [sections count]) ? (doneLoading?0:1) : [sections[section] count];
}

- (NSString *)collectionView:(UICollectionView *)collectionView cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [sections count]) {
        [self loadNextPage];
        return @"Wait";
    } else {
        return [super collectionView:collectionView cellIdentifierForIndexPath:indexPath];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sections count] + (doneLoading?0:1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == [sections count]) ? (doneLoading?0:1) : [sections[section] count];
}

- (NSString *)tableView:(UITableView *)tableView cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= [sections count]) {
        [self loadNextPage];
        return @"Wait";
    } else {
        return [super tableView:tableView cellIdentifierForIndexPath:indexPath];
    }
}

@end
