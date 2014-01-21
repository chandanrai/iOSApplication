//
//  AthleteDetailViewController.h
//  CustomApp
//
//  Created by swin on 19/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import <MessageUI/MessageUI.h> 

@interface AthleteDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>
- (IBAction)emailShare:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *fname;
@property (weak, nonatomic) IBOutlet UILabel *dname;

@property (weak, nonatomic) IBOutlet UILabel *head;
@property (strong, nonatomic) Athlete *athleteDetail;
@property (strong, nonatomic) id detail;
- (IBAction)addFavorite:(id)sender;

@end
