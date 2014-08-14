//
//  AttachmentView.h
//  MailClient
//
//  Created by Petr Pavlik on 13/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AttachmentViewStateNotLoaded,
    AttachmentViewStateLoading,
    AttachmentViewStateNotLoading,
} AttachmentViewState;

@interface AttachmentView : UIView

@property(nonatomic, strong) NSString* name;
@property(nonatomic) AttachmentViewState state;

@end
