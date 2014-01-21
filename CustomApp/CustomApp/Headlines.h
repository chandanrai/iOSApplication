//
//  Headlines.h
//  CustomApp
//
//  Created by swin on 19/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Headlines : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;

@end
