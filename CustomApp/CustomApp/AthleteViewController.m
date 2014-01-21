//
//  AthleteViewController.m
//  CustomApp
//
//  Created by swin on 19/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import "AthleteViewController.h"
#import "AthleteDetailViewController.h"

@interface AthleteViewController ()

@end

@implementation AthleteViewController
@synthesize data = _data;
@synthesize athletes = _athletes;

-(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)callAPI
{
    NSURL *url = [NSURL URLWithString:@"http://api.espn.com/v1/sports/soccer/eng.1/athletes?apikey=rx4rtr87zb3rm8sxcukv42r4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callAPI];
    self.data = [[NSMutableData alloc] init];
    self.athletes = [[NSMutableArray alloc] init];
    [self displaySortedAthletes];
    

}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)newData
{
    [self.data appendData:newData];
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    
}

- (void)deleteExistingAthletes:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Athlete"];
    NSArray *athletes = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *managedObject in athletes) {
        [context deleteObject:managedObject];
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)saveAthlete:(NSManagedObjectContext *)context deserializedDictionary:(NSDictionary *)deserializedDictionary {
    // Create a new managed object
    NSString *firstName;
    NSString *fullName;
    NSString *shortName;
    NSString *athleteId;
    NSArray *sports = [deserializedDictionary objectForKey:@"sports"];
    NSDictionary *sport = [sports objectAtIndex:0];
    NSArray *leagues = [sport objectForKey:@"leagues"];
    NSArray *athletes = [[leagues objectAtIndex:0] objectForKey:@"athletes"];
    for (NSDictionary *temp in athletes) {
        athleteId = [NSString stringWithFormat:@"%@", [temp objectForKey:@"id"] ];
        firstName = [temp objectForKey:@"firstName"];
        fullName = [temp objectForKey:@"fullName"];
        shortName = [temp objectForKey:@"shortName"];
        NSManagedObject *newAthlete = [NSEntityDescription insertNewObjectForEntityForName:@"Athlete" inManagedObjectContext:context];
        [newAthlete setValue:firstName forKey:@"firstName"];
        [newAthlete setValue:fullName forKey:@"fullName"];
        [newAthlete setValue:shortName forKey:@"shortName"];
        [newAthlete setValue:athleteId forKey:@"athleteId"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displaySortedAthletes {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Athlete"];
    self.athletes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSMutableArray *sortedAthletes = [[NSMutableArray alloc] init];
    for (Athlete *athlete in self.athletes) {
        fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Favorite"];
        NSString *query = [NSString stringWithFormat:@"athleteId = '%@'", athlete.athleteId];
        NSLog(@"id: %@ %@", athlete.athleteId, athlete.firstName);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:query];
        [fetchRequest setPredicate:predicate];
        NSArray *results = [[[self managedObjectContext] executeFetchRequest:fetchRequest error:nil] mutableCopy];
        NSLog(@"count: %lu", (unsigned long)[results count]);
        
        if ([results count] > 0) {
            [sortedAthletes insertObject:athlete atIndex:0];
        } else {
            [sortedAthletes addObject:athlete];
        }
    }
    self.athletes = sortedAthletes;
}

- (void) connectionDidFinishLoading:(NSURLConnection*) connection {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&error];
    if(jsonObject!=nil && error == nil)
    {
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSManagedObjectContext *context = [self managedObjectContext];
            [self deleteExistingAthletes:context];
            NSDictionary *deserializedDictionary = (NSDictionary*)jsonObject;
            [self saveAthlete:context deserializedDictionary:deserializedDictionary];
        }
    }
    
    [self displaySortedAthletes];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count= [self.athletes count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Athlete *athlete;
    athlete = [self.athletes objectAtIndex:indexPath.row];
    cell.textLabel.text = athlete.firstName;
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel sizeToFit];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Athlete *athlete;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    athlete = [self.athletes objectAtIndex:indexPath.row];
    [[segue destinationViewController] setAthleteDetail:athlete];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)refresh:(id)sender {
    [self viewDidLoad];
}
@end
