//
//  MyTripViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "MyTripViewController.h"
#import "DetourPlace.h"
#import "TripDetours.h"

@interface MyTripViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfDetours;

@end

@implementation MyTripViewController

static NSString * const kMyTripCellReuseIdentifier = @"myTripCell";

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

@end
