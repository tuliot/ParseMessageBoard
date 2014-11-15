//
//  MessageBoardTableViewCell.m
//  MessageBoard
//
//  Created by Tulio Troncoso on 11/15/14.
//  Copyright (c) 2014 Tulio. All rights reserved.
//

#import "MessageBoardTableViewCell.h"

@implementation MessageBoardTableViewCell

@synthesize messageTextView;

- (void)awakeFromNib {
    // Initialization code
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
