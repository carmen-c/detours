//
//  DownloadManager.m
//  PlacesAPITest
//
//  Created by Suvan Ramani on 2016-11-26.
//  Copyright © 2016 suvanr. All rights reserved.
//

#import "DownloadManager.h"
#import "DetourPlace.h"

@implementation DownloadManager

+(void)getPlacesJson:(NSURL *)url completion:(void (^)(NSSet *))completion {
    NSMutableSet *setOfDetours = [[NSMutableSet alloc] init];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"json error: %@", jsonError.localizedDescription);
            return;
        }
        
        NSArray *resultsArray = jsonDictionary[@"results"];
        
        for (NSDictionary *place in resultsArray) {
            DetourPlace *detourPlace = [DetourPlace initWithDictionary:place];
            [setOfDetours addObject:detourPlace];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(setOfDetours);
        }];
    }];
    [dataTask resume];
}

@end
