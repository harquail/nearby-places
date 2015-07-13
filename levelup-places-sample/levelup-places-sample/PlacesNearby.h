//
//  placesNearby.h
//  levelup-places-sample
//
//  Created by nook on 7/11/15.
//  Copyright (c) 2015 nook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleKit/GoogleKit.h>

@protocol PlacesDelegate <NSObject>
@optional
-(void) placesUpdated;
@end

@interface PlacesNearby : UITableViewController <CLLocationManagerDelegate>

/**
 Begin tracking user location — calls fetchPlaces when a location is found
 */
- (void)trackLocation;

/**
 Fetches nearby places from Google Places — stores places into placesList
 @param searchDistance the search radius for places, in meters
 */
- (void) fetchPlaces: (int) searchDistance;

/**
 Constructs the API url for a photo reference
 @param photoRef the photo reference stored in a GKPlace
 @return an NSString with the full URL the the photo
 */
+ (NSString *) googleURLForPhotoReference: (NSString * ) photoRef;

/**
 PlacesNearby has next page if additional places can be fetched from the Places API.  Google Places returns a maximum of 60 results for a query, split into three pages.
 @return a BOOL representing whether there are more results
 */
- (BOOL) hasNextPage;

/**
 The delegate that will be notified when locations are updated
 */
@property (nonatomic, weak) id <PlacesDelegate> delegate;

/**
 A list of GKPlaces fetched from Google Places API
 */
@property NSMutableArray * placesList;
@end

