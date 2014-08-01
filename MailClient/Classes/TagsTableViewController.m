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

@property(nonatomic, strong) NSArray* standardTags;
@property(nonatomic, strong) NSArray* maiboxTags;
@property(nonatomic, strong) NSArray* otherTags;

@end

@implementation TagsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tags";
    
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
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    if (section == 0) {
        return self.standardTags.count;
    }
    else if (section == 1) {
        return self.maiboxTags.count;
    }
    else if (section == 2) {
        return self.otherTags.count;
    }
    
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"";
    }
    else if (section == 1) {
        return @"Mailbox";
    }
    else if (section == 2) {
        return @"Other";
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    INTag* tag = nil;
    
    if (indexPath.section == 0) {
        tag = self.standardTags[indexPath.row];
    }
    else if (indexPath.section == 1) {
        tag = self.maiboxTags[indexPath.row];
    }
    else if (indexPath.section == 2) {
        tag = self.otherTags[indexPath.row];
    }
    
    
    if (tag.color) {
        cell.textLabel.textColor = tag.color;
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = tag.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INTag* tag = nil;
    
    if (indexPath.section == 0) {
        tag = self.standardTags[indexPath.row];
    }
    else if (indexPath.section == 1) {
        tag = self.maiboxTags[indexPath.row];
    }
    else if (indexPath.section == 2) {
        tag = self.otherTags[indexPath.row];
    }
    
    [self.delegate tagsViewController:self didSelectTag:tag];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - INModelProvider delegate

- (void)providerDataChanged:(INModelProvider*)provider
{
    [self processDataFromProvider];
    [self.tableView reloadData];
}

- (void)provider:(INModelProvider*)provider dataAltered:(INModelProviderChangeSet *)changeSet
{
    
    [self processDataFromProvider];
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

- (void)processDataFromProvider {
    
    NSMutableArray* standardTags = [NSMutableArray new];
    NSMutableArray* mailboxTags = [NSMutableArray new];
    NSMutableArray* otherTags = [NSMutableArray new];
    
    NSArray* standardTagIds = @[INTagIDArchive, INTagIDDraft, INTagIDInbox, INTagIDSent, INTagIDStarred, INTagIDTrash, INTagIDUnread, INTagIDUnseen];
    
    for (INTag* tag in self.tagProvider.items) {
        
        BOOL tagAssigned = NO;
        
        for (NSString* standardTagId in standardTagIds) {
            
            NSLog(@"%@ %@", tag.ID, standardTagId);
            
            if ([tag.ID isEqualToString:standardTagId]) {
                
                [standardTags addObject:tag];
                
                tagAssigned = YES;
                break;
            }
        }
        
        if (tagAssigned) {
            continue;
        }
        
        if ([tag.name containsString:@"gmail-[mailbox]"]) {
            
            [mailboxTags addObject:tag];
            
            tagAssigned = YES;
        }
        
        if (tagAssigned) {
            continue;
        }
        
        [otherTags addObject:tag];
    }
    
    self.standardTags = [standardTags copy];
    self.maiboxTags = [mailboxTags copy];
    self.otherTags = [otherTags copy];
}

#pragma mark -

- (void)closeSelected {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
