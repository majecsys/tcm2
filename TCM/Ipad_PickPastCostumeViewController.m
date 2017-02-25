//
//  Ipad_PickPastCostumeViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ipad_PickPastCostumeViewController.h"

@interface Ipad_PickPastCostumeViewController ()

@end

@implementation Ipad_PickPastCostumeViewController
@synthesize myDatePicker;

- (IBAction)dateSelected:(id)sender{
    NSLog(@"Date selected");
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
	// Do any additional setup after loading the view.
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
