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
#import "CategoryContainer.h"
#import "RecommendedDataSourceManager.h"

@interface PlacesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableSet *setOfDetours;
@property (nonatomic, strong) NSArray *arrayOfRecommendations;
@property (nonatomic, strong) NSMutableArray *selectedDetours;

@end

@implementation PlacesViewController

static NSString * const kRecommendedPlaceCellIdentifier = @"recommendedPlaceCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.setOfDetours = [NSMutableSet set];
    self.selectedDetours = [NSMutableArray array];
//    [self findSuggestedLocationsWithPath:self.parameters];
}

#pragma mark - Gather Data

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
                self.arrayOfRecommendations = [RecommendedDataSourceManager createDataSourceWithDetours:self.setOfDetours andParameters:parameters];
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayOfRecommendations.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CategoryContainer *container = self.arrayOfRecommendations[section];
    return container.arrayOfRecommendations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecommendedPlaceCellIdentifier forIndexPath:indexPath];
    CategoryContainer *container = self.arrayOfRecommendations[indexPath.section];
    DetourPlace *place = container.arrayOfRecommendations[indexPath.row];
    cell.textLabel.text = place.name;
    
    if ([self.selectedDetours containsObject:place]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CategoryContainer *container = self.arrayOfRecommendations[section];
    return container.name;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryContainer *container = self.arrayOfRecommendations[indexPath.section];
    DetourPlace *place = container.arrayOfRecommendations[indexPath.row];
    if ([self.selectedDetours containsObject:place]) {
        [self.selectedDetours removeObject:place];
    } else {
        [self.selectedDetours addObject:place];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
