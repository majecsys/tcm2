//
//  Ipad_SecondViewController.m
//  TCM
//

#import "Ipad_SecondViewController.h"
#import "Ipad_FirstViewController.h"
@interface Ipad_SecondViewController ()

@end

@implementation Ipad_SecondViewController
@synthesize myActionSheet;
@synthesize picker;
@synthesize popoverController;

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self cameraActionSheet]; 
}

- (void)viewWillAppear:(BOOL)animated
{   
    [super viewWillAppear:animated];
  //  [self cameraActionSheet];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    //[self cameraActionSheet];
}

-(void)cameraActionSheet
{
 /*   UIView *placeholderview=[[UIView alloc]initWithFrame:CGRectMake(0, 310, 320, 100)];
    placeholderview.backgroundColor = [UIColor redColor];
    [self.view addSubview:placeholderview];*/
    myActionSheet =  [[UIActionSheet alloc] initWithTitle:@"By clicking 'Do It!!!' you agree not to upload anything un-cool. We reserve the right to refuse to post any photos that are of low quality or are inappropriate for all ages. We will hunt you down. Only one photo per 24 hours please. Give us time to review the image and we will put your costume up for the world to see."
                                                 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Do It!!!",nil];

	self.myActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
 //   [self.myActionSheet showFromRect:CGRectMake(150, 0, 0, 50) inView:placeholderview animated:YES];
     
	[myActionSheet showInView:self.view];	// show from our table view (pops up in the middle of the table)

    
}

- (void)viewDidUnload
{
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
#pragma mark - twoButton
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                picker.allowsEditing = NO;
                
                [self presentModalViewController:picker animated:YES];
            }
            else { 
                
                picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                picker.allowsEditing = NO;  
          //      [self presentModalViewController:picker animated:YES];
                
                CGRect myRect = CGRectMake(150,0, 400, 400);
                
               
                self.popoverController = [[UIPopoverController alloc]
                                     initWithContentViewController:picker];
                [self.popoverController presentPopoverFromRect:myRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];               
            }
            
        }break;
        case 1:{
            //NSLog(@"selected index = %d",[self.tabBarController selectedIndex]);
            [self.tabBarController setSelectedIndex:0];
            
        }break;
        default:
            break;
    }
    

}


@end
