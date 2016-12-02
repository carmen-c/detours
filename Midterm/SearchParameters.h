//
//  SearchParameters.h
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-29.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

/**
 *Model object used to hold the possible detour placetypes, placestypes the user is interested in, and the GMSPath (route from start to end locations)
 */
@interface SearchParameters : NSObject

/// A dictionary to convert between UI version and URL querieable version of a place type (e.g. Amusement Park -> amusement_park
@property (nonatomic, strong) NSDictionary *placesOfInterest;
/// An array of placetypes the user is interested in stopping at
@property (nonatomic, strong) NSMutableArray *placeTypeArray;
/// The route generated for the user by google maps given a starting and end location
@property (nonatomic, strong) GMSPath *path;

@end
