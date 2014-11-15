//
//  MessageBoardViewController.m
//  MessageBoard
//
//  Created by Tulio Troncoso on 11/14/14.
//  Copyright (c) 2014 Tulio. All rights reserved.
//

#import "MessageBoardViewController.h"

#define kMessageBoardTableCellReuseIdentifier @"kMessageBoardTableCell"
#define kOFFSET_FOR_KEYBOARD 230

@interface MessageBoardViewController ()

@end

@implementation MessageBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _messages = [[NSMutableArray alloc] init];
    [_messageBoardTableView setDataSource:self];
    [_messageBoardTableView setDelegate:self];
    [_postMessage setDelegate:self];
    
    
    [self getMessagesFromParse];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(action_Timer)
                                               userInfo:nil
                                                repeats:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        });        
    });
    
}

-(void)action_Timer {
    if ([self.postMessage isEditing]) {
        return;
    }
    // This is called on the main queue, so dispatch to a background queue.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Timer called");
        [self getMessagesFromParse];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)handleClick:(id)sender {
    if ( sender == _postButton && ![_postMessage.text isEqualToString:@""]) {
        
        [self.view endEditing:YES];
        NSLog(_postMessage.text);
        
        [self putMessage:_postMessage.text withUsername:nil];

//        [_messageBoardTableView beginUpdates];
        
        //insert into tableview
        [_messages addObject:_postMessage.text];
        
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
        [indexPaths addObject:newIndexPath];
        
        [_messageBoardTableView insertRowsAtIndexPaths: indexPaths withRowAnimation: UITableViewRowAnimationRight];
        
//        [_messageBoardTableView endUpdates];
//        [_messageBoardTableView reloadData];

        //[self getMessagesFromParse];
    }
}

- (void) clearTextBox {
    [_postMessage setText:@""];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)keyboardWillShow {
//    // Animate the current view out of the way
//    if (self.bottomContainer.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if (self.bottomContainer.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
    
    //move the bottomContainer

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view

    CGRect frame = self.bottomContainer.frame;
    CGFloat y = self.constraintBottomContainerVerticalSpaceToParent.constant +kOFFSET_FOR_KEYBOARD;
    [self.constraintBottomContainerVerticalSpaceToParent setConstant: y];
    [UIView commitAnimations];
    
}

-(void)keyboardWillHide {
//    if (self.bottomContainer.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if (self.bottomContainer.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
    //move the bottomContainer
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect frame = self.bottomContainer.frame;
    frame.origin.y += kOFFSET_FOR_KEYBOARD;
    CGFloat y = self.constraintBottomContainerVerticalSpaceToParent.constant - kOFFSET_FOR_KEYBOARD;
    [self.constraintBottomContainerVerticalSpaceToParent setConstant:y];
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
        //move the main view, so that the keyboard does not hide it.
        if  (self.bottomContainer.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.bottomContainer.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        //rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.bottomContainer.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma mark - TableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [_messages count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessageBoardTableCellReuseIdentifier];
    
    if (cell == nil) {
        [_messageBoardTableView registerNib: [UINib nibWithNibName:@"MessageBoardTableViewCell" bundle:nil] forCellReuseIdentifier:kMessageBoardTableCellReuseIdentifier];
        cell = [_messageBoardTableView dequeueReusableCellWithIdentifier:kMessageBoardTableCellReuseIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageBoardTableViewCell *c = cell;
    [c.messageTextView setText: [_messages objectAtIndex: _messages.count - indexPath.row -1] ];
    
    [self clearTextBox];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int selectedRow = indexPath.row;
    NSLog(@"touch on row %d", selectedRow);
}


#pragma mark - Parse
- (void) putMessage: (NSString*)message withUsername:(NSString*)username{
    //parse shit
    PFObject *testObject = [PFObject objectWithClassName:@"Message"];
    testObject[@"text"] = message;
    testObject[@"username"] = @"Tulio";
    [testObject saveInBackground];
}

- (void) getMessagesFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            //NSLog(@"There are %lu messages", (unsigned long)[objects count]);
            
            [_messages removeAllObjects];
            
            for (PFObject *obj in objects) {
                [_messages addObject: obj[@"text"]];
                //NSLog(@"Message is: %@", obj[@"text"]);
            }
            
            [_messageBoardTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
@end
