//
//  PlaceSearchManager.h
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceSearchManager : NSObject

+ (NSArray *)constructURLWithLocations:(NSArray *)arrayOfLocations;
+ (NSURL *)constructURL2;

@end
