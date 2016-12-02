//
//  DetourPlace.m
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import "DetourPlace.h"

@implementation DetourPlace


/// Overide NSObject isEqual method to compare detour placeID instead of the objects
- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if ([other isKindOfClass:[DetourPlace class]]) {
        DetourPlace *otherPlace = other;
        return [self.placeID isEqualToString:otherPlace.placeID];
    } else {
        if (![super isEqual:other]) {
            return NO;
        } else {
            return NO;
        }
    }
}
/// Overide hash value to compare the placeID string
- (NSUInteger)hash
{
    return self.placeID.hash;
}

+ (instancetype)initWithDictionary:(NSDictionary *)objectDict {
    
    NSString *name = objectDict[@"name"];
    NSString *estType = ((NSArray *)objectDict[@"types"])[0];
    NSString *address = objectDict[@"vicinity"];
    NSString *placeID = objectDict[@"place_id"];
    NSNumber *rating = objectDict[@"rating"];
    NSString *ratingString;
    if (rating) {
        ratingString = [rating stringValue];
    } else {
        ratingString = @"N/A";
    }
    CLLocationCoordinate2D coordinate = [DetourPlace getCoordinates:objectDict[@"geometry"][@"location"]];
    
    DetourPlace *place = [[DetourPlace alloc] initWithName:name estType:estType address:address placeID:placeID rating:ratingString coordinates:coordinate];
    
    return place;
}
/// Convert NSNumber values from JSON file to CLLocationCoordinate2D
+ (CLLocationCoordinate2D)getCoordinates:(NSDictionary *)coordDict {
    NSNumber *lat = coordDict[@"lat"];
    NSNumber *lon = coordDict[@"lng"];
    double latDouble = [lat floatValue];
    double lngDouble = [lon floatValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latDouble, lngDouble);
    
    return coordinate;
}

/// Custom initializer to intialize all properties of the object from the JSON response
- (instancetype) initWithName:(NSString *)name estType:(NSString *)estType address:(NSString *)address placeID:(NSString *)placeID rating:(NSString *)rating coordinates:(CLLocationCoordinate2D)coordinate {
    if (self = [super init]) {
        _name = name;
        _establishmentType = estType;
        _address = address;
        _placeID = placeID;
        _rating = rating;
        self.coordinate = coordinate;
    }
    return self;
}

@end
