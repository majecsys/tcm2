//
//  AppDelegate.h
//  TCM
//
//  Created by Ed Guinn on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
   // FMDatabase *db;
    NSArray *arryCostumeElements;
    NSMutableDictionary *dictPathToImages;
    NSMutableArray *arrayOfPaths;
}



@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSString* documentsPath;
@property (strong, nonatomic) NSString *db;
@property (strong, nonatomic) NSArray *arryCostumeElements;
@property (strong, nonatomic) NSMutableDictionary *dictOfAllReturnedJsonValues;
@property (strong, nonatomic) NSMutableDictionary *dictPathToImages;
@property (nonatomic, strong) NSMutableArray *arrayOfPaths;


- (NSURL *)applicationDocumentsDirectory;
- (BOOL)checkOrDownloadBundleDB;
- (void)createDirAndCopyFiles;
- (BOOL)makeDocumentSubdir:(NSString *)subdirname;
- (void)copyFileNamed:(NSString *)filename intoDocumentsSubfolder:(NSString *)dirname;
- (NSString*)findDB;
//- (BOOL)downloadImages: (NSMutableArray *) pathToImageArray;
- (NSMutableArray *)createArrayOfImages:(NSString*)json;
- (NSDate *) formatDates:(NSString *)stringDate;

- (void) getDatesAndProcessReturnedRemoteData;
- (void) writeImagesInInitialImages: (UIImage*)img pathOfFile:(NSString *)pof;
@end
