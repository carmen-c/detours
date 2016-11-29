//
//  PlaceSearchManager.m
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import "PlaceSearchManager.h"
#import "Constants.h"
#import <MapKit/MapKit.h>
#import "Constants.h"

@interface PlaceSearchManager ()

@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

@end

@implementation PlaceSearchManager

+(NSArray *)constructURLWithLocations:(NSArray *)arrayOfLocations {
    NSMutableArray<NSURL *> *arrayOfURLs = [NSMutableArray array];
    
    for (NSString *coordinateString in arrayOfLocations) {
        NSURL *url = [PlaceSearchManager constructURLWithCoordinate:coordinateString];
        [arrayOfURLs addObject:url];
    }
    
    return arrayOfURLs;
}

+ (NSURL *)constructURLWithCoordinate:(NSString *)coordinateString {
    
    NSMutableArray *queries = [NSMutableArray array];
    NSDictionary *queryDict = @{@"location" : coordinateString, @"radius" : @"1000", @"type" : @"art_gallery", @"key" : kSuvanAPIKey};
    
    for (NSString *key in queryDict) {
        [queries addObject:[NSURLQueryItem queryItemWithName:key value:queryDict[key]]];
    }
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"maps.googleapis.com";
    components.path = @"/maps/api/place/nearbysearch/json";
    components.queryItems = queries;
    
    NSLog(@"%@", components.URL);
    
    return components.URL;
}

+ (NSURL *)constructURL2 {
    
    NSMutableArray *queries = [NSMutableArray array];
    NSDictionary *queryDict = @{@"location" : @"49.282471,-123.106998", @"radius" : @"1000", @"type" : @"art_gallery", @"key" : kSuvanAPIKey};
    
    for (NSString *key in queryDict) {
        [queries addObject:[NSURLQueryItem queryItemWithName:key value:queryDict[key]]];
    }
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"https";
    components.host = @"maps.googleapis.com";
    components.path = @"/maps/api/place/nearbysearch/json";
    components.queryItems = queries;
    
    NSLog(@"%@", components.URL);
    
    return components.URL;
}

@end
