//
//  ViewController.m
//  ZaHunter
//
//  Created by Iván Mervich on 8/6/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property CLLocationManager *locationManager;
@property NSArray *pizzaRestaurants;

@property UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.locationManager = [CLLocationManager new];
	self.locationManager.delegate = self;

	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicator.center = self.view.center;

	[self.locationManager startUpdatingLocation];
	[self.activityIndicator startAnimating];
	[self.view addSubview:self.activityIndicator];
}

- (void)reverseGeocode:(CLLocation *)location
{
	CLGeocoder *geocoder = [CLGeocoder new];
	[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
		CLPlacemark *placemark = [placemarks firstObject];
		[self findLocationsNear:placemark.location];
	}];
}

- (void)findLocationsNear:(CLLocation *)location
{
	MKLocalSearchRequest *request = [MKLocalSearchRequest new];
	request.naturalLanguageQuery = @"Pizza";
	request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));

	MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
	[search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
		self.pizzaRestaurants = response.mapItems;
		[self.tableView reloadData];

		[self.activityIndicator stopAnimating];
		[self.activityIndicator removeFromSuperview];
	}];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	for (CLLocation *location in locations) {
		[self.locationManager stopUpdatingLocation];
		[self reverseGeocode:location];
	}
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.pizzaRestaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
	MKMapItem *mapItem = self.pizzaRestaurants[indexPath.row];

	cell.textLabel.text = mapItem.name;

	return cell;
}

@end
