//
//  DetailViewController.h
//  LocationBlog
//
//  Created by Derrick Ho on 7/20/14.
//  Copyright (c) 2014 dnthome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class BlogData;
@interface DetailViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) BlogData *detailItem;

@end
