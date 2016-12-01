//
//  FindRoute.h
//  Midterm
//
//  Created by carmen cheng on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface FindRoute : NSObject

@property (nonatomic) GMSPath *initialPath;
-(void)findRouteWithStart:(NSString *)start end:(NSString *)end waypoints:(NSArray *)waypoints andCompletion:(void (^)(NSMutableArray *array))completion;

@end
