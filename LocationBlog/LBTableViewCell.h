//
//  LBTableViewCell.h
//  LocationBlog
//
//  Created by Derrick Ho on 7/20/14.
//  Copyright (c) 2014 dnthome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *header, *dateModified;
@property (strong, nonatomic) IBOutlet UIButton *twitter_b, *facebook_b;

@end
