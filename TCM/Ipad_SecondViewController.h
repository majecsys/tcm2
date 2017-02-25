//
//  Ipad_SecondViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ipad_SecondViewController :UIViewController <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    UIActionSheet *myActionSheet;
    UIImagePickerController* picker;
    UIPopoverController *popoverController;
}
@property (retain, nonatomic) UIPopoverController *popoverController;
@property (retain, nonatomic) UIActionSheet *myActionSheet;
@property (nonatomic, retain) UIImagePickerController *picker;
@end
