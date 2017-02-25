//
//  ListViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ListViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *costumeElementsArray;
    NSMutableDictionary *dictOfCostumeElements;
    NSMutableDictionary *thumbnailCache;
    UIImage *selectedFullImage;
}

@property(strong,nonatomic) NSMutableArray *costumeElementsArray;
@property(strong,nonatomic) UIImage *selectedFullImage;
@property (readonly, strong, nonatomic) NSString* documentsPath;


-(NSString*)findDB;
@end
