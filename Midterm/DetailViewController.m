//
//  DetailViewController.m
//  Midterm
//
//  Created by carmen cheng on 2016-11-26.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "DetailViewController.h"
#import "DetourPlace.h"
#import "SearchParameters.h"
#import <GooglePlaces/GooglePlaces.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detourNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *establishmentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distancelabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detourImageView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

#pragma mark - text

-(void)configureView{
    self.detourNameLabel.text = self.detour.name;
    self.establishmentTypeLabel.text = [self cleanUpEstType];
    self.addressLabel.text = self.detour.address;
    self.distancelabel.text = [NSString stringWithFormat:@"distance: %.2f", self.detour.distanceFromBaseRoute];
    if (self.detour.rating == nil) {
        self.ratingLabel.text = @"rating: N/A";
    } else {
        self.ratingLabel.text = [NSString stringWithFormat:@"rating: %@", self.detour.rating];
    }
    
    [self loadFirstPhotoForPlace:self.detour.placeID];
}

- (IBAction)backButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - photo

- (void)loadFirstPhotoForPlace:(NSString *)placeID {
    [[GMSPlacesClient sharedClient]
     lookUpPhotosForPlaceID:placeID
     callback:^(GMSPlacePhotoMetadataList *_Nullable photos,
                NSError *_Nullable error) {
         if (error) {
             // TODO: handle the error.
             NSLog(@"Error: %@", [error description]);
         } else {
             if (photos.results.count > 0) {
                 GMSPlacePhotoMetadata *firstPhoto = photos.results.firstObject;
                 [self loadImageForMetadata:firstPhoto];
             }
         }
     }];
}

- (void)loadImageForMetadata:(GMSPlacePhotoMetadata *)photoMetadata {
    [[GMSPlacesClient sharedClient]
     loadPlacePhoto:photoMetadata
     constrainedToSize:self.detourImageView.bounds.size
     scale:self.detourImageView.window.screen.scale
     callback:^(UIImage *_Nullable photo, NSError *_Nullable error) {
         if (error) {
             // TODO: handle the error.
             NSLog(@"Error: %@", [error description]);
         } else {
             self.detourImageView.image = photo;
             self.detourImageView.contentMode = UIViewContentModeScaleAspectFit;
             [self.view setNeedsDisplay];
         }
     }];
}

-(NSString *)cleanUpEstType {
    NSString *result;
    SearchParameters *parameters = [[SearchParameters alloc] init];
    for (NSString *key in parameters.placesOfInterest) {
        if ([[parameters.placesOfInterest objectForKey:key] isEqualToString:self.detour.establishmentType]) {
            result = key;
        }
    }
    return result;
}


@end
