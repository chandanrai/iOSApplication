//
//  MatchDetailViewController.h
//  CustomApp
//
//  Created by Chandan Rai on 12/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface MatchDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) id matchDetail;
@property (strong, nonatomic) id detail;
@property (retain) NSMutableData *data1;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)share:(id)sender;
- (IBAction)refresh:(id)sender;

@end
