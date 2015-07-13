//
//  placesNearby.m
//  levelup-places-sample
//
//  Created by nook on 7/11/15.
//  Copyright (c) 2015 nook. All rights reserved.
//

#import "PlacesNearby.h"
#import "ApiKeysAndSecrets.h"

@interface PlacesNearby () <CLLocationManagerDelegate>

@property NSString *nextPage;
@property CLLocationManager * locationMgr;

@end

@implementation PlacesNearby

- (instancetype)init
{
    self = [super init];
    if (self) {
        _placesList = [[NSMutableArray alloc] init];
        _nextPage = @"firstPage";
    }
    return self;
}

- (void)trackLocation {
    _locationMgr = [[CLLocationManager alloc] init];
    _locationMgr.delegate = self;
    _locationMgr.distanceFilter = kCLDistanceFilterNone;
    _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    // ask user for permission to track location while in the app
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [_locationMgr requestWhenInUseAuthorization];
    
    [_locationMgr startUpdatingLocation];
}

- (void) fetchPlaces: (int) searchDistance{
    
    // find places open now within search distance
    GKPlacesNearbySearchQuery *query = [GKPlacesNearbySearchQuery query];
    query.coordinate = _locationMgr.location.coordinate;
    query.radius = (unsigned long) searchDistance;
    query.language = @"en";
    query.opennow = TRUE;
    
    // will query the next page of results if it exists
    if(_nextPage && ![_nextPage  isEqual: @"firstPage"]){
        query.nextPageToken = _nextPage;
    }
    
    [query searchPlaces:^(NSArray *results, NSString *nextPageToken, NSError *error) {
        
        // bail on error
        if (error != nil){
            NSLog(@"query error: %@",error);
            return;
        }
        
        _nextPage = nextPageToken;
        [_placesList addObjectsFromArray:results];
        
        // notify the delegate that places were updated
        [_delegate placesUpdated];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    // once we have a location, stop updating locations to save battery
    [_locationMgr stopUpdatingLocation];
    
    // fetch places nearby
    // 50,000 is the max search distance allowed
    [self fetchPlaces: 50000];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location manager error: %@",error);
}

- (BOOL) hasNextPage{
    return _nextPage != nil && ![_nextPage  isEqual: @"firstPage"];
}

+ (NSString *) googleURLForPhotoReference: (NSString * ) photoRef{
    return [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&maxheight=200&photoreference=%@&key=%@",photoRef,kGooglePlacesAPIKey];
}


@end
