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
@property NSMutableArray *coordinates;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"lat count: %li", self.latitudes.count);
    NSLog(@"long count: %li", self.longitudes.count);

    for (int i = 0; i < self.longitudes.count; i++) {
        if (![self.latitudes[i] isEqualToNumber:@0]) {
            CLLocationCoordinate2D coord;
            coord.longitude = [self.longitudes[i] doubleValue];
            coord.latitude = [self.latitudes[i] doubleValue];
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake(coord.latitude, coord.longitude);
//            annotation.title =
            [self.mapView addAnnotation:annotation];
        }
    }
}
@end
