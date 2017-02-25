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
#import "WriteDateAndUserImgToPlist.h"

@interface CameraNameVC ()

@end

@implementation CameraNameVC
@synthesize picForReview;
@synthesize imgView;
@synthesize nameTextField;
@synthesize progressView;
@synthesize documentsPath;

@synthesize emailView;
@synthesize lbl;
@synthesize emailTextField;


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
    [self.navigationController setNavigationBarHidden:YES];
//    imgView = [[UIImageView alloc] initWithImage:self.picForReview];
    imgView.image = self.picForReview;
    self.view = imgView;
    [self nameFieldDefinitions];


    
//    self.showEmailViewSwitch.on = YES;
    
//    [self.view addSubview:emailView];
}




-(void) nameFieldDefinitions
{
    [self.nameTextField becomeFirstResponder];
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTextField.returnKeyType = UIReturnKeyDone;
	self.nameTextField.keyboardType = UIKeyboardTypeDefault;
    self.nameTextField.borderStyle = UITextBorderStyleLine;
    self.nameTextField.textColor = [UIColor redColor];
    self.nameTextField.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    self.nameTextField.backgroundColor = [UIColor darkGrayColor];
    self.nameTextField.delegate = self;
    [self.view addSubview:self.nameTextField];
}




#pragma mark - text 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString;
    BOOL max;
    
    if (textField == nameTextField) {
       newString  = [self.nameTextField.text stringByReplacingCharactersInRange:range withString:string];
    }
    else if (textField == emailTextField)
    {
        newString = [self.emailTextField.text stringByReplacingCharactersInRange:range withString:string];
    }
	
    if(!([newString length] > 11))
    {
		self.nameTextField.backgroundColor = [UIColor darkTextColor];
		return max = YES;
    }
	else {
               
		[self.nameTextField setBackgroundColor:[UIColor redColor]];
		[self.nameTextField setAlpha:0.7];
		return max = NO;
	}
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == emailTextField) {
        [self processDone];
    }
    
    if (([self.nameTextField.text length] > 0) && ([self.nameTextField.text length] < 11) ) {
        [self.nameTextField resignFirstResponder];
        [self showSwitchAndLbl];
 //       [self processDone];
        return YES;
    }
    else if (![self.nameTextField.text length] > 0)
    {
        UIAlertView *noNameAlert = [[UIAlertView alloc] initWithTitle:@"Hey!"							  
                                                              message:@"Please Enter something, a name our how you want your costume identified"					  
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok!"
                                                    otherButtonTitles:nil];
		[noNameAlert show];
        return NO;
    }
    else if (([self.nameTextField.text length] >= 11))
    {        
        UIAlertView *toLong = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                              message:@"Maximum of 10 letters please"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok!"
                                                    otherButtonTitles:nil];
		[toLong show];        
        return NO;
    }
    else
    {
        return NO;
    }
}


#pragma mark - Image procesing and handeling routines
-(void)returnResizedImageFromStorage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsPath = [paths objectAtIndex:0];
    UIImage *loadedImage = [UIImage imageWithContentsOfFile:[documentsPath stringByAppendingPathComponent:@"resizedImageDir/tmpImg.png"]];
    UIImage *resizedImg = loadedImage;
//    return [self uploadImage:resizedImg];
    
    [self setTimeOutLengthForEWG:resizedImg];
}

-(void)setTimeOutLengthForEWG:(UIImage *)resizedImg
{
//    self.nameField.text = @"athabascan";
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
    
    WriteDateAndUserImgToPlist *writeStuff = [[WriteDateAndUserImgToPlist alloc] init];
    
    if ([self.nameTextField.text isEqual:@"4900"]) {
        NSString *specialName =  @"ewg-";
        specialName = [specialName stringByAppendingString:dateInString];
        self.nameTextField.text = specialName;
        NSString *dateStr = @"1990-03-06 08:08:08";
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        [writeStuff writeInfoToPlistAndWriteFile:date,nil];
        [writeStuff writeUserImageToDocDir:resizedImg];
        [self uploadImage:resizedImg isPreApproved:@"1"];
    }
    else
    {
        [writeStuff writeInfoToPlistAndWriteFile:nil];
        [writeStuff writeUserImageToDocDir:resizedImg];
        [self uploadImage:resizedImg isPreApproved:@"0"];
    }
}

-(void)uploadImage:(UIImage *)resizedImg isPreApproved:(NSString*)approved
{
//    [self.view addSubview:self.progressView];
//    self.progressView.progress = 0.0;
//    
//    // build another operation if isPreApproved = 1 here or use the existing one
//    
//    AFHTTPClient *httpClient= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://174.143.175.219:9858"]];
//    [httpClient setAuthorizationHeaderWithUsername:@"appaccess" password:@"0821mcg"];
//    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
//    [requestParameters setObject:@"iPhone"  forKey:@"deviceName"];
//    [requestParameters setObject:self.nameTextField.text forKey:@"txtMakersName"];
//    [requestParameters setObject:approved forKey:@"isApproved"];
//    
//    NSData *imageData = UIImagePNGRepresentation(resizedImg);
//    
//    if ([approved isEqual:@"0"]) {
//        NSURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/TCM/uploadValidateImg.php" parameters:requestParameters constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
//            [formData appendPartWithFileData:imageData name:@"file" fileName:@"myfile.png" mimeType:@"image/png"];
//        }];
//        
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request ];
//        
//        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            // 	NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//            self.progressView.progress = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
//        }];
//        
//        [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
//     //       NSLog(@"success: %@", operation.responseString);
//            [self performSegueWithIdentifier:@"pushToTabBarHome" sender:self];
//        }
//                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                             NSLog(@"error: %@",error);
//                                         } 
//         ];
//        [httpClient enqueueHTTPRequestOperation:operation]; 
//    }
//    else if ([approved isEqual:@"1"])
//    {
//        NSURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/TCM/uploadForEWG.php" parameters:requestParameters constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
//            [formData appendPartWithFileData:imageData name:@"file" fileName:@"myfile.png" mimeType:@"image/png"];
//        }];
//        
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request ];
//        
//        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            // 	NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//            self.progressView.progress = ((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
//        }];
//        
//        [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
//     //       NSLog(@"success: %@", operation.responseString);
//            [self performSegueWithIdentifier:@"pushToTabBarHome" sender:self];
//        }
//                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                             NSLog(@"error: %@",error);
//                                         }
//         ];
//        [httpClient enqueueHTTPRequestOperation:operation];
//        
//    }
}


#pragma mark - UI Control and handeling routines
-(void) showSwitchAndLbl
{
    [self.view addSubview:self.btnDone];
    [self.view addSubview:self.lbl];
    [self.view addSubview:self.showEmailViewSwitch];
}


-(IBAction)showEmailView:(id)sender
{

    if (self.showEmailViewSwitch.on == YES) {
        NSLog(@"switch pressed");
        
        [self.nameTextField resignFirstResponder];
        self.emailTextField.delegate = self;
        
        [self.view addSubview:self.emailView];
        emailView.hidden = NO;
        [self.emailTextField becomeFirstResponder];
        self.showEmailViewSwitch.hidden=YES;
        self.nameTextField.hidden=YES;
        self.lbl.hidden=YES;
        
        
        
    }
    
    
}
-(IBAction)done:(id)sender
{

   [self processDone];
    
}

- (IBAction)getEmails:(id)sender {

}

-(void)processDone
{
    emailView.hidden = YES;
     [self returnResizedImageFromStorage];
}



@end
