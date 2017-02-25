//
//  Ipad_PickPastCostumeViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ipad_PickPastCostumeViewController : UIViewController
{
    IBOutlet  UIDatePicker *myDatePicker;
}
@property (strong,nonatomic) UIDatePicker *myDatePicker;

- (IBAction)dateSelected:(id)sender;
@end
