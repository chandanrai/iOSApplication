//
//  AthleteDetailViewController.m
//  CustomApp
//
//  Created by swin on 19/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import "AthleteDetailViewController.h"

@interface AthleteDetailViewController ()

@end

@implementation AthleteDetailViewController
@synthesize head;
@synthesize name;
@synthesize fname;
@synthesize dname;
- (void)setAthleteDetail:(id)newAthleteDetail
{
    
    if (_athleteDetail != newAthleteDetail) {
        _athleteDetail = newAthleteDetail;
        [self configureView];
    }
}

- (void)configureView
{
    if (self.athleteDetail) {
        self.head.text = @"Barclays Premier League";
        self.name.text = [NSString stringWithFormat:@"First Name:  %@",_athleteDetail.firstName];
        self.fname.text = [NSString stringWithFormat:@"Full Name:  %@",_athleteDetail.fullName];
        self.dname.text = [NSString stringWithFormat:@"Display Name:  %@",_athleteDetail.shortName];
    }
}

-(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (IBAction)emailShare:(id)sender {
    NSLog(@"IN SHARE");
    // Email Subject
    NSString *emailTitle = @"Athlete Details";
    // Email Content
    NSString *messageBody =  self.fname.text;
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
- (IBAction)addFavorite:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:context];
    NSLog(@"fave: %@ %@", self.athleteDetail.athleteId, self.athleteDetail.firstName);
    [favorite setValue:self.athleteDetail.athleteId forKey:@"athleteId"];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}
@end
