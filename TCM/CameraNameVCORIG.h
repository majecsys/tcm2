//
//  CameraNameVC.h
//  TCM
//
//  Created by Ed Guinn on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraNameVC : UIViewController<UITextFieldDelegate>
{
    UIImage *picForReview;
    UIImageView *imgView;
    UITextField *nameField;
    UIProgressView *progressView;
    
}

@property (nonatomic, strong) UIImage *picForReview;
@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (readonly, strong, nonatomic) NSString* documentsPath;
-(void) textProcessing;
//-(void)uploadImage:(UIImage *)resizedImg;

@end
