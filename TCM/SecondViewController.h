//
//  SecondViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIActionSheet *myActionSheet;
    UIImagePickerController* picker;
}
@property (retain, nonatomic) UIActionSheet *myActionSheet;
@property (nonatomic, retain) UIImagePickerController *picker;
@end
