//
//  MapViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "MapViewController.h"
#import "PlaceSearchManager.h"
#import "DownloadManager.h"
#import "DetourPlace.h"

@interface MapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startDestination;
@property (weak, nonatomic) IBOutlet UITextField *endDestination;
@property (weak, nonatomic) NSMutableSet *setOfDetours;

@property (weak, nonatomic) IBOutlet GMSMapView *googleMapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) GMSPath *pathToDisplay;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.setOfDetours = [NSMutableSet set];
    self.pathToDisplay = nil;
    
    if (self.locationManager == nil) {
        [self createLocationManager];
    }
}

#pragma mark - buttons

- (IBAction)findButton:(id)sender {
    if (self.pathToDisplay !=nil) {
        [self.googleMapView clear];
        
        [self findRoute];
    }else if (self.pathToDisplay == nil){
        [self findRoute];
    }
//    }else {
//        [self drawlineWithPath:self.pathToDisplay];
//    }
    
    [self.startDestination resignFirstResponder];
    [self.endDestination resignFirstResponder];
}

#pragma mark - route

-(void)findRoute{
    CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:37.7422688 longitude:-122.4263441];
    NSArray *waypointsArray = @[@"via:", secondLocation];
    [self setWayMarkerAt:CLLocationCoordinate2DMake(secondLocation.coordinate.latitude, secondLocation.coordinate.longitude)];
    
    OCDirectionsRequest *request = [OCDirectionsRequest requestWithOriginString:self.startDestination.text andDestinationString:self.endDestination.text];
    request.waypointsOptimise = YES;
    request.waypoints = waypointsArray;
    
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
                [self drawlineWithPath:path];
                self.pathToDisplay = path;
                
                CLLocationCoordinate2D endDestination = CLLocationCoordinate2DMake(cEndLat, cEndLng);
                [self setEndMarkerAt:endDestination];
                [self focusMapToShowAllMarkers:path];
            });
        }
        
    }];
}

#pragma mark - find suggested locations



#pragma mark - line

-(void)drawlineWithPath:(GMSPath *)path{
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.geodesic = YES;
    polyline.strokeWidth = 5.f;
    polyline.strokeColor = [UIColor blueColor];
    polyline.map = self.googleMapView;
}

#pragma mark - find current location

-(void)createLocationManager{
    if (self.locationManager == nil){
    self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *current = [locations firstObject];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current.coordinate.latitude
                                                            longitude:current.coordinate.longitude
                                                                 zoom:17.0];
    [self.googleMapView animateToCameraPosition:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(current.coordinate.latitude, current.coordinate.longitude);
    marker.snippet = @"Your Current Location";
    marker.map = self.googleMapView;
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:marker.position completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        
    GMSAddress* addressObj = [response firstResult];
    NSString *currentLocation = [NSString stringWithFormat:@"%@, %@, %@, %@, %@", addressObj.thoroughfare, addressObj.locality, addressObj.administrativeArea, addressObj.country, addressObj.postalCode];
    
    self.startDestination.text = currentLocation;
    }];
    
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - marker

-(void) setEndMarkerAt:(CLLocationCoordinate2D)location {
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = location;
    marker.snippet = @"Destination";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = self.googleMapView;
}

-(void) setWayMarkerAt:(CLLocationCoordinate2D)location {
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = location;
    marker.snippet = @"WAYPOINT";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    marker.map = self.googleMapView;
}


#pragma mark - zoom

- (void)focusMapToShowAllMarkers:(GMSPath *)path{
    GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc]initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [self.googleMapView animateWithCameraUpdate:update];
}

@end
