//
//  DownloadManager.h
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *Handle downloading the JSON from GooglePlacesAPI given a specific URL and SearchParameters
 */
@interface DownloadManager : NSObject

/// Download the JSON file and add all potential detour locations to a set of detours
+ (void)getPlacesJson:(NSURL *)url completion:(void (^)(NSSet *setOfPlaces))completion;

@end
