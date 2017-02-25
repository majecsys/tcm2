//
//  SecondViewController.m
//  TCM
//
//  Created by Ed Guinn on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"
#import "AFNetworking.h"
#import "CameraVC.h"


@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize myActionSheet;
@synthesize picker;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushSegueToCameraVC"]) {
        
        CameraVC *cameraVC = [segue destinationViewController];
        cameraVC.hidesBottomBarWhenPushed = YES;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self cameraActionSheet];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)cameraActionSheet
{
    
myActionSheet =  [[UIActionSheet alloc] initWithTitle:@"By clicking 'Do It!!!' you agree not to upload anything un-cool. We reserve the right to refuse any photos that are of low quality or are inappropriate for all ages. We will hunt you down. Only one photo per 24 hours please. Give us time to review the image and we will put your costume up for the world to see."
                                             delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Do It!!!",nil];
   // [myActionSheet addButtonWithTitle:@"Do It!!!"];
	//[myActionSheet addButtonWithTitle:@"Cancel"];	
	myActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}




//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
//}



#pragma mark - twoButton
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            [self performSegueWithIdentifier:@"pushSegueToCameraVC" sender:actionSheet];
        }break;
        case 1:{
//            NSLog(@"selected index = %d",[self.tabBarController selectedIndex]);
            [self.tabBarController setSelectedIndex:0];
           
        }break;
        default:
            break;
    }
}

@end
