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

@interface PlacesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableSet *setOfDetours;

@end

@implementation PlacesViewController

static NSString * const kRecommendedPlaceCellIdentifier = @"recommendedPlaceCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.setOfDetours = [NSMutableSet set];
//    [self findSuggestedLocationsWithPath:self.parameters];
}

-(void)findSuggestedLocationsWithPath:(SearchParameters *)parameters{
    GMSPath *path = parameters.path;
    NSArray *arrayOfCoordinates = [SearchPointFilter filterPointsWithPath:path];
    
    NSArray *arrayOfURLs = [PlaceSearchManager constructURLWithLocations:arrayOfCoordinates andSearchParameters:parameters];
    
    __block int counter = 0;
    for (NSURL *url in arrayOfURLs) {
        [DownloadManager getPlacesJson:url completion:^(NSSet *setOfPlaces) {
            [self.setOfDetours setByAddingObjectsFromSet:setOfPlaces];
            counter++;
            if (counter >= arrayOfURLs.count) {
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.parameters.placeTypeArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecommendedPlaceCellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *arrayOfPlaceTypes = self.parameters.placeTypeArray;
    NSMutableArray *arrayOfHeaderTitles = [[NSMutableArray alloc] init];
    NSArray *arrayOfKeys = [self.parameters.placesOfInterest allKeys];
    for (NSString *key in arrayOfKeys) {
        if ([arrayOfPlaceTypes containsObject:[self.parameters.placesOfInterest valueForKey:key]]) {
            [arrayOfHeaderTitles addObject:key];
        }
    }
    
    NSArray *arrayOfSortedHeaderTitles = arrayOfHeaderTitles;
    arrayOfSortedHeaderTitles = [arrayOfSortedHeaderTitles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *headerTitle = arrayOfSortedHeaderTitles[section];
    
    return headerTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
