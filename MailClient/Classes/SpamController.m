//
//  SpamController.m
//  MailClient
//
//  Created by Petr Pavlik on 16/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "SpamController.h"
#import <Inbox.h>

@interface SpamController () <INModelProviderDelegate>

@property(nonatomic, strong) INThreadProvider* threadProvider;

@end

@implementation SpamController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    INNamespace * namespace = [[[INAPIManager shared] namespaces] firstObject];
    self.threadProvider = [namespace newThreadProvider];
    self.threadProvider.itemSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastMessageDate" ascending:NO]];
    self.threadProvider.itemFilterPredicate = [NSPredicate predicateWithFormat:@"tagIDs = 'spam'"];
    self.threadProvider.itemRange = NSMakeRange(0, 1);
    self.threadProvider.delegate = self;
}

- (void)reload {
    [self.threadProvider refresh];
}

- (void)evaluateModel {
    
    if (self.threadProvider.items.count) {
        
        INThread* thread = (INThread*)self.threadProvider.items.firstObject;
        
        NSDate *current = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:current];
        NSDateComponents* comp2 = [calendar components:unitFlags fromDate:thread.lastMessageDate];
        
        if ([comp1 day]   == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year]) {
            
            [self.delegate spamController:self didDetectSpamStatus:YES];
            return;
        }
    }
    
    [self.delegate spamController:self didDetectSpamStatus:NO];
}

#pragma mark -

- (void)providerDataChanged:(INModelProvider*)provider
{
    [self evaluateModel];
}

- (void)provider:(INModelProvider*)provider dataAltered:(INModelProviderChangeSet *)changeSet
{
    [self evaluateModel];
}

- (void)provider:(INModelProvider*)provider dataFetchFailed:(NSError *)error
{
  
}

- (void)providerDataFetchCompleted:(INModelProvider*)provider
{
    
}

@end
