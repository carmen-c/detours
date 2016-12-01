//
//  RecommendationsCell.h
//  Midterm
//
//  Created by Suvan Ramani on 2016-12-01.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetourPlace.h"

@interface RecommendationsCell : UITableViewCell

- (void)configureCellWithObject:(DetourPlace *)place;

@end
