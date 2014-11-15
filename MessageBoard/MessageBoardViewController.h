//
//  MessageBoardViewController.h
//  MessageBoard
//
//  Created by Tulio Troncoso on 11/14/14.
//  Copyright (c) 2014 Tulio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBoardTableViewCell.h"
#import <Parse/Parse.h>
#import <dispatch/dispatch.h>

@interface MessageBoardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *bottomContainer;
@property (strong, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic) IBOutlet UITextField *postMessage;
@property (strong, nonatomic) IBOutlet UITableView *messageBoardTableView;
@property (strong, nonatomic)          NSMutableArray *messages;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomContainerVerticalSpaceToParent;
@end
