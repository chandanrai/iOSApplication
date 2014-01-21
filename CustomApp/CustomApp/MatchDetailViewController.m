//
//  MatchDetailViewController.m
//  CustomApp
//
//  Created by Chandan Rai on 12/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import "MatchDetailViewController.h"

@interface MatchDetailViewController ()
- (void)configureView;
@end

@implementation MatchDetailViewController
@synthesize activityIndicator;

- (void)setMatchDetail:(id)newMatchDetail
{
        _matchDetail = newMatchDetail;
        NSString *URLString = [NSString stringWithFormat:@"http://cricscore-api.appspot.com/csa?id=%@",[self.matchDetail description]];
        NSURL *url = [NSURL URLWithString:URLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection connectionWithRequest:request delegate:self];
        [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.matchDetail) {
        self.detailDescriptionLabel.text = [self.matchDetail description];
        
    }
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)newData
{
    [self.data1 appendData:newData];
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    
}
- (void) connectionDidFinishLoading:(NSURLConnection*) connection {
    NSError *error = nil;
    [self.activityIndicator stopAnimating];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.data1 options:NSJSONReadingAllowFragments error:&error];
    if(jsonObject!=nil && error == nil)
        NSLog(@"match details =%@", jsonObject);
        if ([jsonObject isKindOfClass:[NSArray class]])
        {
            NSLog(@"IN LooP");
            NSArray *deserializedArray = (NSArray*)jsonObject;
            for (NSDictionary *temp in deserializedArray) {
                self.matchDetail = [temp objectForKey:@"de" ];
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data1 = [[NSMutableData alloc] init];
    [self.activityIndicator startAnimating];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender {
    NSLog(@"IN SHARE");
    // Email Subject
    NSString *emailTitle = @"Match Details";
    // Email Content
    NSString *messageBody = self.matchDetail;
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

- (IBAction)refresh:(id)sender {
    [self setMatchDetail:self.matchDetail];
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
