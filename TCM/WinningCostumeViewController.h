//
//  WinningCostumeViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinningCostumeViewController : UIViewController
{
    IBOutlet UIImageView *winningCostumeImageView;
    UIImage *winnersImage;
    UILabel *makersNameLabel;
}
@property (nonatomic, strong) IBOutlet UIImageView *winningCostumeImageView;
@property (nonatomic, strong) IBOutlet UILabel *makersNameLabel;
@property (nonatomic, strong) NSString *makersNameLabelVar;
@property (nonatomic, strong) UIImage *winnersImage;

- (IBAction)back:(id)sender;
@end
