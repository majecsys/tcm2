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
    UITextField *nameTextField;
    UIProgressView *progressView;

    UILabel *lbl;
    IBOutlet UITextField *emailTextField;

    
}

@property (nonatomic, strong) UIImage *picForReview;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (readonly, strong, nonatomic) NSString* documentsPath;

@property (nonatomic, retain) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UISwitch* showEmailViewSwitch;
@property (nonatomic, strong) IBOutlet UILabel *lbl;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;


- (IBAction)showEmailView:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)getEmails:(id)sender;

@end
