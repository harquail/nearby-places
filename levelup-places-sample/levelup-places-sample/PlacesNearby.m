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
    }
    return self;
}

- (void)trackLocation {
    _locationMgr = [[CLLocationManager alloc] init];
    _locationMgr.delegate = self;
    _locationMgr.distanceFilter = kCLDistanceFilterNone;
    _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [_locationMgr requestWhenInUseAuthorization];
    
    [_locationMgr startUpdatingLocation];
    
}

- (void) fetchPlaces: (int) searchDistance{
    
    GKPlacesNearbySearchQuery *query = [GKPlacesNearbySearchQuery query];

    
    // required parameters
//    query.key = @"key";
    query.coordinate = _locationMgr.location.coordinate;
    query.rankByDistance = YES; // if rankByDistance sets to YES radius will be ignored
    query.radius = (unsigned long) searchDistance;
    // optional parameters
    query.language = @"en";
    query.opennow = TRUE;
    
    if(_nextPage){
        query.nextPageToken = _nextPage;
    }

    [query searchPlaces:^(NSArray *results, NSString *nextPageToken, NSError *error) {
        
        _nextPage = nextPageToken;

        if (error != nil){
            NSLog(@"%@",error);
//            sleep(4);
            [self fetchPlaces: searchDistance];
            return;
        }
//
        NSLog(@"next page: %@",_nextPage);

        [_placesList addObjectsFromArray:results];
        
        for (GKPlace * place in _placesList) {
            NSLog(@"%@",place.name);
            NSLog(@"%@",place.photoReference);
        }
        
        
        [_delegate placesUpdated];
//        for (GKPlace * place in results){
//            NSLog(@"place: %@",place.name);
//        }
//        NSLog(@"next page: %@",_nextPage);
//        NSLog(@"next page letter count: %lu",(unsigned long)_nextPage.length);

//        // this will happen at most 3 times, because google places limits requests to returning 60 results, with 20 results per page
        if(_nextPage.length > 0 && [results count] != 0){
//            sleep(2);
//            [self fetchPlaces: searchDistance];
        }
    }];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"location updated");
    
    NSLog(@"%@",locations.firstObject);
    [_locationMgr stopUpdatingLocation];
    
    // 50,000 is the max search distance allowed
    [self fetchPlaces: 50000];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"FAILED");
    // ...
}

- (BOOL) hasNextPage{
    return _nextPage != nil;
}

+ (NSString *) googleURLForPhotoReference: (NSString * ) photoRef{
    return [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&maxheight=200&photoreference=%@&key=%@",photoRef,kGooglePlacesAPIKey];
}


@end
