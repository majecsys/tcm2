//
//  Ipad_ListViewControllerViewController.h
//  TCM
//
//  Created by Ed Guinn on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ipad_ListViewControllerViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *costumeElementsArray;
    NSMutableDictionary *dictOfCostumeElements;
}

@property(strong,nonatomic) NSMutableArray *costumeElementsArray;
@property (readonly, strong, nonatomic) NSString* documentsPath;


-(NSString*)findDB;
@end
