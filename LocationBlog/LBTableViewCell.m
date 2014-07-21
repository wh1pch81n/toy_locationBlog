//
//  LBTableViewCell.m
//  LocationBlog
//
//  Created by Derrick Ho on 7/20/14.
//  Copyright (c) 2014 dnthome. All rights reserved.
//

#import "LBTableViewCell.h"

@implementation LBTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
