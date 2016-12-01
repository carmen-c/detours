//
//  PlacesViewController.h
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchParameters.h"

@protocol goToMapView <NSObject>

-(void)goToMapView;

@end


@interface PlacesViewController : UIViewController

@property (nonatomic, strong) SearchParameters *parameters;
@property (nonatomic, weak) id <goToMapView> delegate;

@end

