//
//  DetailViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "DetailViewController.h"
#import "DetourPlace.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detourNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *establishmentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distancelabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (nonatomic) DetourPlace *detour;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

-(void)configureView{
    self.detourNameLabel.text = self.detour.name;
    self.establishmentTypeLabel.text = self.detour.establishmentType;
    self.addressLabel.text = self.detour.address;
    self.distancelabel.text = [NSString stringWithFormat:@"%.2f", self.detour.distanceFromBaseRoute];
    self.ratingLabel.text = [NSString stringWithFormat:@"%@", self.detour.rating];
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
