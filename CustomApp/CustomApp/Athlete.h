//
//  Athlete.h
//  CustomApp
//
//  Created by swin on 24/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Athlete : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * athleteId;

@end
