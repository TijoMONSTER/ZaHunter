//
//  MapViewController.m
//  ZaHunter
//
//  Created by Iván Mervich on 8/6/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import "Pizzaria.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property NSMutableArray *pizzaRestaurants;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)reloadAnnotationsWithArray:(NSMutableArray *)pizzaRestaurants
{
	self.pizzaRestaurants = pizzaRestaurants;
	// set annotations
	[self addAnnotations];
	self.mapView.hidden = NO;
}

- (void)addAnnotations
{
	for (Pizzaria *restaurant in self.pizzaRestaurants) {

		MKPointAnnotation *annotation = [MKPointAnnotation new];
		annotation.title = restaurant.mapItem.name;
		annotation.coordinate = restaurant.mapItem.placemark.location.coordinate;
		[self.mapView addAnnotation:annotation];
	}
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	MKPinAnnotationView *pin;
	if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
		pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
		pin.canShowCallout = YES;
		pin.image = [UIImage imageNamed:@"pizza"];
	}
	return pin;
}

@end
