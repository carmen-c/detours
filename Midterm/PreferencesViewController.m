//
//  PreferencesViewController.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-29.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *placesOfInterest;
@property (nonatomic, strong) NSMutableArray *selectedPlaces;
@end

@implementation PreferencesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (IBAction)findButton:(UIButton *)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
