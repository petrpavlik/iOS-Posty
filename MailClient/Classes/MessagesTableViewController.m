//
//  MessagesTableViewController.m
//  MailClient
//
//  Created by Petr Pavlik on 20/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "MessagesTableViewController.h"
#import <Inbox.h>

#import "ThreadTableViewCell.h"
#import "DateFormatter.h"
#import "MessageViewController.h"

@interface MessagesTableViewController () <INModelProviderDelegate>

@property(nonatomic, strong) INMessageProvider* messageProvider;

@end

@implementation MessagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSParameterAssert(self.threadId.length);
    NSParameterAssert(self.namespaceId.length);
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    self.tableView.backgroundColor = skin.cellBackgroundColor;
    self.tableView.separatorColor = skin.cellSeparatorColor;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[ThreadTableViewCell class] forCellReuseIdentifier:@"ThreadTableViewCell"];
    
    _messageProvider = [[INMessageProvider alloc] initForMessagesInThread:_threadId andNamespaceID:_namespaceId];
    _messageProvider.delegate = self;
    
    [_messageProvider refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.messageProvider items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThreadTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    INMessage * message = [[self.messageProvider items] objectAtIndex: indexPath.row];
    
    NSString* from = nil;
    if (message.from.count) {
        
        NSDictionary* participant = message.from[0];
        
        if (participant[@"name"]) {
            from = participant[@"name"];
        }
        else if (participant[@"email"]) {
            from = participant[@"email"];
        }
    }
    
    cell.snippetLabel.text = message.body;
    cell.subjectLabel.text = message.subject;
    cell.unreadIndicatorView.hidden = message.unread;
    cell.fromLabel.text = from;
    cell.dateLabel.text = [DateFormatter stringFromDate:message.date];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INMessage * message = [[self.messageProvider items] objectAtIndex: indexPath.row];
    
    MessageViewController* controller = [[MessageViewController alloc] init];
    controller.message = message;
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - INModelProvider delegate

- (void)providerDataChanged:(INModelProvider*)provider
{
    [self.tableView reloadData];
}

- (void)provider:(INModelProvider*)provider dataAltered:(INModelProviderChangeSet *)changeSet
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeRemove] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeAdd] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadRowsAtIndexPaths:[changeSet indexPathsFor:INModelProviderChangeUpdate] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)provider:(INModelProvider*)provider dataFetchFailed:(NSError *)error
{
    NSLog(@"%@", error);
    
    //[[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    //[self.refreshControl endRefreshing];
}

- (void)providerDataFetchCompleted:(INModelProvider*)provider
{
    //[self.refreshControl endRefreshing];
}


@end
