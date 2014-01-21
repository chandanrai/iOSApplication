//
//  HeadlinesViewController.m
//  CustomApp
//
//  Created by swin on 19/11/13.
//  Copyright (c) 2013 CHANDAN RAI. All rights reserved.
//

#import "HeadlinesViewController.h"
#import "HeadlineDetailViewController.h"

@interface HeadlinesViewController ()

@end

@implementation HeadlinesViewController
@synthesize data = _data;
@synthesize headlines = _headlines;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    NSURL *url = [NSURL URLWithString:@"http://api.espn.com/v1/sports/news/headlines?apikey=rx4rtr87zb3rm8sxcukv42r4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callAPI];
    self.data = [[NSMutableData alloc] init];
    self.headlines = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Headlines"];
    self.headlines = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];

}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)newData
{
    [self.data appendData:newData];
}

- (void)deleteExistingHeadlines:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Headlines"];
    NSArray *headlines = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *managedObject in headlines) {
        [context deleteObject:managedObject];
        NSLog(@"object deleted");
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)saveHeadlines:(NSManagedObjectContext *)context deserializedDictionary:(NSDictionary *)deserializedDictionary {
    // Create a new managed object
    NSString *t;
    NSString *desc;
    NSArray *headlines = [deserializedDictionary objectForKey:@"headlines"];
    
        for (NSDictionary *temp in headlines) {
            t = [temp objectForKey:@"headline" ];
            desc = [temp objectForKey:@"description"];
            NSManagedObject *newHeadline = [NSEntityDescription insertNewObjectForEntityForName:@"Headlines" inManagedObjectContext:context];
            [newHeadline setValue:t forKey:@"title"];
            [newHeadline setValue:desc forKey:@"desc"];
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Headlines"];
        self.headlines = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        [self dismissViewControllerAnimated:YES completion:nil];
    }


- (void) connectionDidFinishLoading:(NSURLConnection*) connection {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:&error];
    NSManagedObjectContext *context = [self managedObjectContext];
    if(jsonObject!=nil && error == nil)
    {
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *deserializedDictionary = (NSDictionary*)jsonObject;
            [self deleteExistingHeadlines:context];
            [self saveHeadlines:context deserializedDictionary:deserializedDictionary];
            
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count= [self.headlines count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Headlines *headline;
    headline = [self.headlines objectAtIndex:indexPath.row];
    cell.textLabel.text = headline.title;
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel sizeToFit];
    return cell;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Headlines *headline;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    headline = [self.headlines objectAtIndex:indexPath.row];
    [[segue destinationViewController] setHeadlineDetail:headline.desc];
    
}

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
