//
//  SearchParameters.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-29.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "SearchParameters.h"

@implementation SearchParameters

/// Custom init to initialize the dictionary to convert between UI and URL place types
- (instancetype)init
{
    self = [super init];
    if (self) {
        _placesOfInterest = @{@"Amusement Parks" : @"amusement_park",
                              @"Aquariums" : @"aquarium",
                              @"Art Galleries" : @"art_gallery",
                              @"Campgrounds" : @"campground",
                              @"Casinos" : @"casino",
                              @"Lodging Services" : @"lodging",
                              @"Museums" : @"museum",
                              @"Parking" : @"parking",
                              @"Malls" : @"shopping_mall",
                              @"Zoos" : @"zoo"};
    }
    return self;
}

@end
