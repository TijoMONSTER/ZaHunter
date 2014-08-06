//
//  Pizzaria.h
//  ZaHunter
//
//  Created by Iván Mervich on 8/6/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pizzaria : NSObject

@property MKMapItem *mapItem;

- (instancetype)initWithMapItem:(MKMapItem *)mapItem;
- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;

@end
