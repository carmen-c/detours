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
#import "WayPointGenerator.h"
#import "TripDetours.h"
#import "RecommendationsCell.h"

@interface PlacesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSSet *setOfDetours;
@property (nonatomic, strong) NSArray *arrayOfRecommendations;
@property (nonatomic, strong) NSMutableArray *selectedDetours;

@end

@implementation PlacesViewController

static NSString * const kRecommendedPlaceCellIdentifier = @"recommendedPlaceCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.setOfDetours = [NSSet set];
    self.selectedDetours = [NSMutableArray array];
    [self findSuggestedLocationsWithPath:self.parameters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gather Data

-(void)findSuggestedLocationsWithPath:(SearchParameters *)parameters{
    GMSPath *path = parameters.path;
    NSArray *arrayOfCoordinates = [SearchPointFilter filterPoints:path];
    
    NSArray *arrayOfURLs = [PlaceSearchManager constructURLWithLocations:arrayOfCoordinates andSearchParameters:parameters];
    
    __block int counter = 0;
    for (NSURL *url in arrayOfURLs) {
        [DownloadManager getPlacesJson:url completion:^(NSSet *setOfPlaces) {
            self.setOfDetours = [self.setOfDetours setByAddingObjectsFromSet:setOfPlaces];
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
    RecommendationsCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecommendedPlaceCellIdentifier forIndexPath:indexPath];
    if (self.arrayOfRecommendations.count > 0) {
        CategoryContainer *container = self.arrayOfRecommendations[indexPath.section];
        DetourPlace *place = container.arrayOfRecommendations[indexPath.row];
        [cell configureCellWithObject:place];
        
        if ([self.selectedDetours containsObject:place]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView*)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:225.0/255.0 green:210.0/255.0 blue:188.0/255.0 alpha:1]];
}

# pragma mark - Buttons
- (IBAction)saveButton:(UIButton *)sender {
    NSArray *arrayOfWayPoints = [WayPointGenerator generateWayPointsWithDetours:self.selectedDetours];
    NSNotificationCenter *nCentre = [NSNotificationCenter defaultCenter];
    NSDictionary *waypointDict = @{@"wayPoints" : arrayOfWayPoints};
    NSNotification *notification = [[NSNotification alloc] initWithName:@"WayPoints" object:nil userInfo:waypointDict];
    [nCentre postNotification:notification];
    TripDetours *tripDetours = [TripDetours sharedManager];
    tripDetours.arrayOfDetours = self.selectedDetours;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate goToMapView];
    
}


@end
