//
//  FirstViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "AFNetworking.h"

@interface FirstViewController ()
@end



@implementation FirstViewController
@synthesize lblName;
@synthesize lblDate;
@synthesize todaysImagePath;
@synthesize todaysImage;
@synthesize makersName;

- (void)setTodaysValues:(NSString*)name pathToImage:(NSString*)path
{
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d YYYY"];  
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
 //   [comps setMonth:2];
    [comps setDay:-1];
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    NSString *wonOnDate = [dateFormat stringFromDate:date];

    lblDate.textColor = [UIColor redColor];
    lblDate.text = wonOnDate;  
    lblName.textColor = [UIColor redColor];
    lblName.text =  [name capitalizedString];
    [self displayImage:path];    
}
- (void)displayImage:(NSString *)imgPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [paths objectAtIndex:0];
    NSString *imageDirPath = documentDir;
    imageDirPath = [NSString stringWithFormat:@"%@/%@/%@",imageDirPath, @"initialimages",[imgPath lastPathComponent]];
    UIImage	*img = [UIImage imageWithContentsOfFile:imageDirPath];
    todaysImage.image = img;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    	
    NSString *imgType = @"returnIphoneImg";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appaccess:0821mcg@174.143.175.219:9858/TCM/returnCOTD.php?imgType=%@",imgType]];
//     NSLog(@"The URL was %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id json) {
        NSArray *cotdElementsArray = (NSArray *)[json valueForKeyPath:@"cotdElements"];
        
        int ndx;
        for (ndx = 0; ndx < [cotdElementsArray count]; ndx++) {
            NSDictionary *cotdDict = (NSDictionary *)[cotdElementsArray objectAtIndex:ndx];
            self.makersName = [cotdDict valueForKey:@"makersName"];
            self.todaysImagePath = [cotdDict valueForKey:@"fullPath"];
            [self setTodaysValues:self.makersName pathToImage:self.todaysImagePath];
        }
     //   NSLog(@"in setCompletionBlockWithSuccess %@",json);
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"in ******** failure: %@", error);
     }];
    [operation start];
    AFHTTPRequestOperation *oPeration = [[AFHTTPRequestOperation alloc]  initWithRequest:request];
    oPeration.responseSerializer = [AFJSONResponseSerializer serializer];
}

- (void)viewDidUnload
{
    [self setLblName:nil];
    [self setLblDate:nil];
    [self setLblName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


@end
