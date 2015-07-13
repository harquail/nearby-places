//
//  PlacesTableViewController.m
//  levelup-places-sample
//
//  Created by nook on 7/11/15.
//  Copyright (c) 2015 nook. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "PlacesNearby.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PlacesTableViewController () <UITableViewDataSource,UITableViewDelegate,PlacesDelegate>

// list of places
@property PlacesNearby * places;

@end

@implementation PlacesTableViewController


// hide the status bar
- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad{
    _places = [[PlacesNearby alloc] init];
    _places.delegate = self;
    // on load, start tracking location and fetch places
    [_places trackLocation];
}

#pragma mark - UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _places.placesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // recycle a cell if we have a spare one
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
    
    // otherwise, make a new cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlaceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // places fetched as a result of trackLocation
    GKPlace * place = ((GKPlace *)[_places.placesList objectAtIndex:indexPath.row]);
    
    cell.textLabel.text = place.name;
    
    // set photo — if place has a photo provided by Google Places, use that.  Otherwise, use the place icon
    NSString * photoRef = place.photoReference;
    NSString * photoURL = (photoRef) ? [PlacesNearby googleURLForPhotoReference:photoRef] : place.icon;
    
    // load images asynchronously
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photoURL]
                    placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    // load more places when the user scrolls to the bottom
    if (indexPath.row == [_places.placesList count] - 1 && _places.hasNextPage)
    {
        [_places fetchPlaces:5000];
    }
    
    return cell;
}

#pragma mark - Places delegate methods

-(void) placesUpdated{
    [self.tableView reloadData];
}


@end
