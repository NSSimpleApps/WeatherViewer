//
//  WeatherOverlayRenderer.m
//  WeatherViewer
//
//  Created by NSSimpleApps on 07.06.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "WeatherOverlayRenderer.h"

@implementation WeatherOverlayRenderer

- (CGPoint)mercatorTileOriginForMapRect:(MKMapRect)mapRect {
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    CGFloat xRadians = region.center.longitude * (M_PI/180.f);
    CGFloat yRadians = region.center.latitude * (M_PI/180.f);
    
    yRadians = log(tan(yRadians) + 1.f/cos(yRadians));
    
    xRadians = (1.f + xRadians/M_PI) / 2.f;
    yRadians = (1.f - yRadians/M_PI) / 2.f;
    
    return CGPointMake(xRadians, yRadians);
}

- (NSUInteger)zoomLevelForZoomScale:(MKZoomScale)zoomScale {
    
    CGFloat realScale = zoomScale/([[UIScreen mainScreen] scale]);
    
    return (NSUInteger)(log(realScale)/log(2.0) + 20.0);
}

- (NSUInteger)worldTileWidthForZoomLevel:(NSUInteger)zoomLevel {
    
    return (NSUInteger)pow(2, zoomLevel);
}

- (CGFloat)tileWidthForZoomLevel:(NSUInteger)zoomLevel {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    return 1.f/(pow(2, zoomLevel)*scale);
}

- (CGRect)contentsRectForImage:(UIImage *)image mercatorPoint:(CGPoint)mercatorPoint tileX:(NSInteger)tilex tileY:(NSInteger)tiley zoomLevel:(NSUInteger)zoomLevel {
    
    NSInteger scale = [[UIScreen mainScreen] scale];
    CGFloat tileWidth = [self tileWidthForZoomLevel:zoomLevel];
    CGSize imageSize = image.size;
    
    for (NSInteger x = 0; x < scale; x++) {
        for (NSInteger y = 0; y < scale; y++) {
            CGRect rect = CGRectMake(tileWidth * (tilex * scale) + tileWidth * x,
                                     tileWidth * (tiley * scale) + tileWidth * y,
                                     tileWidth,
                                     tileWidth);
            if (CGRectContainsPoint(rect, mercatorPoint)) {
                return CGRectMake((imageSize.width / scale) * x, (imageSize.height / scale) * y, imageSize.width / scale, imageSize.height / scale);
            }
        }
    }
    return CGRectZero;
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    
    return YES;
}

- (NSURL*)imageURLForTileX:(NSUInteger)tileX tileY:(NSUInteger)tileY zoomLevel:(NSUInteger)zoomLevel scale:(NSInteger)scale {
    
    u_int32_t randomDomain = arc4random_uniform(2);
    
    NSString *part1 = [NSString stringWithFormat:@"http://mt%d.google.com/mapslt?lyrs=weather_f_kph", randomDomain];
    
    NSString *part2 = @"%7Cinvert:0&";
    
    NSString *part3 = [NSString stringWithFormat:@"x=%lu&y=%lu&z=%lu&scale=%ld&w=256&h=256", (unsigned long)tileX, (unsigned long)tileY, (unsigned long)zoomLevel, (long)scale];
    
    return [NSURL URLWithString:[[part1 stringByAppendingString:part2] stringByAppendingString:part3]];
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    
    NSUInteger zoomLevel = [self zoomLevelForZoomScale:zoomScale];
    CGPoint mercatorPoint = [self mercatorTileOriginForMapRect:mapRect];
    
    NSUInteger tilex = floor(mercatorPoint.x * [self worldTileWidthForZoomLevel:zoomLevel]);
    NSUInteger tiley = floor(mercatorPoint.y * [self worldTileWidthForZoomLevel:zoomLevel]);
    NSInteger scale = [[UIScreen mainScreen] scale];
    
    NSURL *imageURL = [self imageURLForTileX:tilex tileY:tiley zoomLevel:zoomLevel scale:scale];
    
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageURL]];

    if (image) {
        
        CGRect contentsRect = [self contentsRectForImage:image mercatorPoint:mercatorPoint tileX:tilex tileY:tiley zoomLevel:zoomLevel];
        
        CGImageRef croppedImage = CGImageCreateWithImageInRect(image.CGImage, contentsRect);
        
        CGRect rect = [self rectForMapRect:mapRect];
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, 1.f/zoomScale, 1.f/zoomScale);
        CGContextTranslateCTM(context, 0.f, image.size.height/scale);
        CGContextScaleCTM(context, 1.f, -1.f);
        CGContextDrawImage(context, CGRectMake(0.f, 0.f, image.size.width/scale, image.size.height/scale), croppedImage);
    }
}

@end
