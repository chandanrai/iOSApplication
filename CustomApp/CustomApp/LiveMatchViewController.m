//
//  LiveMatchViewController.m
//  CustomApp
//
//  Created by Chandan Rai on 12/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import "LiveMatchViewController.h"
#import "Match.h"
#import "MatchDetailViewController.h"


@interface LiveMatchViewController ()
@end

@implementation LiveMatchViewController
@synthesize data = _data;
@synthesize matches = _matches;

-(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)callAPI
{
    NSURL *url = [NSURL URLWithString:@"http://cricscore-api.appspot.com/csa"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callAPI];
    self.data = [[NSMutableData alloc] init];
    self.matches = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Match"];
    self.matches = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)newData
{
    [self.data appendData:newData];
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    
}

- (void)deleteExistingMatches:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Match"];
    NSArray *matches = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *managedObject in matches) {
        [context deleteObject:managedObject];
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)saveMatch:(NSManagedObjectContext *)context deserializedArray:(NSArray *)deserializedArray {
    // Create a new managed object
    NSString *t1;
    NSString *t2;
    NSString *Id;
    for (NSDictionary *temp in deserializedArray) {
        t1 = [temp objectForKey:@"t1" ];
        t2 = [temp objectForKey:@"t2"];
        Id = [NSString stringWithFormat:@"%@",[temp objectForKey:@"id"]];
        NSManagedObject *newMatch = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:context];
        [newMatch setValue:Id forKey:@"matchId"];
        [newMatch setValue:t1 forKey:@"team1"];
        [newMatch setValue:t2 forKey:@"team2"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Match"];
        self.matches = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection*) connection {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&error];
    NSManagedObjectContext *context = [self managedObjectContext];
    if(jsonObject!=nil && error == nil)
    {
        if ([jsonObject isKindOfClass:[NSArray class]])
        {
            [self deleteExistingMatches:context];
            NSArray *deserializedArray = (NSArray*)jsonObject;
            [self saveMatch:context deserializedArray:deserializedArray];
        }
    }
    
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
    
    int count= [self.matches count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Match *match;
    match = [self.matches objectAtIndex:indexPath.row];
    
    NSMutableString *concat;
    concat = [NSString stringWithFormat:@"%@%@%@", match.team1,@" V/S ", match.team2];
    cell.textLabel.text = concat;
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel sizeToFit];
    return cell;
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        Match *match;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        match = [self.matches objectAtIndex:indexPath.row];
        NSString *matchId = [match matchId];
        NSLog(@"MAtch ID of cell =%@", matchId);
        //[segue destinationViewController] setdeta;
        [[segue destinationViewController] setMatchDetail:matchId];

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     //MatchDetailViewController *matchDetailViewController = [[MatchDetailViewController alloc] initWithNibName:<#(NSString *)#> bundle:<#(NSBundle *)#>
     // ...
     // Pass the selected object to the new view controller.
     //[self.navigationController pushViewController:matchDetailViewController animated:YES];
    
}

- (IBAction)refresh:(id)sender {
    [self viewDidLoad];
}
@end

