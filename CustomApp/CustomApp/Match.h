//
//  Match.h
//  CustomApp
//
//  Created by swin on 17/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Match : NSManagedObject

@property (nonatomic, retain) NSString * matchId;
@property (nonatomic, retain) NSString * team1;
@property (nonatomic, retain) NSString * team2;

@end
