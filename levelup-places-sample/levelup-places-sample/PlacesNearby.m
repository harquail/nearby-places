//
//  placesNearby.m
//  levelup-places-sample
//
//  Created by nook on 7/11/15.
//  Copyright (c) 2015 nook. All rights reserved.
//

#import "PlacesNearby.h"

@interface PlacesNearby () <CLLocationManagerDelegate>

@property NSString *nextPage;
@property CLLocationManager * locationMgr;

@end

@implementation PlacesNearby

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _nextPage = nil;
//    }
//    return self;
//}

- (void)trackLocation {
    _locationMgr = [[CLLocationManager alloc] init];
    _locationMgr.delegate = self;
    _locationMgr.distanceFilter = kCLDistanceFilterNone;
    _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [_locationMgr requestWhenInUseAuthorization];
    
    [_locationMgr startUpdatingLocation];
    
}

- (void) places: (int) searchDistance{
    

    GKPlacesNearbySearchQuery *query = [GKPlacesNearbySearchQuery query];
    
    NSLog(@"key: %@",query.key);

    
    // required parameters
//    query.key = @"key";
    query.coordinate = _locationMgr.location.coordinate;
    query.rankByDistance = NO; // if rankByDistance sets to YES radius will be ignored
    query.radius = (unsigned long) searchDistance;
    // optional parameters
    query.language = @"en";
    
    if(_nextPage){
        query.nextPageToken = _nextPage;
    }

    [query searchPlaces:^(NSArray *results, NSString *nextPageToken, NSError *error) {
        
        
//        GKPlace *place = [results firstObject];
        if (error != nil){
            NSLog(@"%@",error);
            sleep(1);
            [self places: searchDistance];
            return;
        }
        
        _nextPage = nextPageToken;
        for (GKPlace * place in results){
            NSLog(@"place: %@",place.name);
//            place.icon;
        }
        NSLog(@"next page: %@",_nextPage);
        NSLog(@"next page letter count: %lu",(unsigned long)_nextPage.length);

        if(_nextPage.length > 0 && [results count] != 0){
            sleep(1);
            [self places: searchDistance];
        }
    }];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"location updated");
    
    NSLog(@"%@",locations.firstObject);
    [_locationMgr stopUpdatingLocation];
    [self places: 500000];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"FAILED");
    // ...
}


@end
