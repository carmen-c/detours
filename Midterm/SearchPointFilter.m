//
//  SearchPointFilter.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-29.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "SearchPointFilter.h"

@implementation SearchPointFilter

/// Filter the route coordinates to coordinates >= 4900m away from one another and limit network calls
+(NSArray *)filterPoints:(GMSPath *)path
{
    NSMutableArray *result = [NSMutableArray array];
    CLLocationDistance minDistance = 4900;
    CLLocationCoordinate2D lastCoord = [path coordinateAtIndex:0];
    CLLocation *lastLocation = [[CLLocation alloc] initWithCoordinate:lastCoord altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
    
    for (int i = 1; i < path.count; i++) {
        
        CLLocationCoordinate2D coordToBeChecked = [path coordinateAtIndex:i];
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordToBeChecked altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
        CLLocationDistance distanceToLastLogged = [lastLocation distanceFromLocation:location];
        
        if (distanceToLastLogged >= minDistance) {
            NSString *coordinateString = [SearchPointFilter createCoordinateString:coordToBeChecked];
            [result addObject:coordinateString];
            lastLocation = location;
        }
    }
    return result;
}

/// Converts CLLocationCoordinate to a coordinate string to be used to construct a URL
+ (NSString *)createCoordinateString:(CLLocationCoordinate2D)coordinate
{
    NSString *result = [NSString stringWithFormat:@"%@,%@", @(coordinate.latitude), @(coordinate.longitude)];
    return result;
}


@end
