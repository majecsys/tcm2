//
//  Ipad_FirstViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ipad_FirstViewController.h"
#import "AFNetworking.h"

@interface Ipad_FirstViewController ()

@end

@implementation Ipad_FirstViewController

@synthesize lblName;
@synthesize lblDate;
@synthesize todaysImagePath;
@synthesize todaysImage;
@synthesize makersName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    NSString *imageDirPath = documentDir; //[documentDir defineDirectoryPaths:@"initialimages"];
    imageDirPath = [NSString stringWithFormat:@"%@/%@/%@",imageDirPath, @"initialimages",[imgPath lastPathComponent]];
    UIImage	*img = [UIImage imageWithContentsOfFile:imageDirPath];
    todaysImage.image = img;
    
}

- (void)viewDidLoad
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    NSLog(@"width  %f", screenBounds.size.width);
    NSLog(@"  height %f", screenBounds.size.height);
    
    [super viewDidLoad];
    NSString *imgType = @"returnIpadImg";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appaccess:0821mcg@174.143.175.219:9856/TCM/returnCOTD.php?imgType=%@",imgType]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request    
//            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) { 
//                                                                                            //            NSDictionary *results = [json valueForKeyPath:@"cotdElements"];
//           //            NSLog(@"The class is %@",[results class]);
//            NSArray *cotdElementsArray = (NSArray *)[json valueForKeyPath:@"cotdElements"];
//
//            int ndx;
//            for (ndx = 0; ndx < [cotdElementsArray count] ; ndx++)
//            {
//            NSDictionary *cotdDict = (NSDictionary *)[cotdElementsArray objectAtIndex:ndx];
//                
//            self.makersName = [cotdDict valueForKey:@"makersName"]; 
//            self.todaysImagePath = [cotdDict valueForKey:@"ip_fullPath"];
//                                                                                            
//            [self setTodaysValues:self.makersName pathToImage:self.todaysImagePath];
//            }
//        }
//        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
//            NSLog(@"The error was %@",error);
//            }];
//    
//    [operation start];
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
