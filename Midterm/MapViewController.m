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
    [self createLocationManager];
    self.pathToDisplay = nil;
}

#pragma mark - buttons

- (IBAction)findButton:(id)sender {
    if (self.pathToDisplay == nil) {
        [self findRoute];
    }else {
        [self drawlineWithPath:self.pathToDisplay];
    }
    
    [self.startDestination resignFirstResponder];
    [self.endDestination resignFirstResponder];
}

#pragma mark - route

-(void)findRoute{
    CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:37.7422688 longitude:-122.4263441];
    
    NSArray *waypointsArray = @[@"via:", secondLocation];
    
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                GMSMutablePath *path = [GMSMutablePath pathFromEncodedPath:encodedPath];
                [self drawlineWithPath:path];
                self.pathToDisplay = path;
            });
        }
        
    }];
}

#pragma mark - find suggested locations



#pragma mark - draw line

-(void)drawlineWithPath:(GMSPath *)path{
//    GMSMutablePath *path = [GMSMutablePath path];
//    [path addLatitude:-33.866 longitude:151.195]; // Sydney
//    [path addLatitude:-18.142 longitude:178.431]; // Fiji
//    [path addLatitude:21.291 longitude:-157.821]; // Hawaii
//    [path addLatitude:37.423 longitude:-122.091]; // Mountain View
//    
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
//
//-(void) setMarkerAt:(CLLocation *)location {
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(current.coordinate.latitude, current.coordinate.longitude);
//    marker.snippet = @"Your Current Location";
//    marker.map = self.googleMapView;
//}


@end
