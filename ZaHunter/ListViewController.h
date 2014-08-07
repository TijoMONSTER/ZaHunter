//
//  ViewController.h
//  ZaHunter
//
//  Created by Iván Mervich on 8/6/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ListViewController : UIViewController

- (void)reloadTableViewWithArray:(NSMutableArray *)pizzaRestaurants currentLocation:(CLLocation *)currentLocation;

@end
