//
//  TabBarController.m
//  ZaHunter
//
//  Created by Iván Mervich on 8/6/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "TabBarController.h"
#import "Pizzaria.h"
#import "ListViewController.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface TabBarController () <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property NSMutableArray *pizzaRestaurants;
@property CLLocation *currentLocation;

@property UIActivityIndicatorView *activityIndicator;

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.pizzaRestaurants = [NSMutableArray new];

	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicator.center = self.view.center;

	self.locationManager = [CLLocationManager new];
	self.locationManager.delegate = self;

	[self.locationManager startUpdatingLocation];

	[self.activityIndicator startAnimating];
	[self.view addSubview:self.activityIndicator];
}

- (void)findNearPizzaRestaurants
{
	MKLocalSearchRequest *request = [MKLocalSearchRequest new];
	request.naturalLanguageQuery = @"pizza";
	// 10 kilometers
	request.region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 10000, 10000);

	MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
	[search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {

		NSArray *mapItems = [response.mapItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

			// get the locations
			CLLocation *locationObj1 = [(MKMapItem *)obj1 placemark].location;
			CLLocation *locationObj2 = [(MKMapItem *)obj2 placemark].location;
			// calculate distances with current location
			NSNumber *distanceObj1 = [NSNumber numberWithDouble:[locationObj1 distanceFromLocation:self.currentLocation]];
			NSNumber *distanceObj2 = [NSNumber numberWithDouble:[locationObj2 distanceFromLocation:self.currentLocation]];

			return [distanceObj1 compare:distanceObj2];
		}];

		// add 4 elements to self.pizzaRestaurants
		int numItems = 0;
		for (MKMapItem *mapItem in mapItems) {
			if (numItems++ < 4) {
				[self.pizzaRestaurants addObject:[[Pizzaria alloc] initWithMapItem:mapItem]];
			} else {
				break;
			}
		}

		// reload table view
		[(ListViewController *)self.viewControllers[0] reloadTableViewWithArray:self.pizzaRestaurants currentLocation:self.currentLocation];
		// reload map view
		[(MapViewController *)self.viewControllers[1] reloadAnnotationsWithArray:self.pizzaRestaurants currentLocation:self.currentLocation];

		[self.activityIndicator stopAnimating];
		[self.activityIndicator removeFromSuperview];
	}];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	for (CLLocation *location in locations) {
		[self.locationManager stopUpdatingLocation];

		self.currentLocation = location;
		[self findNearPizzaRestaurants];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"location error %@", [error localizedDescription]);
}

@end
