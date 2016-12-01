//
//  CategoryContainer.m
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import "CategoryContainer.h"

@implementation CategoryContainer

-(instancetype)initWithName:(NSString *)name {
    if (self=[super init]) {
        _name = name;
        _arrayOfRecommendations = [NSMutableArray array];
    }
    return self;
}

@end
