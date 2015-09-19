//
//  WeatherOverlay.m
//  WeatherViewer
//
//  Created by NSSimpleApps on 09.06.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "WeatherOverlay.h"

@implementation WeatherOverlay

- (CLLocationCoordinate2D)coordinate {
    
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(MKMapRectWorld), MKMapRectGetMidY(MKMapRectWorld)));
}

- (MKMapRect)boundingMapRect {
    
    return MKMapRectWorld;
}

@end
