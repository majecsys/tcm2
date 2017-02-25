//
//  PickPastCostumeViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickPastCostumeViewController.h"
#import "AFNetworking.h"

@interface PickPastCostumeViewController ()

@end

@implementation PickPastCostumeViewController
@synthesize myDatePicker;
@synthesize dateStr;
@synthesize img;
@synthesize winningCostumeViewController;
@synthesize winningImage;
@synthesize makersNameLabel;

- (NSString*)getDateAsString
{
    // Convert date object to desired output format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    self.dateStr = [dateFormat stringFromDate:[self.myDatePicker date]];     
    return self.dateStr;
}
- (IBAction)dateSelected:(id)sender{
    [self getPastCOTD:[self getDateAsString]];
}

- (void)getPastCOTD:(NSString*)theDay
{
//	NSData *urlData;
//	NSError *error = nil; 
//	NSURLResponse *response = nil;
// __block NSMutableArray* winnerDetailsArr = [[NSMutableArray alloc] initWithCapacity:3] ;
//
//    
//	NSString *updateQuery = [NSString stringWithFormat: @"http://appaccess:0821mcg@174.143.175.219:9858/TCM/returnPastCOTD.php?theDay=%@",[theDay stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//	NSURL *urlToSend = [[NSURL alloc] initWithString:updateQuery];
//	NSURLRequest *request = [NSURLRequest requestWithURL:urlToSend];
//    
//	urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
//        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json){
//           
//            NSArray *cotdElementsArray = (NSArray *)[json valueForKeyPath:@"pastCOTDElements"];
//            NSString *dateWon;
//            NSString *makersName;
//            NSString *fullpath;
//            
//            int ndx;
//            for (ndx = 0; ndx < 1; ndx++) {
//                NSDictionary *cotdDict = (NSDictionary *)[cotdElementsArray objectAtIndex:ndx];
//                dateWon =[cotdDict valueForKey:@"datewon"];
//                makersName = [cotdDict valueForKey:@"makersname"];
//                fullpath = [cotdDict valueForKey:@"fullpath"];
//            }
//            
//            [winnerDetailsArr insertObject:dateWon atIndex:0];
//            [winnerDetailsArr insertObject:makersName atIndex:1];
//            [winnerDetailsArr insertObject:fullpath atIndex:2];
//            [self getRemoteImage:winnerDetailsArr];
//        }
//        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
//            [self pushMyNewViewController:[UIImage imageNamed:@"dummyLF.png"] makersName:@"Home Boy"];
//        }];
//    [operation start];
}

- (void) getRemoteImage:(NSMutableArray*)imageDetails
{     
//    NSString *imagePathAndName;
//    NSString *makersName;
//    makersName = [imageDetails objectAtIndex:1];
//    imagePathAndName = [imageDetails objectAtIndex:2];
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appaccess:0821mcg@174.143.175.219:9858%@",imagePathAndName]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:(NSURLRequest *)request
//           success:^(UIImage *image) {             
//               [self pushMyNewViewController:image makersName:makersName];               
//           }];
//
//    [operation start];
}


- (IBAction)pushMyNewViewController:(UIImage*)winnerimg makersName:(NSString*)name
{
    WinningCostumeViewController *myNewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"winningInStoryboard"];
    myNewVC.view.backgroundColor = [UIColor whiteColor];
    myNewVC.winningCostumeImageView.image = winnerimg;
    myNewVC.makersNameLabel.text = name;
    [self presentViewController:myNewVC animated:YES completion:nil];
    //    [self performSegueWithIdentifier:@"pushToWinning" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushToWinning"]) {
//        WinningCostumeViewController *dest = segue.destinationViewController;
//        dest.myImage = [imgObject setImg:[UIImage imageNamed:@"noPicAllowed.png"]]; // imgObject.myImg;
//        dest.view. backgroundColor = [UIColor redColor];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end

