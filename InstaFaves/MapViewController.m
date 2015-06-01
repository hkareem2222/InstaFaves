//
//  MapViewController.m
//  InstaFaves
//
//  Created by Husein Kareem on 5/31/15.
//  Copyright (c) 2015 Husein Kareem. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"lat count: %li", self.latitudes.count);
    NSLog(@"long count: %li", self.longitudes.count);
}
@end
