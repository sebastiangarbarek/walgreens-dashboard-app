//
//  StoreCityController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 15/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreCityController.h"

@interface StoreCityController () {
    NSArray *sectionTitles;
    NSMutableDictionary *cellsToSection;
}

@end

@implementation StoreCityController

#pragma mark - Parent Methods –

- (void)awakeFromNib {
    [super awakeFromNib];
    cellsToSection = [NSMutableDictionary new];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - Init Methods -

- (void)initData {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[cellsToSection objectForKey:sectionTitles[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [sectionTitles indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Store" forIndexPath:indexPath];
    cell.storeName.text = [[cellsToSection objectForKey:sectionTitles[indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
