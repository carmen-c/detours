//
//  CategoryContainer.h
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryContainer : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *arrayOfRecommendations;

-(instancetype)initWithName:(NSString *)name;

@end
