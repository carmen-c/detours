//
//  RecommendationsCell.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-12-01.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "RecommendationsCell.h"

@interface RecommendationsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation RecommendationsCell

-(void)configureCellWithObject:(DetourPlace *)place {
    self.titleLabel.text = place.name;
    self.titleLabel.textColor = [UIColor colorWithRed:225.0/255.0 green:210.0/255.0 blue:188.0/255.0 alpha:1];
    self.ratingLabel.text = place.rating;
    self.ratingLabel.textColor = [UIColor colorWithRed:225.0/255.0 green:210.0/255.0 blue:188.0/255.0 alpha:1];
}

@end
