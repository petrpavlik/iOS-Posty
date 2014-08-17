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
#import "MessageViewController.h"
#import "AppDelegate.h"

#import "TagsTableViewController.h"

#import "ThreadTableViewCell+Inbox.h"

#import "MailSummaryView.h"
#import "SpamController.h"

@interface ThreadsTableViewController () <INModelProviderDelegate, TagsViewControllerDelegate, SpanControllerDelegate>

@property(nonatomic, strong) INThreadProvider* threadProvider;

@property(nonatomic) BOOL didProcessLaunchNotification;

@property(nonatomic, strong) MailSummaryView* summaryView;
@property(nonatomic, strong) SpamController* spamController;

@end

@implementation ThreadsTableViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Inbox";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"document-edit"] style:UIBarButtonItemStylePlain target:self action:@selector(composeEmailSelected)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn-gear"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsSelected)];
    
    SkinProvider* skin = [SkinProvider sharedInstance];
    
    UIButton* tagsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    tagsButton.frame = CGRectMake(0, 0, 120, 44);
    [tagsButton setTitle:@"Inbox" forState:UIControlStateNormal];
    [tagsButton addTarget:self action:@selector(testSelected) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = tagsButton;
    
    UIView* borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 120, 30)];
    borderView.layer.borderColor = tagsButton.tintColor.CGColor;
    borderView.layer.borderWidth = 1;
    borderView.userInteractionEnabled = NO;
    borderView.layer.cornerRadius = 4;
    [tagsButton addSubview:borderView];
    
    self.tableView.backgroundColor = skin.cellBackgroundColor;
    self.tableView.separatorColor = skin.cellSeparatorColor;
    self.tableView.tableFooterView = [UIView new];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl = refreshControl;
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[ThreadTableViewCell class] forCellReuseIdentifier:@"ThreadTableViewCell"];
    
    MailSummaryView* summaryView = [[MailSummaryView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = summaryView;
    _summaryView = summaryView;
    
    _spamController = [SpamController new];
    _spamController.delegate = self;
    
    INNamespace * namespace = [[[INAPIManager shared] namespaces] firstObject];
    
   // NSParameterAssert(namespace);
    
    self.threadProvider = [namespace newThreadProvider];
    self.threadProvider.itemSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastMessageDate" ascending:NO]];
    self.threadProvider.itemFilterPredicate = [NSPredicate predicateWithFormat:@"tagIDs = 'inbox'"];
    self.threadProvider.itemRange = NSMakeRange(0, 100);
    self.threadProvider.delegate = self;
    
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMailNotification:) name:DidReceiveMailNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData]; //fixes autosized cell bug
    
    if (!self.didProcessLaunchNotification) {
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        if (appDelegate.launchNotificationUserInfo) {
            
            self.didProcessLaunchNotification = YES;
            
            //[[[UIAlertView alloc] initWithTitle:nil message:appDelegate.launchNotificationUserInfo.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            
            NSString* messageId = appDelegate.launchNotificationUserInfo[MessageIdKey];
            
            if (messageId.length) {
                [self presentMessageWithId:messageId];
            }
        }
    }
}

#pragma mark -

- (void)refresh {
    
    if (self.refreshControl.isRefreshing) {
        return;
    }
    
    [self.refreshControl beginRefreshing];
    
    [self.threadProvider refresh];
    [self.spamController reload];
    
    [self.threadProvider countUnreadItemsWithCallback:^(long count) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    }];
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
    
    [cell setupWithThread:thread];
    
    [thread markAsSeen]; //TODO: check whether this fires a request more often that is acceptable
    
    return cell;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INThread * thread = [[self.threadProvider items] objectAtIndex: indexPath.row];
    
    MessagesTableViewController* controller = [[MessagesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.thread = thread;
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
    
    TagsTableViewController* controller = [[TagsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    controller.delegate = self;
    
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)settingsSelected {
    
    [[INAPIManager shared] unauthenticate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)tagsViewController:(TagsTableViewController *)controller didSelectTag:(INTag *)tag {
    
    self.title = tag.name;
    
    self.threadProvider.itemFilterPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tagIDs = '%@'", tag.ID]];
    
    [self.threadProvider refresh];
}

#pragma mark -

- (void)applicationWillEnterForegroundNotification:(NSNotification*)notification {
    
    [self refresh];
}

- (void)didReceiveMailNotification:(NSNotification*)notification {
    
    NSString* messageId = notification.userInfo[MessageIdKey];
    
    NSParameterAssert(messageId.length);
    
    [self presentMessageWithId:messageId];
}

#pragma mark -

- (void)presentMessageWithId:(NSString*)messageId {
    
    MessageViewController* controller = [[MessageViewController alloc] init];
    controller.messageId = messageId;
    
    NavigationController* navigationController = [[NavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark -

- (void)spamController:(SpamController *)controller didDetectSpamStatus:(BOOL)spamReceived {
    
    self.summaryView.gotSpamToday = spamReceived;
}

@end
