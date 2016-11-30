//
//  RecommendedDataSourceManager.h
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchParameters;

@interface RecommendedDataSourceManager : NSObject

+ (NSArray *)createDataSourceWithDetours:(NSSet *)setOfDetours andParameters:(SearchParameters *)parameters;

@end
