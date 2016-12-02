//
//  DetourPlace.h
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 * This object stores the information for each "detour" found from the GooglePlacesAPI JSON response
 */
@interface DetourPlace : NSObject <MKAnnotation>

/// The name of the establishment
@property (nonatomic, strong) NSString *name;
/// The establishment type (e.g. restaurant, museum, art gallery, etc.)
@property (nonatomic, strong) NSString *establishmentType;
/// The address
@property (nonatomic, strong) NSString *address;
/// A unique place ID used to download the place's image and compare objects to prevent duplication
@property (nonatomic, strong) NSString *placeID;
/// Rating according to google
@property (nonatomic, assign) NSString *rating;
/// The geographical coordinates of the establiment used to generate way points
@property (nonatomic) CLLocationCoordinate2D coordinate;

/// Initialize an object with a dictionary from the JSON file
+ (instancetype)initWithDictionary:(NSDictionary *)objectDict;

@end
