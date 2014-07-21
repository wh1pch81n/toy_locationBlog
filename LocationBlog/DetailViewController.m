//
//  DetailViewController.m
//  LocationBlog
//
//  Created by Derrick Ho on 7/20/14.
//  Copyright (c) 2014 dnthome. All rights reserved.
//

#import "DetailViewController.h"
#import "BlogData.h"
#include "TwitterRequester.h"

@interface DetailViewController ()
- (void)configureView;
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UINavigationItem *buttonCurrentLocation;

@property (weak, nonatomic) IBOutlet UITextField *headerTextfield;
@property (strong, nonatomic) CLLocationManager *locMan;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(BlogData *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.text.text = self.detailItem.textBody;
        self.headerTextfield.text = self.detailItem.header;
        [self updatePin];
    }
}

- (void)updatePin {
    if (self.detailItem.longitude != nil && self.detailItem.latitude != nil) {
        [self.map addAnnotation:self.detailItem];
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake( self.detailItem.latitude.doubleValue, self.detailItem.longitude.doubleValue);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.50, 0.50);
        MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);
        [self.map setRegion:region animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CLLocationManager *)locMan {
    if (_locMan == nil) {
        _locMan = [CLLocationManager new];
        _locMan.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locMan.delegate = self;
    }
    return _locMan;
}

- (IBAction)TappedPinCurrentLocationButton:(id)sender {
    [self.locMan startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate 

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = [locations lastObject];
    
    self.detailItem.latitude = @(loc.coordinate.latitude);
    self.detailItem.longitude = @(loc.coordinate.longitude);
    
    [self.locMan stopUpdatingLocation];
    [self updatePin];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locMan stopUpdatingLocation];
    [self setLocMan:nil];
    [[[UIAlertView alloc] initWithTitle:@"Problem Acquiring Location"
                               message:@"Make sure Location Services is enabled in settings.  Otherwise try again at another time"
                              delegate:self cancelButtonTitle:@"Ok"
                     otherButtonTitles:nil] show];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.detailItem.textBody = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.detailItem.header = textField.text;
    [textField resignFirstResponder];
    return NO;
}

@end
