//
//  MyTripViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "MyTripViewController.h"
#import "DetailViewController.h"
#import "DetourPlace.h"
#import "TripDetours.h"

@interface MyTripViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfDetours;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation MyTripViewController

static NSString * const kMyTripCellReuseIdentifier = @"myTripCell";
static NSString * const kShowDetailVCSegueIdentifier = @"showDetail";

- (void)viewDidLoad {
    [super viewDidLoad];
    TripDetours *tripDetours = [TripDetours sharedManager];
    self.arrayOfDetours = tripDetours.arrayOfDetours;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDetours.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyTripCellReuseIdentifier forIndexPath:indexPath];
    
    DetourPlace *place = self.arrayOfDetours[indexPath.row];
    cell.textLabel.text = place.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:kShowDetailVCSegueIdentifier sender:self];
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowDetailVCSegueIdentifier]) {
        DetailViewController *detailVC = segue.destinationViewController;
        DetourPlace *place = self.arrayOfDetours[self.selectedIndexPath.row];
        detailVC.detour = place;
    }
}

@end
