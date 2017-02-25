//
//  CameraTimerViewController.m
//  TCM
//
//  Created by Ed Guinn on 8/29/13.
//
//

#import "CameraTimerViewController.h"

@interface CameraTimerViewController ()

@end

@implementation CameraTimerViewController

@synthesize btn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)dismissAction:(id)sender
{
    [self.tabBarController setSelectedIndex:0];
//    [self.parentViewController viewWillAppear:YES];
//	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
