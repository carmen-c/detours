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
                [self configureTableViewDataSource];
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.setOfDetours.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecommendedPlaceCellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureTableViewDataSource {
    
}

@end
