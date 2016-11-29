//
//  DetourPlace.m
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import "DetourPlace.h"

@implementation DetourPlace

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        if ([other isKindOfClass:[DetourPlace class]]) {
            DetourPlace *otherPlace = other;
            return [self.placeID isEqualToString:otherPlace.placeID];
        } else {
            return NO;
        }
    }
}

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
    
    CLLocationCoordinate2D coordinate = [DetourPlace getCoordinates:objectDict[@"geometry"][@"location"]];
    
    DetourPlace *place = [[DetourPlace alloc] initWithName:name estType:estType address:address placeID:placeID rating:rating coordinates:coordinate];
    
    return place;
}

+ (CLLocationCoordinate2D)getCoordinates:(NSDictionary *)coordDict {
    NSNumber *lat = coordDict[@"lat"];
    NSNumber *lon = coordDict[@"lng"];
    double latDouble = [lat floatValue];
    double lngDouble = [lon floatValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latDouble, lngDouble);
    
    return coordinate;
}


- (instancetype) initWithName:(NSString *)name estType:(NSString *)estType address:(NSString *)address placeID:(NSString *)placeID rating:(NSNumber *)rating coordinates:(CLLocationCoordinate2D)coordinate {
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
