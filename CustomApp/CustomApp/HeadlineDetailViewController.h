//
//  HeadlineDetailViewController.h
//  CustomApp
//
//  Created by swin on 19/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface HeadlineDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) id headlineDetail;
@property (strong, nonatomic) id detail;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
- (IBAction)emailShare:(id)sender;

@end
