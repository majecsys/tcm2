//
//  WriteDateAndUserImgToPlist.m
//  cMeowCamera
//
//  Created by Ed Guinn on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "SynthesizeSingleton.h"
#import "WriteDateAndUserImgToPlist.h"


@implementation WriteDateAndUserImgToPlist
//SYNTHESIZE_SINGLETON_FOR_CLASS(WriteDateAndUserImgToPlist);
@synthesize userImageName,plistDictionary,paths,plistPath;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		BOOL plistExist = NO;
		BOOL success;
		NSError *error;
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *plistFileName = @"userData.plist";	
		// Get the path to the documents directory and append the databaseName
		self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *pathToDocumentDir = [paths objectAtIndex:0];

		NSString *pathToPlist = [pathToDocumentDir stringByAppendingPathComponent:plistFileName];
	    plistExist = [fileManager fileExistsAtPath:pathToPlist];
		if (plistExist) {
			self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			self.plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"userData.plist"];	
		}
		else
		 {
			self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *plistPathInDocDir = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"userData.plist"];	
			self.plistPath =	[[NSBundle mainBundle] pathForResource:@"userData" ofType:@"plist"];	
			success = [fileManager copyItemAtPath:plistPath toPath:plistPathInDocDir error:&error];
			if (success) {
			//	NSLog(@"plist file was copied");
			}
			
		 }
    }
    return self; 
}

-(BOOL) writeInfoToPlistAndWriteFile:(NSDate *)setDate,...
{
    NSDate *now;
	BOOL didWriteToPlist;
    if(!(setDate == nil)) {
        now = setDate;
    }
    else
    {
          now   = [NSDate date];
     
    }

	
	return didWriteToPlist = [self writeToPlist:now :@"userImage"];	
}

-(void) writeUserImageToDocDir:(UIImage *)userImg
{
	self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [self.paths objectAtIndex:0];
	NSString *filePath = [documentDir stringByAppendingPathComponent:@"/userImage.jpg"];
	NSData *toSave = UIImageJPEGRepresentation(userImg,1.0); //image is a UIImage
	BOOL didWrite = [toSave writeToFile:filePath atomically:YES];
	
	if (didWrite) {
	//	NSLog(@" the file path is %@",filePath);
	}
	else {
		NSLog(@"no path to file");
	}
}


-(BOOL)writeToPlist:(NSDate *)timestamp :(NSString *)img
{	
//	NSDate *now = [NSDate date];
	int minutesToAdd = 1440;  // 1440 minutes is 24 hours
	
	// set up date components
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setMinute:minutesToAdd];
	
//	[components setDay:daysToAdd];
	
	// create a calendar
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDate *newDate2 = [gregorian dateByAddingComponents:components toDate:timestamp options:0];
//	NSLog(@"Clean: %@", newDate2);
	
	BOOL  didWrite;
	plistDictionary = [[NSMutableDictionary alloc] init];
	[plistDictionary setObject:newDate2 forKey:@"24HRStart"];
	[plistDictionary setObject:img forKey:@"userImage"];
	
	return didWrite =[plistDictionary writeToFile:self.plistPath atomically:NO];

//    [newDate2 release];
//    [plistDictionary release];
}

-(NSDictionary *)readPlist{
	NSDictionary *dictionary;
	dictionary = [NSDictionary dictionaryWithContentsOfFile:self.plistPath];
	return dictionary;
}




@end
