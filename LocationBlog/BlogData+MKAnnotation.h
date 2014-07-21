//
//  BlogData+MKAnnotation.h
//  LocationBlog
//
//  Created by Derrick Ho on 7/20/14.
//  Copyright (c) 2014 dnthome. All rights reserved.
//

#import "BlogData.h"
#import <MapKit/MapKit.h>

@interface BlogData (MKAnnotation) <MKAnnotation>

// Center latitude and longitude of the annotion view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
