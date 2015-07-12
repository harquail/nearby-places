//
//  PlacesTableViewController.m
//  levelup-places-sample
//
//  Created by nook on 7/11/15.
//  Copyright (c) 2015 nook. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "PlacesNearby.h"

@interface PlacesTableViewController ()

@property PlacesNearby * places;

@end

@implementation PlacesTableViewController


- (void)viewDidLoad{
    _places = [[PlacesNearby alloc] init];
    [_places trackLocation];
}

@end
