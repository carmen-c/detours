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
    
    return arrayOfCategories;
}



/*
 NSArray *arrayOfPlaceTypes = self.parameters.placeTypeArray;
 NSMutableArray *arrayOfHeaderTitles = [[NSMutableArray alloc] init];
 NSArray *arrayOfKeys = [self.parameters.placesOfInterest allKeys];
 for (NSString *key in arrayOfKeys) {
 if ([arrayOfPlaceTypes containsObject:[self.parameters.placesOfInterest valueForKey:key]]) {
 [arrayOfHeaderTitles addObject:key];
 }
 }
 
 NSArray *arrayOfSortedHeaderTitles = arrayOfHeaderTitles;
 arrayOfSortedHeaderTitles = [arrayOfSortedHeaderTitles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
 NSString *headerTitle = arrayOfSortedHeaderTitles[section];
 */

@end
