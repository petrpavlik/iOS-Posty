//
//  TagsTableViewController.h
//  MailClient
//
//  Created by Petr Pavlik on 24/07/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagsTableViewController;
@class INTag;

@protocol TagsViewControllerDelegate <NSObject>

- (void)tagsViewController:(TagsTableViewController*)controller didSelectTag:(INTag*)tag;

@end

@interface TagsTableViewController : UITableViewController

@property(nonatomic, weak) id <TagsViewControllerDelegate> delegate;

@end
