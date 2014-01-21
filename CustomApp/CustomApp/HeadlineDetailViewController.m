//
//  HeadlineDetailViewController.m
//  CustomApp
//
//  Created by swin on 19/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import "HeadlineDetailViewController.h"

@interface HeadlineDetailViewController ()

@end

@implementation HeadlineDetailViewController


- (void)setHeadlineDetail:(id)newHeadlineDetail
{
    
    if (_headlineDetail != newHeadlineDetail) {
        _headlineDetail = newHeadlineDetail;
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.headlineDetail) {
        self.detailDescriptionLabel.text = [self.headlineDetail description];
        NSLog(@"TEXT: %@", [self.headlineDetail description]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emailShare:(id)sender {
    NSLog(@"IN SHARE");
    // Email Subject
    NSString *emailTitle = @"Match Details";
    // Email Content
    NSString *messageBody = self.headlineDetail;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"chandanrai2@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Draft deleted"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            break;
        }
            
        case MFMailComposeResultSaved:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Email saved"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            break;
        }
            
            
        case MFMailComposeResultSent:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Email sent"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            break;
        }
        case MFMailComposeResultFailed:{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            break;
        }
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
