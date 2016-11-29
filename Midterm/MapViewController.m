//
//  MapViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startDestination;
@property (weak, nonatomic) IBOutlet UITextField *endDestination;
//@property (nonatomic) OCDirectionsRequest *directionRequest;

@property (weak, nonatomic) IBOutlet GMSMapView *googleMapView;
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createLocationManager];
}

#pragma mark - buttons

- (IBAction)findButton:(id)sender {
   // self.directionRequest = [[OCDirectionsRequest alloc]init];
    [self findRoute];
    
    [self.startDestination resignFirstResponder];
    [self.endDestination resignFirstResponder];
}

#pragma mark - route

-(void)findRoute{
    OCDirectionsRequest *request = [OCDirectionsRequest requestWithOriginString:self.startDestination.text andDestinationString:self.endDestination.text];
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
                GMSPath *path = [GMSPath pathFromEncodedPath:encodedPath];
                GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
                
                polyline.map = self.googleMapView;
                polyline.geodesic = YES;
                polyline.strokeWidth = 5.f;
                NSMutableArray *arrayOfCoordinates = [NSMutableArray array];
                for (int i=0; i < path.count; i++) {
                    CLLocationCoordinate2D coordinate = [path coordinateAtIndex:i];
                    NSString *coordinateString = [NSString stringWithFormat:@"%ld,%ld", (long)coordinate.latitude, (long)coordinate.longitude];
                    [arrayOfCoordinates addObject:coordinateString];
                }
                
            });
        }
        
    }];
}
                           

//+ (void)polylineWithEncodedString:(NSString *)encodedString {
//    const char *bytes = [encodedString UTF8String];
//    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger idx = 0;
//    
//    NSUInteger count = length / 4;
//    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
//    NSUInteger coordIdx = 0;
//    
//    float latitude = 0;
//    float longitude = 0;
//    while (idx < length) {
//        char byte = 0;
//        int res = 0;
//        char shift = 0;
//        
//        do {
//            byte = bytes[idx++] - 63;
//            res |= (byte & 0x1F) << shift;
//            shift += 5;
//        } while (byte >= 0x20);
//        
//        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
//        latitude += deltaLat;
//        
//        shift = 0;
//        res = 0;
//        
//        do {
//            byte = bytes[idx++] - 0x3F;
//            res |= (byte & 0x1F) << shift;
//            shift += 5;
//        } while (byte >= 0x20);
//        
//        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
//        longitude += deltaLon;
//        
//        float finalLat = latitude * 1E-5;
//        float finalLon = longitude * 1E-5;
//        
//        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
//        coords[coordIdx++] = coord;
//        
//        if (coordIdx == count) {
//            NSUInteger newCount = count + 10;
//            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
//            count = newCount;
//        }
//    }
//    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = *(coords);
//    marker.snippet = @" ";
//    marker.map = self.googleMapView;
//
//}


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
