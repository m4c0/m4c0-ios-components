//
//  ROJCompositeDataSource.m
//  Rojon
//
//  Created by Eduardo Costa on 23/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import "MICCompositeDataSource.h"

@implementation MICCompositeDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int res = 0;
    for (MICBaseDataSource * ds in self.dataSources) {
        res += [ds numberOfSectionsInTableView:tableView];
    }
    return res;
}

- (MICBaseDataSource *)dataSourceInTableView:(UITableView *)tableView forSection:(NSInteger *)section {
    for (MICBaseDataSource * ds in self.dataSources) {
        NSInteger count = [ds numberOfSectionsInTableView:tableView];
        if (*section < count) return ds;
        
        *section -= count;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    MICBaseDataSource * ds = [self dataSourceInTableView:tableView forSection:&section];
    return [ds tableView:tableView cellIdentifierForIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:section]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dataSourceInTableView:tableView forSection:&section] tableView:tableView numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self dataSourceInTableView:tableView forSection:&section] tableView:tableView titleForHeaderInSection:section];
}

- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    MICBaseDataSource * ds = [self dataSourceInTableView:tableView forSection:&section];
    return [ds tableView:tableView objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:section]];
}

@end
