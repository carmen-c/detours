//
//  WayPointGenerator.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "WayPointGenerator.h"
#import "DetourPlace.h"

@implementation WayPointGenerator

+ (NSArray *)generateWayPointsWithDetours:(NSArray *)arrayOfDetours {
    NSMutableArray *result = [NSMutableArray array];
    
    for (DetourPlace *place in arrayOfDetours) {
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:place.coordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
        [result addObject:@"via"];
        [result addObject:location];
    }
    return result;
}

@end
