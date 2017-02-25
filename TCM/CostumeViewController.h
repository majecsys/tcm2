//
//  CostumeViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CostumeViewController;



@interface CostumeViewController : UIViewController
{
    IBOutlet  UIImageView *fullImageView;
    UIImage *fullImage;
    NSString *costumeID;
}

@property (strong, nonatomic) IBOutlet  UIImageView *fullImageView;
@property (strong, nonatomic) IBOutlet  UIImage *fullImage;
@property  (strong ,nonatomic) NSString *costumeID;
-(void) registerVote:(NSString*)cID;
- (IBAction)back:(id)sender;
- (IBAction)vote:(id)sender;




@end
