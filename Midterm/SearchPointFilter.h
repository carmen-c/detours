//
//  SearchPointFilter.h
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-29.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SearchPointFilter : NSObject

+ (NSArray *)filterPointsWithPath:(GMSPath *)path;
+ (NSArray *)filterPoints:(GMSPath *)path;

@end
