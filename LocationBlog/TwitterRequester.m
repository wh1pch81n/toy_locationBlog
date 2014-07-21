//
//  TwitterRequester.m
//  LocationBlog
//
//  Created by Derrick Ho on 7/20/14.
//  Copyright (c) 2014 dnthome. All rights reserved.
//

#import "TwitterRequester.h"

@interface TwitterRequester ()

//@property (strong, nonatomic) ACAccountStore *accountStore;

@end

@implementation TwitterRequester

//- (id)init {
//    self = [super init];
//    if (self) {
//        _accountStore = [[ACAccountStore alloc] init];
//    }
//    return self;
//}

+ (TwitterRequester *)instance {
    static TwitterRequester *instance = nil;
    @synchronized(self) {
        if(instance == nil) {
            instance = [TwitterRequester new];
            instance.accountStore = [ACAccountStore new];
        }
    }
    return instance;
}

- (BOOL)userHasAccessToTwitter
{
  return [SLComposeViewController
          isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)testPost { //TODO: adjust this so that it includes the msg, and location data.
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     {
       if (granted)
         {
           NSArray *accounts = [accountStore accountsWithAccountType:accountType];
           if (accounts.count)
             {
               NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
               [dict setValue:@"check Check CHECK" forKey:@"status"];
               
               NSString *retweetString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/update.json"];
               NSURL *retweetURL = [NSURL URLWithString:retweetString];
               SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:retweetURL parameters:dict];
           
               request.account = [accounts objectAtIndex:0];
               
               [request performRequestWithHandler:^(NSData *responseData1, NSHTTPURLResponse *urlResponse, NSError *error)
                {
                  
                  if (responseData1)
                    {
                      
                      NSError *error1 = nil;
                      id response = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableLeaves error:&error1];
                      NSLog(@"%@", response);
                    }
                }];
             }
         }
       
     }];
}

- (void)postForUser:(NSString *)username coordinate:(CLLocationCoordinate2D)coordinate tweetMsg:(NSString *)tweetMessage dateModified:(NSDate *)dateModified
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [[[TwitterRequester instance] accountStore] accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
//        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]]; //optionally set times zones
        NSString *stringFromDate = [formatter stringFromDate:dateModified];
        
        [[[TwitterRequester instance] accountStore]
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [[[TwitterRequester instance] accountStore] accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:
                               @"https://api.twitter.com"
                               "/1.1/statuses/update_with_media.json"];
                 NSDictionary *params = @{
                                          @"screen_name" : username,
                                          @"coordinates" :@{
                                                  @"coordinates": @[
                                                          @(coordinate.latitude),
                                                          @(coordinate.longitude)
                                                          ],
                                                  @"type": @"Point"
                                                  },
                                          @"created_at": stringFromDate,
                                          @"status":tweetMessage
                                          };
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodPOST
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error) {
                      
                      if (responseData) {
                          if (urlResponse.statusCode >= 200 &&
                              urlResponse.statusCode < 300) {
                              
                              NSError *jsonError;
                              NSDictionary *timelineData =
                              [NSJSONSerialization
                               JSONObjectWithData:responseData
                               options:NSJSONReadingAllowFragments error:&jsonError];
                              if (timelineData) {
                                  NSLog(@"Timeline Response: %@\n", timelineData);
                              }else {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                              }
                          }
                          else {
                              // The server did not respond ... were we rate-limited?
                              NSLog(@"The response status code is %d",
                                    urlResponse.statusCode);
                          }
                      }
                  }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}
@end
    