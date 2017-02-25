//
//  ListViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ListViewController.h"
#import "CostumeViewController.h"
#import "AppDelegate.h"
#import "CostumeCellElements.h"

@interface ListViewController ()

@end

@implementation ListViewController

@synthesize costumeElementsArray;
@synthesize documentsPath;
@synthesize selectedFullImage;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
/*
-(void)play
{
	NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"wav" inDirectory:nil];
	NSString *randomSNDFilePath = [paths objectAtIndex: random() % [paths count]];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:randomSNDFilePath],&soundID);
	AudioServicesPlaySystemSound(soundID);
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    thumbnailCache = [[NSMutableDictionary alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [paths objectAtIndex:0];
    NSString *imageDirPath = [documentDir stringByAppendingString:@"/initialimages"] ;
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[imageDirPath stringByAppendingPathComponent:@"320x536.png"]]];
    [self getCostumeElements];
    
    self.tableView.rowHeight = 115;
	self.tableView.separatorColor = [UIColor blackColor];
	self.tableView.backgroundColor = [UIColor clearColor];
	
	self.tableView.opaque = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self removeCachedImages];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - database section

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

-(void) getCostumeElements{

    costumeElementsArray = [[NSMutableArray alloc] init ];
    FMDatabase* thisDB = [FMDatabase databaseWithPath:[self findDB]];    
//    [thisDB setTraceExecution:TRUE];
    
    if (![thisDB open]) {
        NSLog(@"Could not open db.");
    } 
    FMResultSet *rs = [thisDB executeQuery:@"select id,tnpath,fullpath,ip_fullpath,ip_tnpath,makersname from COSTUMES",  nil];

    while ([rs next]) {
        [costumeElementsArray addObject:[rs resultDictionary]];
    }
    [rs close];
//	NSLog(@"costumeElementsArray %@",costumeElementsArray);
}




- (UIImage*)loadImage:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [paths objectAtIndex:0];
    NSString *imageDirPath = [documentDir stringByAppendingString:@"/initialimages"] ;
    
    UIImage *thumbnail = [thumbnailCache objectForKey:fileName];    
    if (nil == thumbnail)
    {
        NSString *fullPath = [imageDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:fullPath];
        UIImage *thumbnail =  [[UIImage alloc] initWithData:imageData];
        [thumbnailCache setObject:thumbnail forKey:fileName];
    }
/*    else{
        NSLog(@"This is the filename %@",fileName);
    }*/
    return thumbnail;
}

- (void) removeCachedImages
{
	[thumbnailCache removeAllObjects];
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
    CostumeCellElements *cell = [tableView dequeueReusableCellWithIdentifier:@"cellList"];

    NSDictionary *dictionary = [costumeElementsArray objectAtIndex:indexPath.row];
    
 //   NSLog(@"objectAtIndex:indexPath.row =  %@",[costumeElementsArray otAtIndex:indexPath.row]);
   
    cell.nameLbl.text = [dictionary valueForKey:@"makersname"] ;
    
    UIImage *tmpImg = [self loadImage:[dictionary valueForKey:[@"tnpath" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if(nil != tmpImg)
    {
        cell.cellImg.image = tmpImg;
    }
    else
    {
        cell.cellImg.image = [self loadImage:[dictionary valueForKey:[@"tnpath" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    //[self loadImage:[dictionary valueForKey:[@"tnpath" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        NSLog(@"%@ -- %@",[dictionary valueForKey:@"tnpath"],[dictionary valueForKey:@"makersname"]);

    
//    UIImage *img = [UIImage imageNamed:[dictionary valueForKey:@"tnpath"]];
//    if ([[dictionary valueForKey:[@"tnpath" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqual: @"tn-one_finger201311131010.png"]) {
//        NSLog(@"This is the path to the image displayed %@",[dictionary valueForKey:@"tnpath"]);
//    }
    
    
//	if(img)
//    {
////        NSLog(@"img found -- %@",[dictionary valueForKey:@"tnpath"]);
////		cell.imageView.image = img;
//    }
//	else
//    {
////        NSLog(@"in the else");
//        cell.cellImg.image = [self loadImage:[dictionary valueForKey:[@"tnpath" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    }
    return cell;
}

#pragma mark - Table view delegate

//    [self performSegueWithIdentifier:@"pushSegueToCostumeView" sender:self];

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushSegueToCostumeView"]) {
        
//        NSLog(@"Cache %@ ",thumbnailCache);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [paths objectAtIndex:0];
        NSString *imageDirPath = [documentDir stringByAppendingString:@"/initialimages"] ;
        
        // sender will be the tableview cell that was selected
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSDictionary *dictionary = [costumeElementsArray objectAtIndex:indexPath.row];
        NSString *imgSource = [dictionary valueForKey:@"fullpath"];
        NSString *costumeID = [dictionary valueForKey:@"id"];
        selectedFullImage = [UIImage imageWithContentsOfFile:[imageDirPath stringByAppendingPathComponent:imgSource]];
        
//        NSLog(@"ID = %@",costumeID);
                CostumeViewController *costumeViewController = [segue destinationViewController];
        costumeViewController.fullImage = self.selectedFullImage;
        costumeViewController.costumeID = costumeID;
        costumeViewController.hidesBottomBarWhenPushed = YES;
        
    }
}
@end
