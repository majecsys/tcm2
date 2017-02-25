//
//  CameraVC.h
//  TCM
//
//  Created by Ed Guinn on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraNameVC.h"



@interface CameraVC : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController* picker;
    UIImage *picForReview;
    UIImage *currentImageInContext;
    
}

@property (weak, nonatomic) IBOutlet  UIImageView *noPicImgView;
@property (readonly, strong, nonatomic) NSString* documentsPath;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImage *picForReview;
@property (nonatomic, strong) UIImage *currentImageInContext;
@property (nonatomic,strong) CameraNameVC  *cameraNameVC;



- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType;
-(void) pickerWasCancelled;
-(void)dismissCameraAndShowCameraVC:(UIImage *)picture;
@end
