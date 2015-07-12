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

@property PlacesNearby * places;

@end

@implementation PlacesTableViewController


- (void)viewDidLoad{
    _places = [[PlacesNearby alloc] init];
    _places.delegate = self;
    [_places trackLocation];
}

-(void) placesUpdated{
    
    //    NSLog(@"places: %@",_places.placesList);
    
    [self.tableView reloadData];
    NSLog(@"UPDATED PLACES");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%i",_places.placesList.count);
    return _places.placesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlaceCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    GKPlace * place = ((GKPlace *)[_places.placesList objectAtIndex:indexPath.row]);
    
    cell.textLabel.text = place.name;
    
    NSString * photoRef = place.photoReference;
    NSString * photoURL = (photoRef) ? [PlacesNearby googleURLForPhotoReference:photoRef] : place.icon;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photoURL]
        placeholderImage:[UIImage imageNamed:@"placeholder"]
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            

//            BOOL cellIsVisible = [[self.tableView indexPathsForVisibleRows] indexOfObject:indexPath] != NSNotFound;

            
//            if (cellIsVisible) {
//                
//                // Set our rows background dependent upon its positions
//                UIImage *rowBackground = nil;
//                UIImage *selectionBackground = nil;
//                
//                /* Logic to assign your backgroundView and selectedBackgroundView here */
//                
//                ((UIImageView *)cell.backgroundView).image = rowBackground;
//                ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
//                
//                
//                [cell.imageView setImage:image];
////                [cell.imageView setNeedsDisplay];
//            }
            
//            [cell.backgroundView setNeedsDisplay];
        }
     ];
    
    if (indexPath.row == [_places.placesList count] - 1 && _places.hasNextPage)
    {
        [_places fetchPlaces:5000];
    }
    
    return cell;
}





@end
