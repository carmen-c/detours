//
//  PlaceSearchManager.h
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchParameters.h"
/**
 *Construct URLs for GooglePlacesAPI search given an array of coordinates and SearchParameters
 */
@interface PlaceSearchManager : NSObject
/// Return an array of NSURLs given CLLocationCoordinates2D and SearchParameters
+ (NSArray *)constructURLWithLocations:(NSArray *)arrayOfLocations andSearchParameters:(SearchParameters *)parameters;

@end
