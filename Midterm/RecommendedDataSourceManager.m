//
//  RecommendedDataSourceManager.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "RecommendedDataSourceManager.h"
#import "CategoryContainer.h"
#import "DetourPlace.h"
#import "SearchParameters.h"

@implementation RecommendedDataSourceManager

+ (NSArray *)createDataSourceWithDetours:(NSSet *)setOfDetours andParameters:(SearchParameters *)parameters {
    NSArray *result = [RecommendedDataSourceManager createCategoryContainers:parameters];
    NSArray *arrayOfDetours = [setOfDetours allObjects];
    
    for (CategoryContainer *container in result) {
        NSString *placeType = [parameters.placesOfInterest objectForKey:container.name];
        for (DetourPlace *place in arrayOfDetours) {
            if ([place.establishmentType isEqualToString:placeType]) {
                [container.arrayOfRecommendations addObject:place];
            }
        }
    }
    return result;
}

+ (NSArray *)createCategoryContainers:(SearchParameters *)parameters
{
    NSArray *arrayOfPlaceTypes = parameters.placeTypeArray;
    NSMutableArray *arrayOfCategories = [NSMutableArray array];
    NSArray *arrayOfKeys = [parameters.placesOfInterest allKeys];
    for (NSString *key in arrayOfKeys) {
        if ([arrayOfPlaceTypes containsObject:[parameters.placesOfInterest valueForKey:key]]) {
            CategoryContainer *container = [[CategoryContainer alloc] initWithName:key];
            [arrayOfCategories addObject:container];
        }
    }
    
    NSArray *result = arrayOfCategories;
    NSArray *sortArray = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:nil]];
    result = [result sortedArrayUsingDescriptors:sortArray];
    
    return result;
}

@end
