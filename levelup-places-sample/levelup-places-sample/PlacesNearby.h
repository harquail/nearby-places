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
- (void)trackLocation;
- (void) fetchPlaces: (int) searchDistance;
- (BOOL) hasNextPage;
+ (NSString *) googleURLForPhotoReference: (NSString * ) photoRef;

@property (nonatomic, weak) id <PlacesDelegate> delegate;
@property NSMutableArray * placesList;
@end

