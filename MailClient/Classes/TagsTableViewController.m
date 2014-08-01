//
//  TagsTableViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 24/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "TagsTableViewController.h"
#import <Inbox.h>

@interface TagsTableViewController () <INModelProviderDelegate>

@property(nonatomic, strong) INModelProvider* tagProvider;

@end

@implementation TagsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeSelected)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    INNamespace* namespace = [INAPIManager shared].namespaces.firstObject;
    _tagProvider = [namespace newTagProvider];
    _tagProvider.delegate = self;
    
    [_tagProvider refresh];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [[self.tagProvider items] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    INTag* tag = _tagProvider.items[indexPath.row];
    
    if (tag.color) {
        cell.textLabel.textColor = tag.color;
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = tag.name;
    
    return cell;
}


#pragma mark -

#pragma mark - INModelProvider delegate

- (void)providerDataChanged:(INModelProvider*)provider
{
    [self.tableView reloadData];
}

- (void)provider:(INModelProvider*)provider dataAltered:(INModelProviderChangeSet *)changeSet
{
    [self.tableView reloadData];
    
}

- (void)provider:(INModelProvider*)provider dataFetchFailed:(NSError *)error
{
    //[self.refreshControl endRefreshing];
}

- (void)providerDataFetchCompleted:(INModelProvider*)provider
{
    //[self.refreshControl endRefreshing];
}

#pragma mark -

- (void)closeSelected {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
