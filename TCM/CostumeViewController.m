//
//  CostumeViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CostumeViewController.h"
#import "AFNetworking.h"

@interface CostumeViewController ()

@end

@implementation CostumeViewController

@synthesize fullImageView;
@synthesize fullImage;
@synthesize costumeID;

- (IBAction)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)vote:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self registerVote:[self costumeID]];
}

- (void)registerVote:(NSString*)cID
{
//    NSLog(@"one vote registered id is %@",cID);
//    NSString *oneVoteOnly = @"1";
//    AFHTTPClient *httpClient= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://174.143.175.219:9858"]];
//    [httpClient setAuthorizationHeaderWithUsername:@"appaccess" password:@"0821mcg"];
//    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
//    [requestParameters setObject:cID forKey:@"costumeID"];
//    [requestParameters setObject:oneVoteOnly  forKey:@"votes"];
//    
//    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/TCM/updateVoteTotals.php/" parameters:requestParameters];
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
////           NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//           NSLog(@"Error: %@", error);
//                                     }];
//    [httpClient enqueueHTTPRequestOperation:operation]; 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.fullImageView.image = [self fullImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btnCount = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    UIBarButtonItem *btnVote;
    btnCount.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    
    UILabel *lblVote = [[UILabel alloc] initWithFrame:btnCount.bounds];	
    [lblVote setTag:1];
    [lblVote setFont:[UIFont systemFontOfSize:12]];
    lblVote.textAlignment = UITextAlignmentCenter;
    [lblVote setText:@"0"];
    lblVote.textColor = [UIColor whiteColor];
    lblVote.backgroundColor = [UIColor blackColor];
    
    [btnCount addSubview:lblVote];
    
    UIToolbar *toolBar;
    toolBar = [UIToolbar new];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    btnVote = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Vote for this Costume", @"")
                                               style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(vote:)];
    
    // flex item used to separate the left groups items and right grouped items
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    NSArray *items = [NSArray arrayWithObjects: flexItem, btnVote,flexItem,nil];
    
    toolBar.items = items;
    
    // size up the toolbar and set its frame
    [toolBar sizeToFit];
    CGFloat toolbarHeight = [toolBar frame].size.height;
    CGRect mainViewBounds = self.view.bounds;
    [toolBar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
                                 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight * 2.0) + 2.0,
                                 CGRectGetWidth(mainViewBounds),
                                 toolbarHeight)];
    
    
    [self.view addSubview:toolBar];
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
