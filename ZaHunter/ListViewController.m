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
@end


@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)reloadTableViewWithArray:(NSMutableArray *)pizzaRestaurants currentLocation:(id)currentLocation
{
	self.pizzaRestaurants = pizzaRestaurants;
	self.currentLocation = currentLocation;
	[self.tableView reloadData];
	self.tableView.hidden = NO;
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