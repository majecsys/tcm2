//
//  WriteDateAndUserImgToPlist.h
//  cMeowCamera
//
//  Created by Ed Guinn on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class catCameraController;

@interface WriteDateAndUserImgToPlist : UIView {

	NSString *userImageName;
	NSMutableDictionary *plistDictionary;
	NSArray* paths;
	NSString* plistPath;
}
//+(WriteDateAndUserImgToPlist *) sharedPlistAccess;

@property (nonatomic, retain) NSString *userImageName;
@property (nonatomic, retain) NSMutableDictionary *plistDictionary;
@property (nonatomic, retain) NSArray* paths;
@property (nonatomic, retain) NSString* plistPath;

-(void) writeUserImageToDocDir:(UIImage *)userImg;
-(BOOL) writeInfoToPlistAndWriteFile:(NSDate *) setDate,...;
-(BOOL) writeToPlist:(NSDate *)timestamp :(NSString*)img ;
-(NSDictionary *) readPlist;
	
 

@end
