//
//  ROJBaseDataSource.h
//  Rojon
//
//  Created by Eduardo Costa on 23/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MICBaseDataSource : NSObject<UICollectionViewDataSource, UITableViewDataSource>
@property (nonatomic, strong) NSIndexPath * displacement;

@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSString * cellIdentifier;

- (id)collectionView:(UICollectionView *)collectionView objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath;

- (id)collectionView:(UICollectionView *)collectionView objectForSender:(id)sender;
- (id)tableView:(UITableView *)tableView objectForSender:(id)sender;

- (NSString *)collectionView:(UICollectionView *)collectionView cellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView cellIdentifierForIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForSender:(id)sender;

// "protected"
- (NSUInteger)childSectionFromSection:(NSUInteger)parentSection;
- (NSUInteger)parentSectionFromSection:(NSUInteger)childSection;
- (NSIndexPath *)childIndexPathFromIndexPath:(NSIndexPath *)parentIP;
- (NSIndexPath *)parentIndexPathFromIndexPath:(NSIndexPath *)childIP;

@end
