//
//  Ipad_ListViewControllerViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ipad_ListViewControllerViewController.h"
#import "Ipad_CostumeCellElements.h"
#import "AppDelegate.h"
#import "Ipad_CostumeViewController.h"

@interface Ipad_ListViewControllerViewController ()

@end

@implementation Ipad_ListViewControllerViewController

@synthesize costumeElementsArray;
@synthesize documentsPath;


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
    [self getCostumeElements];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Database section
-(void) getCostumeElements{
    
    costumeElementsArray = [[NSMutableArray alloc] init ];
    FMDatabase* thisDB = [FMDatabase databaseWithPath:[self findDB]];    
    //    [thisDB setTraceExecution:TRUE];
    
    if (![thisDB open]) {
        NSLog(@"Could not open db.");
    } 
    FMResultSet *rs = [thisDB executeQuery:@"select id,tnpath,makersname from COSTUMES",  nil];
    
    while ([rs next]) {
        [costumeElementsArray addObject:[rs resultDictionary]];        
    }
    [rs close]; 	
}

-(NSString*)findDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"TCM.sqlite"];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (success) {
        return dbPath;
    }else {
        return @"no dbd";
        //   NSLog(@"DB exists, no need to copy.");
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [costumeElementsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    Ipad_ListViewCell *cell = (Ipad_ListViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cellList"];
//    Costume *costume = [self.costumes objectAtIndex:indexPath.row];
//    
//    cell.cellImage.image = [UIImage imageNamed:@"dummyLF.png"];  //****** will be costume.image
//    cell.nameLabel.text  = @"something scary";                   //***** will be costume.lbl info
    
    
//    return cell;
    Ipad_CostumeCellElements *cell = (Ipad_CostumeCellElements*)[tableView dequeueReusableCellWithIdentifier:@"cellList"];
    NSDictionary *dictionary = [costumeElementsArray objectAtIndex:indexPath.row];
    
    cell.nameLbl.text = [dictionary valueForKey:@"makersname"] ;
    cell.cellImg.image = [UIImage imageNamed:[dictionary valueForKey:@"tnpath"]];
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushSegueToCostumeView"]) {
        
      Ipad_CostumeViewController *costumeViewController = [segue destinationViewController];
        costumeViewController.hidesBottomBarWhenPushed = YES;
        
    }
}

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

@end
