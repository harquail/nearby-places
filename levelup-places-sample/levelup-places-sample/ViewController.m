//
//  ViewController.m
//  levelup-places-sample
//
//  Created by nook on 7/11/15.
//  Copyright (c) 2015 nook. All rights reserved.
//

#import "ViewController.h"
#import <GoogleKit/GoogleKit.h>

@interface ViewController () <CLLocationManagerDelegate>

/// #TODO: BOILERPLATE FROM https://developers.google.com/places/ios/start
// Instantiate a pair of UILabels in Interface Builder
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property CLLocationManager * locationMgr;


@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _locationMgr = [[CLLocationManager alloc] init];
    _locationMgr.delegate = self;
    _locationMgr.distanceFilter = kCLDistanceFilterNone;
    _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [_locationMgr requestWhenInUseAuthorization];
    
    [_locationMgr startUpdatingLocation];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    /// #TODO: BOILERPLATE FROM https://developers.google.com/places/ios/start
//    _placesClient = [[GMSPlacesClient alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///// #TODO: BOILERPLATE FROM https://developers.google.com/places/ios/start
//// Add a UIButton in Interface Builder to call this function
- (IBAction)getCurrentPlace:(UIButton *)sender {
    

    
    
    NSLog(@"tapped");
    

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    NSLog(@"location updated");
    
    NSLog(@"%@",locations.firstObject);
    [_locationMgr stopUpdatingLocation];

//    _locationMgr.location;
    //    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"FAILED");
    // ...
}

@end
