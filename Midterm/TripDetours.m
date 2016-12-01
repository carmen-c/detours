//
//  TripDetours.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "TripDetours.h"

@implementation TripDetours

+ (id)sharedManager {
    static TripDetours *sharedTripDetours = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTripDetours = [[self alloc] init];
    });
    return sharedTripDetours;
}

@end
