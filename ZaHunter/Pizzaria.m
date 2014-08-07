//
//  Pizzaria.m
//  ZaHunter
//
//  Created by Iván Mervich on 8/6/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Pizzaria.h"

@implementation Pizzaria

- (instancetype)initWithMapItem:(MKMapItem *)mapItem
{
	self = [super init];
	self.mapItem = mapItem;
	return self;
}

- (CLLocationDistance)distanceFromLocation:(CLLocation *)location
{
	return [self.mapItem.placemark.location distanceFromLocation:location];
}
@end
	