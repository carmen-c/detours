//
//  CategoryContainer.h
//  Midterm
//
//  Created by Suvan Ramani on 2016-11-30.
//  Copyright © 2016 carmen cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * A model object used to store an array of detour objects of a particular place type
 */
@interface CategoryContainer : NSObject

/// A string with the UI Version of a placetype (e.g. Art Galleries) of all the objects in the arrayOfRecommenations property of this object
@property (nonatomic, strong) NSString *name;
/// An array containing DetourPlace objects
@property (nonatomic, strong) NSMutableArray *arrayOfRecommendations;

-(instancetype)initWithName:(NSString *)name;

@end
