//
//  Ipad_FirstViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ipad_FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic)  NSString *todaysImagePath;
@property (weak, nonatomic) IBOutlet  UIImageView *todaysImage;
@property (strong,nonatomic) NSString *makersName;

- (void)setTodaysValues:(NSString *)name pathToImage:(NSString*)path;
- (void)displayImage:(NSString *)imgPath;

@end
