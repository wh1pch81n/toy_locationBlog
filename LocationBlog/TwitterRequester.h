//
//  TwitterRequester.h
//  LocationBlog
//
//  Created by Derrick Ho on 7/20/14.
//  Copyright (c) 2014 dnthome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <CoreLocation/CoreLocation.h>
@interface TwitterRequester : NSObject
@property (strong, nonatomic) ACAccountStore *accountStore;
+ (TwitterRequester *)instance;
- (BOOL)userHasAccessToTwitter;
- (void)postForUser:(NSString *)username coordinate:(CLLocationCoordinate2D)coordinate tweetMsg:(NSString *)tweetMessage dateModified:(NSDate *)dateModified;
- (void)testPost;
@end
