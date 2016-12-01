//
//  MyTripViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "MyTripViewController.h"

@interface MyTripViewController ()

@end

@implementation MyTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *nCentre = [NSNotificationCenter defaultCenter];
    [nCentre addObserver:self selector:@selector(detoursSelected) name:@"WayPoints" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)detoursSelected {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
