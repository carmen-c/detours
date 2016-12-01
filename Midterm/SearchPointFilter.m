//
//  SearchPointFilter.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-29.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "SearchPointFilter.h"

@implementation SearchPointFilter

+(NSArray *)filterPointsWithPath:(GMSPath *)path {
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < path.count; i+=10) {
        CLLocationCoordinate2D coordinate = [path coordinateAtIndex:i];
        NSString *coordinateString = [NSString stringWithFormat:@"%@,%@", @(coordinate.latitude), @(coordinate.longitude)];
        [array addObject:coordinateString];
    }
    
    return array;
}

@end
