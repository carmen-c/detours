//
//  DownloadManager.h
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

+ (void)getPlacesJson:(NSURL *)url completion:(void (^)(NSSet *setOfPlaces))completion;

@end
