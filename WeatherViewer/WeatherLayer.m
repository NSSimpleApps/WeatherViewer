//
//  WeatherLayer.m
//  WeatherViewer
//
//  Created by NSSimpleApps on 07.06.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "WeatherLayer.h"

@implementation WeatherLayer

- (CLLocationCoordinate2D)coordinate {
    
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(MKMapRectWorld), MKMapRectGetMidY(MKMapRectWorld)));
}

- (MKMapRect)boundingMapRect {
    
    return MKMapRectWorld;
}

@end
