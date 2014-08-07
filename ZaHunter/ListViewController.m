//
//  ViewController.m
//  ZaHunter
//
//  Created by Iván Mervich on 8/6/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ListViewController.h"
#import <MapKit/MapKit.h>
#import "Pizzaria.h"

@interface ListViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property UIActivityIndicatorView *activityIndicator;
@property NSMutableArray *pizzaRestaurants;
@property CLLocation *currentLocation;
@property UILabel *tableFooterView;

@property double expectedTravelTimeInMinutes;
@property int routesLeftToCalculate;
@property int currentMapItemIndex;

@end

@implementation ListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableFooterView = (UILabel *)self.tableView.tableFooterView;
}

- (void)reloadTableViewWithArray:(NSMutableArray *)pizzaRestaurants currentLocation:(id)currentLocation
{
	self.pizzaRestaurants = pizzaRestaurants;
	self.currentLocation = currentLocation;
	[self.tableView reloadData];
	[self getRoutes];
}

- (void)getRoutes
{
	self.currentMapItemIndex = 0;
	self.expectedTravelTimeInMinutes = 0.0;
	self.routesLeftToCalculate = [self.pizzaRestaurants count] - 1;

	MKMapItem *destinationMapItem = [(Pizzaria *)self.pizzaRestaurants[self.currentMapItemIndex] mapItem];
	[self getDirectionsFrom:[MKMapItem mapItemForCurrentLocation] to:destinationMapItem];
}

- (void)getDirectionsFrom:(MKMapItem *)source to:(MKMapItem *)destination
{
	MKDirectionsRequest *request = [MKDirectionsRequest new];
	request.source = source;
	request.destination = destination;
	request.transportType = MKDirectionsTransportTypeWalking;

	MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

	[directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
		MKRoute *route = [response.routes firstObject];

		// route.expectedTimeTravel comes in seconds
		self.expectedTravelTimeInMinutes += (route.expectedTravelTime / 60.0);
		self.tableFooterView.text = [NSString stringWithFormat:@"Total time: %.02f minutes", self.expectedTravelTimeInMinutes];

		if (--self.routesLeftToCalculate > 0) {
			self.currentMapItemIndex++;

			// add 50 minutes every time
			self.expectedTravelTimeInMinutes += 50.0;

			MKMapItem *sourceMapItem = [(Pizzaria *)self.pizzaRestaurants[self.currentMapItemIndex] mapItem];
			MKMapItem *destinationMapItem = [(Pizzaria *)self.pizzaRestaurants[self.currentMapItemIndex + 1] mapItem];
			[self getDirectionsFrom:sourceMapItem to:destinationMapItem];
		}
	}];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.pizzaRestaurants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];

	if ([self.pizzaRestaurants count] > 0) {
		Pizzaria *restaurant = self.pizzaRestaurants[indexPath.row];
		cell.textLabel.text = restaurant.mapItem.name;
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f m", [restaurant distanceFromLocation:self.currentLocation]];
	}

	return cell;
}

@end