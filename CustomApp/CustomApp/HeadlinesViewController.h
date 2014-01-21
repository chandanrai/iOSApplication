//
//  HeadlinesViewController.h
//  CustomApp
//
//  Created by swin on 19/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Headlines.h"

@interface HeadlinesViewController : UITableViewController
@property (retain) NSMutableData *data;
- (IBAction)refresh:(id)sender;
@property (retain) NSMutableArray *headlines;
@end
