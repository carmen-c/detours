//
//  RecommendedDataSourceManager.h
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * A class to reconfigure detourplace data into a format suited to a display in a tableview
 */
@class SearchParameters;

@interface RecommendedDataSourceManager : NSObject

/// Takes in a set of detours and returns an array of CategoryContainers used to display detours in the PlacesViewController
+ (NSArray *)createDataSourceWithDetours:(NSSet *)setOfDetours andParameters:(SearchParameters *)parameters;

@end
