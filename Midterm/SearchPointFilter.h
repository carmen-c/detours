//
//  SearchPointFilter.h
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-29.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

/**
 *Class to filter route coordinates to use in constructing URLs and making network calls
 */
@interface SearchPointFilter : NSObject

/// Filter the route coordinates to coordinates >= 4900m away from one another and limit network calls
+ (NSArray *)filterPoints:(GMSPath *)path;

@end
