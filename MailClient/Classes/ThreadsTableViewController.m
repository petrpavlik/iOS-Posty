//
//  ThreadsTableViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 19/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ThreadsTableViewController.h"
#import <Inbox.h>

#import "ThreadTableViewCell.h"
#import "DateFormatter.h"
#import "MessagesTableViewController.h"
#import "ComposeMessageViewController.h"
#import "NavigationController.h"

#import "TagsTableViewController.h"

@interface ThreadsTableViewController () <INModelProviderDelegate>

@property(nonatomic, strong) INThreadProvider* threadProvider;

@end

@implementation ThreadsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Inbox";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeEmailSelected)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(testSelected)];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    self.tableView.backgroundColor = skin.cellBackgroundColor;
    self.tableView.separatorColor = skin.cellSeparatorColor;
    self.tableView.tableFooterView = [UIView new];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[ThreadTableViewCell class] forCellReuseIdentifier:@"ThreadTableViewCell"];
    
    
    /*[[INAPIManager shared] authenticateWithAuthToken:@"no-open-source-auth" andCompletionBlock:^(BOOL success, NSError *error) {
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Auth Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return;
        }*/
        
        INNamespace * namespace = [[[INAPIManager shared] namespaces] firstObject];
        self.threadProvider = [namespace newThreadProvider];
        self.threadProvider.itemSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastMessageDate" ascending:NO]];
        self.threadProvider.itemFilterPredicate = [NSPredicate predicateWithFormat:@"tagIDs = 'inbox'"];
        self.threadProvider.itemRange = NSMakeRange(0, 100);
        self.threadProvider.delegate = self;
    //}];
}

#pragma mark -

- (void)refresh {
    
    [self.threadProvider refresh];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.threadProvider items] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThreadTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    INThread * thread = [[self.threadProvider items] objectAtIndex: indexPath.row];
    
    NSString* from = nil;
    
    for (NSDictionary* participant in thread.participants) {
        
        if (!from.length) {
            from = @"";
        }
        else {
            from = [from stringByAppendingString:@", "];
        }
        
        if (participant[@"name"]) {
            from = [from stringByAppendingString:participant[@"name"]];
        }
        else {
            from = [from stringByAppendingString:participant[@"email"]];
        }
    }
    
    cell.snippetLabel.text = [thread.snippet stringByReplacingOccurrencesOfString:thread.subject withString:@""];
    cell.subjectLabel.text = thread.subject;
    cell.unreadIndicatorView.hidden = ![thread hasTagWithID:INTagIDUnread];
    cell.fromLabel.text = from;
    cell.dateLabel.text = [DateFormatter stringFromDate:thread.lastMessageDate];
    
    [thread markAsSeen]; //TODO: check whether this fires a request more often that is acceptable
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INThread * thread = [[self.threadProvider items] objectAtIndex: indexPath.row];
    
    MessagesTableViewController* controller = [[MessagesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.threadId = thread.ID;
    controller.namespaceId = thread.namespaceID;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction* deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //INThread * thread = [[self.threadProvider items] objectAtIndex: indexPath.row];
    }];
    
    UITableViewRowAction* flagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Flag" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //INThread * thread = [[self.threadProvider items] objectAtIndex: indexPath.row];
    }];
    
    return @[deleteAction, flagAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - INModelProvider delegate

- (void)providerDataChanged:(INModelProvider*)provider
{
    [self.tableView reloadData];
}

- (void)provider:(INModelProvider*)provider dataAltered:(INModelProviderChangeSet *)changeSet
{
    [self.tableView reloadData];
    
    /*[self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeRemove] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeAdd] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeUpdate] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];*/
}

- (void)provider:(INModelProvider*)provider dataFetchFailed:(NSError *)error
{
    //[[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    [self.refreshControl endRefreshing];
}

- (void)providerDataFetchCompleted:(INModelProvider*)provider
{
    [self.refreshControl endRefreshing];
}

#pragma mark -

- (void)composeEmailSelected {
    
    ComposeMessageViewController* controller = [[ComposeMessageViewController alloc] init];
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)testSelected {
    
    TagsTableViewController* controller = [[TagsTableViewController alloc] init];
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
