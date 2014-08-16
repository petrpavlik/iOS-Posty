//
//  SpamController.h
//  MailClient
//
//  Created by Petr Pavlik on 16/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpamController;

@protocol SpanControllerDelegate <NSObject>

- (void)spamController:(SpamController*)controller didDetectSpamStatus:(BOOL)spamReceived;

@end

@interface SpamController : NSObject

@property(nonatomic, weak) id <SpanControllerDelegate> delegate;

- (void)reload;

@end
