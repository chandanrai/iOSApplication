//
//  LiveMatchViewController.h
//  CustomApp
//
//  Created by Chandan Rai on 12/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveMatchViewController : UITableViewController
@property (retain) NSMutableData *data;
- (IBAction)refresh:(id)sender;
@property (retain) NSMutableArray *matches;
@end
