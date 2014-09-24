//
//  ChatViewController.h
//  MatchedUP
//
//  Created by Thanh Trinh on 9/21/14.
//  Copyright (c) 2014 Thanh Q Trinh. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "MatchedUP-Prefix.pch"

@interface ChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>
@property (strong, nonatomic) PFObject *chatRoom;

@end
