//
//  WinningCostumeViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WinningCostumeViewController.h"

@interface WinningCostumeViewController ()

@end

@implementation WinningCostumeViewController
@synthesize winningCostumeImageView;
@synthesize winnersImage;
@synthesize makersNameLabelVar;
@synthesize makersNameLabel;

- (IBAction)back:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//      winningCostumeImageView.frame =  CGRectMake(0, 0, 320, 568);
//    makersNameLabel.text =  makersNameLabelVar;
//    winningCostumeImageView.image = myImage;

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
