//
//  CameraVC.m
//  TCM
//
//  Created by Ed Guinn on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraVC.h"
#import "UIImage+Scale.h"
#import "WriteDateAndUserImgToPlist.h"
#import "CameraTimerViewController.h"


@interface CameraVC ()

@end

@implementation CameraVC

@synthesize noPicImgView;
@synthesize picker;
@synthesize picForReview;
@synthesize currentImageInContext;
@synthesize cameraNameVC;
@synthesize documentsPath;


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)


- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    [self presentViewController:self.picker animated:YES completion:NULL];
    [NSThread detachNewThreadSelector: @selector(processOrientationChange) toTarget:self withObject:nil];
}

-(void) pickerWasCancelled
{
    [self  dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)readAndCompareInfo
{
    BOOL showCameraView;
    
	WriteDateAndUserImgToPlist *readValues = [[WriteDateAndUserImgToPlist alloc] init];
	NSDictionary *dict =	[readValues readPlist];
	NSDate *storedTime;
	NSString *imgName;
	storedTime = [dict objectForKey:@"24HRStart"];
	imgName = [dict objectForKey:@"userImage"];
	
	NSDate *rightNow = [NSDate date];
	NSDate *theLaterDate = [storedTime laterDate:rightNow];
	if([theLaterDate isEqualToDate:rightNow]){
        return showCameraView = YES;
//		NSLog(@"This means I have a vlue and have to wait because storedTime %@ is  > than rightNow %@ later date = %@",storedTime,rightNow,theLaterDate);
	}
	else {
        return showCameraView = NO;
	//	NSLog(@"Not time yet times are storedTime %@ rightNow %@ ---- %@",storedTime,rightNow,theLaterDate);
	}
}



- (void)viewDidLoad
{
   [super viewDidLoad];
    documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if ([self readAndCompareInfo]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.picker.delegate = self;
            self.picker.allowsEditing = NO;
            
            [self showImagePicker:self.picker.sourceType];
        }
        else {
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.delegate = self;
            self.picker.allowsEditing = NO;
            
            [self showImagePicker:self.picker.sourceType];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"cameraTimerNotice" sender:self];
    }
}


-(void)processOrientationChange
{ 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

-(void)onOrientationChange:(NSNotification*)notification{
    
    UIInterfaceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    switch(deviceOrientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            noPicImgView.image = [UIImage imageNamed:@"noPicAllowed.png"];
            [self.picker.view addSubview:noPicImgView];
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            noPicImgView.image = [UIImage imageNamed:@"noPicAllowed.png"];
            [self.picker.view addSubview:noPicImgView];
            break;
            
        case UIInterfaceOrientationPortrait:
            noPicImgView.image = NO;
 //           [noPicImgView removeFromSuperview];
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            break;
    }
}

-(void)dismissCameraAndShowCameraVC:(UIImage *)picture
{
    [self  dismissViewControllerAnimated:YES completion:nil];
    [self resizePictureAndStore:picture];
    [self performSegueWithIdentifier:@"pushToNameVC" sender:picture];
    
}

-(void)resizePictureAndStore:(UIImage *)picture
{
    if( IS_IPHONE_5 )
    { NSLog(@" iphone 5 ");}
    else
    {NSLog(@" Not iphone 5 ");}
    
    currentImageInContext = UIGraphicsGetImageFromCurrentImageContext();
    
    // Figure out if working on Retina enabled device
    static CGFloat scale = -1.0;
    if(scale < 0.0){
        UIScreen *screen = [UIScreen mainScreen];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
            scale = [screen scale];
        }else{
            scale = 0.0;
        } 
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        //CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
        
        //using the UIImage category UIImage+Scale.h method scaleToSize
        UIImage *scaledImage = [currentImageInContext scaleToSize:CGSizeMake(320.0f,524.0f) scale:screenScale];
        NSData *imageData = UIImagePNGRepresentation(scaledImage);
        NSString *filePathAndDirectory = [documentsPath stringByAppendingPathComponent:@"resizedImageDir"];        

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager createFileAtPath:[filePathAndDirectory stringByAppendingString:@"/tmpImg.png"] contents:imageData attributes:nil]){
                NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
            }
            else{
                NSLog(@"resized image tmpImg.png was found");
            }
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {    
    if ([[segue identifier] isEqualToString:@"pushToNameVC"]) {        
        self.cameraNameVC = [segue destinationViewController];
        self.cameraNameVC.picForReview = self.picForReview;
    }
    else if ([[segue identifier] isEqualToString:@"cameraTimerNotice"])
    {
        CameraTimerViewController *cameraTimer = [segue destinationViewController];      
      
    }
}

#pragma mark camera delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* picture = [info objectForKey:UIImagePickerControllerEditedImage];
 	if (!picture)
		picture = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageWriteToSavedPhotosAlbum(picture,nil,nil,nil);
    
    CGSize pictureSize=CGSizeMake(320.0,524.0);
    UIGraphicsBeginImageContext(pictureSize);
    CGRect drawRect = CGRectMake(0, 0, 320, 524);
    [picture drawInRect:drawRect]; 
    self.picForReview = UIGraphicsGetImageFromCurrentImageContext();	
	[self dismissCameraAndShowCameraVC:self.picForReview];	

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self pickerWasCancelled];
}

@end
