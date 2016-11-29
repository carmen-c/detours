//
//  PlacesViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlaceSearchManager.h"
#import "DownloadManager.h"

@interface PlacesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableSet *setOfDetours;

@end

@implementation PlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.setOfDetours = [NSMutableSet set];
}


-(void)findSuggestedLocationsWithPath:(GMSPath *)path{
    NSMutableArray *arrayOfCoordinates = [NSMutableArray array];
    for (int i=0; i < path.count; i++) {
        CLLocationCoordinate2D coordinate = [path coordinateAtIndex:i];
        NSString *coordinateString = [NSString stringWithFormat:@"%@,%@", @(coordinate.latitude), @(coordinate.longitude)];
        [arrayOfCoordinates addObject:coordinateString];
    }
    
    NSArray *arrayOfURLs = [PlaceSearchManager constructURLWithLocations:arrayOfCoordinates];
    NSMutableArray *URLsToFetch = [NSMutableArray array];
    for (int i = 0; i < arrayOfURLs.count; i += 10) {
        [URLsToFetch addObject:arrayOfURLs[i]];
    }
    
    __block int counter = 0;
    for (NSURL *url in URLsToFetch) {
        [DownloadManager getPlacesJson:url completion:^(NSSet *setOfPlaces) {
            [self.setOfDetours setByAddingObjectsFromSet:setOfPlaces];
            
            counter++;
            if (counter >= URLsToFetch.count) {
                // Completed fetch
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
