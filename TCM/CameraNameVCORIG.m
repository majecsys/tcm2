//
//  CameraNameVC.m
//  TCM
//
//  Created by Ed Guinn on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraNameVC.h"
#import "AFNetworking.h"
#import "FirstViewController.h"

@interface CameraNameVC ()

@end

@implementation CameraNameVC
@synthesize picForReview;
@synthesize imgView;
@synthesize nameField;
@synthesize progressView;
@synthesize documentsPath;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushToTabBarHome"]) {
        
        FirstViewController *firstViewVC = [segue destinationViewController];
    //    firstViewVC.hidesBottomBarWhenPushed = YES;
        
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
//- (void)makeMyProgressBarMoving {
//    
//    float actual = [self.progressView progress];
//    if (actual < 1) {
//        self.progressView.progress = actual + ((float)100.00/(float)10000.00);
//        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
//    }
//    else{        
//        }    
//} 

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [self.navigationController setNavigationBarHidden:YES];
    
//    NSLog(@" imageView width  %f", self.imgView.bounds.size.width);
//    NSLog(@" imageView height %f", self.imgView.bounds.size.height);
//    
//    NSLog(@" Pic height %f", self.picForReview.size.height);
//    NSLog(@" Pic width %f", self.picForReview.size.width);
    
    self.imgView = [[UIImageView alloc] initWithImage:self.picForReview];
    self.view = self.imgView;
  //  self.nameField.text = @"asdad adasd asdasda "; 
    [self textProcessing];   
}

-(void) textProcessing
{
    [self.nameField becomeFirstResponder];
    self.nameField.returnKeyType = UIReturnKeyDone;
	self.nameField.keyboardType = UIKeyboardTypeDefault;
    self.nameField.delegate = self;
    [self.view addSubview:self.nameField];   
    
}

#pragma mark - text 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

	BOOL max;
    NSString *newString = [self.nameField.text stringByReplacingCharactersInRange:range withString:string];
	
    if(!([newString length] > 5))
    {
		self.nameField.backgroundColor = [UIColor clearColor];
		return max = YES;
    }
	else {
               
		[self.nameField setBackgroundColor:[UIColor redColor]];
		[self.nameField setAlpha:0.7];
		return max = NO;
	}
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.nameField.text length] > 0 ) {
        [self.nameField resignFirstResponder];
        [self processDone];        
        return YES;
    }
    else
    {
        UIAlertView *noNameAlert = [[UIAlertView alloc] initWithTitle:@"Hey!"							  
                                                              message:@"Please Enter something, a name our how you want your costume identified"					  
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok!"
                                                    otherButtonTitles:nil];
		[noNameAlert show];
        return NO;
    }
    
}

- (void) processDone
{
 //http://stackoverflow.com/questions/9962324/resizing-uiimage-takes-long-time
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [UIScreen mainScreen].scale > 1)
//    {
//        // new iPad
//    }
    
    
//    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            CGRect screenBounds = [[UIScreen mainScreen] bounds];
//            CGFloat screenScale = [[UIScreen mainScreen] scale];
//            CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
//            
//            UIGraphicsBeginImageContext(screenSize);
//            [image drawInRect:CGRectMake(0,0,screenSize.width,screenSize.height)];
//            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            
//            NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
//            [currentDefaults setObject:UIImagePNGRepresentation(newImage) forKey:@"newImageKey"];
//            [currentDefaults synchronize];
//        });
//        
//        [popoverController dismissPopoverAnimated:YES];
//        [picker dismissModalViewControllerAnimated:YES];
//    }
//   self.progressView.progress = 0.0;
 //   [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
 //   [self.view addSubview:self.progressView];
    
    
    self.nameField.hidden = YES;
    [self returnResizedImageFromStorage];
}

-(void)returnResizedImageFromStorage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsPath = [paths objectAtIndex:0];

    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *tmpArry =  [fileManager contentsOfDirectoryAtPath:[documentsPath stringByAppendingPathComponent:@"resizedImageDir"] error:nil];
    UIImage *loadedImage = [UIImage imageWithContentsOfFile:[documentsPath stringByAppendingPathComponent:@"resizedImageDir/tmpImg.png"]];
    
    
 //   NSLog(@"my array %@",tmpArry);
    UIImage *resizedImg = loadedImage;
    return [self uploadImage:resizedImg];

}

-(void)uploadImage:(UIImage *)resizedImg
{
    
    [self.view addSubview:self.progressView];
    self.progressView.progress = 0.0;
   
    
    NSString *genericImageName = @"theImgX!X.png";
    AFHTTPClient *httpClient= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://appaccess:0821mcg@174.143.175.219:9856"]];
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    [requestParameters setObject:@"iPhone"  forKey:@"deviceName"];
    [requestParameters setObject:self.nameField.text forKey:@"txtMakersName"];
    
    NSData *imageData = UIImagePNGRepresentation(resizedImg);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/TCM/uploadValidateImg.php" parameters:requestParameters constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData name:@"file" fileName:@"myfile.png" mimeType:@"image/png"];
    }];    
 
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request ];
    
/*    [operation setAuthenticationChallengeBlock:
     ^( NSURLConnection* connection, NSURLAuthenticationChallenge* challenge )
    {
        if( [[challenge protectionSpace] authenticationMethod] == NSURLAuthenticationMethodNTLM )
        {
            if( [challenge previousFailureCount] > 0 )
            {
                // Avoid too many failed authentication attempts which could lock out the user
                [[challenge sender] cancelAuthenticationChallenge:challenge];
            }
            else
            {
                [[challenge sender] useCredential:[NSURLCredential credentialWithUser:@"root" password:@"m1wfeQEDM" persistence:NSURLCredentialPersistenceForSession] forAuthenticationChallenge:challenge];
            }
        }
        else
        {
            // Authenticate in other ways than NTLM if desired or cancel the auth like this:
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }];
  */  
    
    
   
  
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     //   NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        
//        NSLog(@"Progrees -> %f", ((float)((int)totalBytesWritten) / (float)((int)totalBytesExpectedToWrite)));
//        float actual = [self.progressView progress];
//        if (actual < 1) {
//            self.progressView.progress = actual + ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
//        }
        
        self.progressView.progress = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
        
  //    NSLog(@"success: %@", operation.responseString);
    }];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success: %@", operation.responseString);
        [self performSegueWithIdentifier:@"pushToTabBarHome" sender:self];
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"error-->: %@",error);
                                     } 
     ];

    [httpClient enqueueHTTPRequestOperation:operation];
  //  [operation start];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
