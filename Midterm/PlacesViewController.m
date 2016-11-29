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
#import "DetourPlace.h"
#import "SearchPointFilter.h"

@interface PlacesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableSet *setOfDetours;

@end

@implementation PlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.setOfDetours = [NSMutableSet set];
//    [self findSuggestedLocationsWithPath:self.parameters];
}


-(void)findSuggestedLocationsWithPath:(SearchParameters *)parameters{
    NSArray *arrayOfCoordinates = [self getSearchPointCoordinates:parameters];
    
    NSArray *arrayOfURLs = [PlaceSearchManager constructURLWithLocations:arrayOfCoordinates andSearchParameters:parameters];
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

- (NSArray *)getSearchPointCoordinates:(SearchParameters *)parameters {
    NSMutableArray *array = [NSMutableArray array];
    GMSPath *path = parameters.path;
    
    NSArray *filteredPoints = [SearchPointFilter filterPointsWithPath:path];
    
    for (int i=0; i < filteredPoints.count; i++) {
        CLLocationCoordinate2D coordinate = [path coordinateAtIndex:i];
        NSString *coordinateString = [NSString stringWithFormat:@"%@,%@", @(coordinate.latitude), @(coordinate.longitude)];
        [array addObject:coordinateString];
    }
    
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
