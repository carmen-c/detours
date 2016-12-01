//
//  MapViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "MapViewController.h"
#import "PreferencesViewController.h"
#import "PlaceSearchManager.h"
#import "DownloadManager.h"
#import "DetourPlace.h"
#import "FindRoute.h"
#import "SearchParameters.h"

@interface MapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startDestination;
@property (weak, nonatomic) IBOutlet UITextField *endDestination;
@property (weak, nonatomic) NSMutableSet *setOfDetours;

@property (weak, nonatomic) IBOutlet GMSMapView *googleMapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) GMSPath *pathToDisplay;
@property (nonatomic) FindRoute *findRoute;
@property (nonatomic) SearchParameters *parameters;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMapStyle];
    self.setOfDetours = [NSMutableSet set];
    self.findRoute = [[FindRoute alloc]init];
    self.parameters = [[SearchParameters alloc] init];
    
    self.pathToDisplay = nil;
    if (self.locationManager == nil) {
        [self createLocationManager];
    }
    
    NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
    [nCenter addObserver:self selector:@selector(redrawRouteWithWaypoints:) name:@"WayPoints" object:nil];
    
}

#pragma mark - buttons

- (IBAction)findButton:(id)sender {
    if (self.pathToDisplay !=nil) {
        [self.googleMapView clear];
    }
    
    [self getRoute];
    [self.startDestination resignFirstResponder];
    [self.endDestination resignFirstResponder];
}

- (IBAction)recommendedPlacesButton:(id)sender {
    [self performSegueWithIdentifier:@"showPlaces" sender:sender];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showPlaces"]) {
        PreferencesViewController *pref = segue.destinationViewController;
        pref.parameters = self.parameters;
    }
}

#pragma mark - Draw Route

-(void)getRoute{
    [self.findRoute findRouteWithStart:self.startDestination.text end:self.endDestination.text waypoints:nil andCompletion:^(NSMutableArray *array) {
        
        self.pathToDisplay = [array objectAtIndex:0];
        self.parameters.path = self.pathToDisplay;
        CLLocationCoordinate2D coordinate = ((CLLocation *)[array objectAtIndex:1]).coordinate;
        [self drawlineWithPath:self.pathToDisplay];
        [self focusMapToShowAllMarkers:self.pathToDisplay];
        [self setEndMarkerAt:coordinate];
    }];
    
}

-(void)redrawRouteWithWaypoints:(NSNotification *)waypoints{
    
    NSArray *arrayOfWayPoints = [waypoints.userInfo valueForKey:@"wayPoints"];
    for(int i=1; i< arrayOfWayPoints.count; i += 2){
        CLLocation * coord = [arrayOfWayPoints objectAtIndex:i];
            CLLocationCoordinate2D finalCoord = CLLocationCoordinate2DMake(coord.coordinate.latitude, coord.coordinate.longitude);
        [self setWayMarkerAt:finalCoord];
    }
    
    
    [self.findRoute findRouteWithStart:self.startDestination.text end:self.endDestination.text waypoints:arrayOfWayPoints andCompletion:^(NSMutableArray *array) {
        
        self.pathToDisplay = [array objectAtIndex:0];
        self.parameters.path = self.pathToDisplay;
        CLLocationCoordinate2D coordinate = ((CLLocation *)[array objectAtIndex:1]).coordinate;
        [self drawlineWithPath:self.pathToDisplay];
        [self focusMapToShowAllMarkers:self.pathToDisplay];
        [self setEndMarkerAt:coordinate];
    }];
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


#pragma mark - map items and format

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

-(void)drawlineWithPath:(GMSPath *)path{
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.geodesic = YES;
    polyline.strokeWidth = 5.f;
    polyline.strokeColor = [UIColor blueColor];
    polyline.map = self.googleMapView;
}

- (void)focusMapToShowAllMarkers:(GMSPath *)path{
    GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc]initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [self.googleMapView animateWithCameraUpdate:update];
}

-(void)setMapStyle{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"style" withExtension:@"json"];
    NSError *error;
    
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    self.googleMapView.mapStyle = style;
}

@end
