//
//  BlogData+MKAnnotation.m
//  LocationBlog
//
//  Created by Derrick Ho on 7/20/14.
//  Copyright (c) 2014 dnthome. All rights reserved.
//

#import "BlogData+MKAnnotation.h"

@implementation BlogData (MKAnnotation)

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coord;
    coord.longitude = self.longitude.doubleValue;
    coord.latitude = self.latitude.doubleValue;
    return coord;
}

@end
