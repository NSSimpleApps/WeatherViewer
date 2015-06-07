//
//  ViewController.m
//  WeatherViewer
//
//  Created by NSSimpleApps on 07.06.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "ViewController.h"
#import "WeatherLayer.h"
#import "WeatherOverlayRenderer.h"
@import MapKit;

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) WeatherLayer *weatherLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.weatherLayer = [[WeatherLayer alloc] init];
    
    [self.mapView addOverlay:self.weatherLayer];
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            
            [self.locationManager requestWhenInUseAuthorization];
        }
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), MKCoordinateSpanMake(10, 10))];
    
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    self.locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"%@", error);
    [manager stopUpdatingLocation];
    manager.delegate = nil;
    self.locationManager = nil;
}

#pragma - mark MKMapViewDelegate,

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isEqual:self.weatherLayer]) {
        
        WeatherOverlayRenderer *renderer = [[WeatherOverlayRenderer alloc] initWithOverlay:overlay];
        return renderer;
    }
    return nil;
}


@end
