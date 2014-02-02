//
//  ROJCoreDataSource.h
//  Rojon
//
//  Created by Eduardo Mauricio da Costa on 16/01/14.
//  Copyright (c) 2014 Eduardo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICCoreDataSource : NSObject<UICollectionViewDataSource, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@property (nonatomic, weak) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSString * entityName;
@property (nonatomic, strong) NSString * sectionNameKeyPath;
@property (nonatomic, strong) NSPredicate * predicate;
@property (nonatomic, strong) NSArray * sortDescriptors;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForSender:(id)sender;
- (id)objectForSender:(id)sender;

@end
