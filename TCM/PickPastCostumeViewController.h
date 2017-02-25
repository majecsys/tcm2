//
//  PickPastCostumeViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WinningCostumeViewController.h"

@interface PickPastCostumeViewController : UIViewController{   
    IBOutlet  UIDatePicker *myDatePicker;
    IBOutlet  UIImageView *img;
    UIImage *winningImage;
    NSString *dateStr;
}
@property (retain,strong) WinningCostumeViewController *winningCostumeViewController;
@property (retain,strong) WinningCostumeViewController *makersNameLabel;
@property(retain,nonatomic) UIImage *winningImage;
@property(retain,nonatomic) UIImageView *img;
@property (strong,nonatomic) UIDatePicker *myDatePicker;
@property (strong,nonatomic) NSString *dateStr;
- (NSString*)getDateAsString;
- (IBAction)dateSelected:(id)sender;

@end
