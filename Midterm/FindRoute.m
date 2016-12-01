//
//  FindRoute.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "FindRoute.h"
#import "WayPointGenerator.h"
#import <OCGoogleDirectionsAPI/OCGoogleDirectionsAPI.h>

@implementation FindRoute

#pragma mark - find route

-(void)findRouteWithStart:(NSString *)start end:(NSString *)end waypoints:(NSArray *)waypoints andCompletion:(void (^)(NSMutableArray *array))completion {
    
    OCDirectionsRequest *request = [OCDirectionsRequest requestWithOriginString:start andDestinationString:end];
    request.waypointsOptimise = YES;
     request.waypoints = waypoints;
    
    OCDirectionsAPIClient *client = [OCDirectionsAPIClient new];
    [client directions:request response:^(OCDirectionsResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"error: %@, %@", error, error.localizedDescription);
            return;
        }
        
        if (response.status != OCDirectionsResponseStatusOK) {
            NSLog(@"%lu", (unsigned long)response.status);
            return;
        }
        
        if ([response.routes count] > 0)
        {
            NSArray<NSDictionary *> *routes = response.dictionary[@"routes"];
            NSDictionary * route = routes.firstObject;
            NSString * encodedPath = route[@"overview_polyline"][@"points"];
            
            NSArray<NSDictionary *> *legs = route[@"legs"];
            NSDictionary *leg = legs.lastObject;
            NSDictionary *deeeper = [leg valueForKey:@"end_location"];
            NSString *endLocationLat = [deeeper valueForKey:@"lat"];
            NSString *endLocationLng = [deeeper valueForKey:@"lng"];
            
            double cEndLat = [endLocationLat doubleValue];
            double cEndLng = [endLocationLng doubleValue];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                GMSPath *path = [GMSPath pathFromEncodedPath:encodedPath];
//                self.initialPath = path;
                CLLocationCoordinate2D endDestination = CLLocationCoordinate2DMake(cEndLat, cEndLng);
                CLLocation *endlocation = [[CLLocation alloc]initWithCoordinate:endDestination altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
                
                NSMutableArray *array = [[NSMutableArray alloc]init];
                [array addObject:path];
                [array addObject:endlocation];
                completion(array);
            });
        }
        
    }];
}


@end
