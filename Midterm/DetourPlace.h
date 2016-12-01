//
//  DetourPlace.h
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DetourPlace : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *establishmentType;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *placeID;

@property (nonatomic, assign) NSString *rating;

@property (nonatomic, assign) float distanceFromBaseRoute;
@property (nonatomic) CLLocationCoordinate2D coordinate;


+ (instancetype)initWithDictionary:(NSDictionary *)objectDict;

@end
