//
//  Ipad_CostumeViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ipad_CostumeViewController.h"

@interface Ipad_CostumeViewController ()

@end

@implementation Ipad_CostumeViewController


- (IBAction)back:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)vote:(id)sender
{
    //   [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self registerVote:1];   
}

- (void)registerVote:(NSInteger)cID
{
    NSLog(@"one vote registered");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
                                              action:@selector(commitVote:)];
    
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
