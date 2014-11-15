//
//  ViewController.m
//  MessageBoard
//
//  Created by Tulio Troncoso on 11/13/14.
//  Copyright (c) 2014 Tulio. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDiscussButtonClicked:(id)sender {

    UIViewController *vc = [[MessageBoardViewController alloc] init];
    
    [self presentViewController: vc animated:YES completion:^{
        
    }];
    
}


@end
