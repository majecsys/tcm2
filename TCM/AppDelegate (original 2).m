//
//  AppDelegate.m
//  TCM
//
//  Created by Ed Guinn on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "NSDictionary+SafeAccess.h"

@implementation AppDelegate

//@synthesize window = _window;
@synthesize documentsPath;
@synthesize db;
@synthesize arryCostumeElements;
@synthesize dictOfAllReturnedJsonValues;
@synthesize dictPathToImages;
@synthesize arrayOfPaths;


-(NSDate *) formatDates:(NSString *)stringDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //this is the sqlite's format
    NSDate *date = [formatter dateFromString:stringDate];
    
    return date;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //initializations
    documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.db = [documentsPath stringByAppendingPathComponent:@"TCM.sqlite"];
    
    if ([self checkOrDownloadBundleDB]) {
        [self getDatesAndProcessReturnedRemoteData];
    }
    else {
        //if there was no db then get the latest data and create the sub dirs etc.
      //  [self createDirAndCopyFiles];
        [self getDatesAndProcessReturnedRemoteData];
    }    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFirstViewController:) name:@"showFirstView" object:nil];
    return YES;
}

- (void)showFirstViewController:(NSNotification *)aNotification
{
    //this section was designed to overide the default firstview controller shown in the storyboard
    
//    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//    
//    UIViewController *viewController  = [storyboard instantiateViewControllerWithIdentifier: @"firstViewController"];
//    // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:<storyboard id>];
//    self.window.rootViewController = viewController;
//    [self.window makeKeyAndVisible];
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL)checkOrDownloadBundleDB{
    
    BOOL downloadBundleDB;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.db];
    
    if (!fileExists) {
        [self createDirAndCopyFiles];
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:db];
        [fileManager copyItemAtPath:defaultDBPath toPath:db error:&error];
        return downloadBundleDB = YES;
    }
    else {
        return downloadBundleDB = NO;
    }
}
- (void)createDirAndCopyFiles
{
    BOOL success;
    BOOL isDir;
    NSString *pathToInitialImages = [documentsPath stringByAppendingPathComponent:@"initialimages"];
    NSFileManager *fileManager = [NSFileManager defaultManager];	
    success = [fileManager fileExistsAtPath:pathToInitialImages isDirectory:&isDir];
    
    if (!success) {
        [self makeDocumentSubdir:@"initialimages"];
        [self makeDocumentSubdir:@"resizedImageDir"];
        
        NSArray* myImages = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil];
        NSEnumerator *enumerator = [myImages objectEnumerator];
        id anObject;
        
        while ((anObject = [enumerator nextObject])) {
            //	NSLog(@"initial imgs: %@",[anObject lastPathComponent]);
            [self copyFileNamed:[anObject lastPathComponent] intoDocumentsSubfolder:@"initialimages"];
        }
    }
    else
        NSLog(@"Directory exisit no need to recreate here");
}

- (BOOL)makeDocumentSubdir:(NSString *)subdirname
{
	// First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // create the directory path name for the subdirectory
	NSString *subdirectory = nil;
    subdirectory = [self.documentsPath stringByAppendingPathComponent:subdirname];
    success = [fileManager createDirectoryAtPath:subdirectory withIntermediateDirectories:YES attributes:nil error:NULL ];
    return success;
}
- (void)copyFileNamed:(NSString *)filename intoDocumentsSubfolder:(NSString *)dirname
{
	// First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = NULL;
    // set up the directory path name for the subdirectory
    NSString *subdirectory = [self.documentsPath stringByAppendingPathComponent:dirname];
	
    // set up the full path for the destination file
    NSString *writableFilePath = [subdirectory stringByAppendingPathComponent:filename];
    success = [fileManager fileExistsAtPath:writableFilePath];
	
    // if the file is already there, just return
    if (success)
		return;
    // The file not exist, so copy it to the documents flder.
    NSString *defaultFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    success = [fileManager copyItemAtPath:defaultFilePath toPath:writableFilePath error:&error];
    if (!success) {
		//[self alert:@"Failed to copy resource file"];
		NSLog(@"Failed to copy file to documents with message '%@'.",error);
		//NSAssert1(0, @"Failed to copy file to documents with message '%@'.", [error localizedDescription]);
    }
}


#pragma mark - updating with latest data routines

-(void) syncLocalAndRemoteDB{
    
}
-(void) getDatesAndProcessReturnedRemoteData{
    
    //locals vars
    NSString *maxDateUploadedinCostumes = nil;
    __block NSArray *arryElements;

    
    FMDatabase* thisDB = [FMDatabase databaseWithPath:[self findDB]];    
//    [thisDB setTraceExecution:TRUE];
    
    if (![thisDB open]) {
        NSLog(@"Could not open db.");
    }  
//    thisDB.logsErrors = YES;
    
    FMResultSet *rs = [thisDB executeQuery:@"select max(DATEUPLOADED) from Costumes",  nil];    
    while ([rs next]) {
        maxDateUploadedinCostumes = [rs stringForColumn:@"max(dateuploaded)"];
    }
    
//    if ([thisDB hadError]) {
//        NSLog(@"DB Error %d: %@", [thisDB lastErrorCode], [thisDB lastErrorMessage]); }
    [rs close];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appaccess:0821mcg@174.143.175.219:9856/TCM/returnLatest.php?ts=%@",[maxDateUploadedinCostumes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    NSLog(@"URL %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request    
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) { 
        NSDictionary *results = [json valueForKeyPath:@"newCostumeElements"];
        arryElements = [results valueForKey:@"dateuploaded"];
 //       NSLog(@"The arryElements was %@",arryElements);
        BOOL hasNewData = NO;        
        if (arryElements.count > 0) {
            hasNewData = YES;            
        }
        else {
            hasNewData = NO;
        }        
        [self updateLocalData:hasNewData withThisData:json];
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
        //this would show no change if there was nothing new
     //   NSLog(@" get getDatesAndProcessReturnedRemoteData The error was %@",error);
    }];

    [operation start];        
    [thisDB close];   
}

- (void) updateLocalData:(BOOL)hasNewData withThisData:(NSString *)json {
    
    if (hasNewData) {
        [self startUpdateProcess:json];        
    }
    else {
        NSLog(@"nothing changes so figure out whats next %d",hasNewData);
    }
}

-(NSMutableArray *)createArrayOfImages:(NSString*)json
{
    arrayOfPaths  = [[NSMutableArray alloc] init];
    
 //   NSArray *testArray  = (NSArray *)[json valueForKey:@"newCostumeElements"];
    
    
    
    arryCostumeElements = (NSArray *)[json valueForKey:@"newCostumeElements"];
    for (NSDictionary *item in arryCostumeElements)
    {
        NSMutableDictionary *listOfPaths=[[NSMutableDictionary alloc] init];

        [listOfPaths setObject:[item objectForKey:@"tnpath"] forKey:@"tnpath"];
        [listOfPaths setObject:[item objectForKey:@"fullpath"] forKey:@"fullpath"];
        
        if ([[item stringForKey:@"ip_fullpath"] length] != 0 ){
        [listOfPaths setObject:[item objectForKey:@"ip_fullpath"] forKey:@"ip_fullpath"];
        }
        
        if ([[item stringForKey:@"ip_tnpath"] length] != 0 ) {
        [listOfPaths setObject:[item objectForKey:@"ip_tnpath"] forKey:@"ip_tnpath"];
        }
        
        
        [listOfPaths setObject:[item objectForKey:@"makersname"] forKey:@"makersname"];
        [listOfPaths setObject:[item objectForKey:@"dateuploaded"] forKey:@"dateuploaded"];
        [listOfPaths setObject:[item objectForKey:@"id"] forKey:@"id"];
        
        [arrayOfPaths addObject:listOfPaths];
    }
    return arrayOfPaths;
//    NSLog(@"array %@",arrayOfPaths);   
}

- (void)startUpdateProcess: (NSString *)json{
    
    NSString *ip_fullPath = @"";
    NSString *ip_tnPath = @"";
    NSString *tnPath = @"";
    NSString *fullPath = @"";
    
//    [self arrayTest:json];
    
    FMDatabase* thisDB = [FMDatabase databaseWithPath:[self findDB]];    
 //   [thisDB setTraceExecution:TRUE];
    if (![thisDB open]) {
        NSLog(@"Could not open db.");
    }        
    arryCostumeElements = (NSArray *)[json valueForKey:@"newCostumeElements"];
    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    for(int i=0; i < [arryCostumeElements count] - 1; i += 2)
//    {
//        [dictionary setObject:[arryCostumeElements objectAtIndex:i+1] forKey:[arryCostumeElements objectAtIndex: i]];
//    }
//    
//    [self createPathToImagesDictionary:dictionary];
    
    int ndx;
    for (ndx = 0; ndx <  arryCostumeElements.count ; ndx++) {
        dictOfAllReturnedJsonValues = (NSMutableDictionary *)[arryCostumeElements objectAtIndex:ndx];
        
        if ([dictOfAllReturnedJsonValues valueForKey:@"tnpath"] != [NSNull null]){
            tnPath = [[dictOfAllReturnedJsonValues valueForKey:@"tnpath"] lastPathComponent];
        }
        else{
            tnPath = @"";
        }
        if ([dictOfAllReturnedJsonValues valueForKey:@"fullpath"] != [NSNull null]) {
            fullPath = [[dictOfAllReturnedJsonValues valueForKey:@"fullpath"] lastPathComponent];
        }
        else{
            fullPath = @"";
        }
        if ([dictOfAllReturnedJsonValues objectForKey:@"ip_fullpath"] != [NSNull null] ) {
            ip_fullPath = [[dictOfAllReturnedJsonValues valueForKey:@"ip_fullpath"] lastPathComponent];
        }
        else{
            ip_fullPath = @"";
        }
        if ([dictOfAllReturnedJsonValues objectForKey:@"ip_tnpath"] != [NSNull null]) {
            ip_tnPath = [[dictOfAllReturnedJsonValues valueForKey:@"ip_tnpath"] lastPathComponent];
        }
        else{
            ip_tnPath = @"";
        }
        NSString *rowID = [dictOfAllReturnedJsonValues valueForKey:@"id"];
        NSString *makersName = [dictOfAllReturnedJsonValues valueForKey:@"makersname"];
        NSString *dateUploaded = [dictOfAllReturnedJsonValues valueForKey:@"dateuploaded"];
 //       [thisDB setTraceExecution:TRUE];
        [thisDB executeUpdate:@"insert into costumes values(?,?,?,?,?,?,?)",rowID,dateUploaded,tnPath,fullPath,makersName,ip_fullPath,ip_tnPath];
        
    }
    [self createPathToImagesDictionary:[self createArrayOfImages:json]];
}

- (void)createPathToImagesDictionary:(NSMutableArray *) arrayOfJsonValues {
    
    NSMutableArray *localArrayOfPaths = [[NSMutableArray alloc] init];   
    for (NSMutableDictionary *pathElement in arrayOfJsonValues){
        NSMutableDictionary *localDictPathToImages=[[NSMutableDictionary alloc] init];
        
        if ([[pathElement stringForKey:@"ip_fullpath"] length] != 0 ){
            [localDictPathToImages setObject:[[pathElement stringForKey:@"ip_fullpath"]substringFromIndex:5] forKey:@"ip_fullpath"];
        }
        if ([[pathElement stringForKey:@"ip_tnpath"] length] != 0 ){
            [localDictPathToImages setObject:[[pathElement stringForKey:@"ip_tnpath"]substringFromIndex:5] forKey:@"ip_tnpath"];
        }
        if ([[pathElement stringForKey:@"tnpath"] length] != 0 ){
        [localDictPathToImages setObject:[[pathElement stringForKey:@"tnpath"] substringFromIndex:5] forKey:@"tnpath"];
        }
        if ([[pathElement stringForKey:@"fullpath"] length] != 0 ){
        [localDictPathToImages setObject:[[pathElement stringForKey:@"fullpath"] substringFromIndex:5] forKey:@"fullpath"];
        }
        [self downloadImages:localDictPathToImages];        
        [localArrayOfPaths addObject:localDictPathToImages];
    }
    
//        NSLog(@"localArrayOfPaths %@",localArrayOfPaths);
    
//    int ndx;
//    for (ndx = 0; ndx <  localArrayOfPaths.count ; ndx++) {
//        NSArray *firstSplit = [[localArrayOfPaths objectAtIndex:ndx]  componentsSeparatedByString:@"="];
//        NSString *msg = [firstSplit lastObject];
//        NSLog(@"values in dictPathToImages %@",msg);
//    }
    
//    NSEnumerator *enumerator = [localArrayOfPaths objectEnumerator];
//    id value;
//    while ((value = [enumerator nextObject])) {
//        
//        NSArray *firstSplit = [value componentsSeparatedByString:@"="];
//        NSAssert(firstSplit.count == 2, @"Oops! Parsed string had more than one |, no message or no numbers.");
//        NSString *msg = [firstSplit lastObject];
////        if ([value length] !=0) {
////            NSString *path = [value substringFromIndex:5] ;
////
////      //      [self downloadImages: path];
//             NSLog(@"values in dictPathToImages %@",msg);
//    }


    

//    [self downloadImages:dictPathToImages];
//    
//    NSEnumerator *enumerator = [dictPathToImages objectEnumerator];
//    id value;
//    
//    while ((value = [enumerator nextObject])) {
//        if (![value isEqual: @""]) {
//            NSString *path = [value substringFromIndex:5] ;
//////            [self downloadImages: path];
//               NSLog(@"values in dictPathToImages %@",path);
//        } else {
//            //   NSLog(@"There is no path returned in dictPAthToimages");
//        }
//    }
}

- (BOOL)downloadImages: (NSMutableDictionary *) pathToImageDictionary{
    int count = [pathToImageDictionary count];
    NSMutableArray *operationsArray = [NSMutableArray array];
    NSMutableArray *localPathToimageArray = [[NSMutableArray alloc] initWithCapacity:count];

    NSEnumerator *enumerator = [pathToImageDictionary objectEnumerator];
    id value;    

    while ((value = [enumerator nextObject])) {
        if (![value isEqual: @""]) {
            NSArray *arr = [value componentsSeparatedByString:@"="];
            NSString *valueAfterEquals = [arr objectAtIndex:0];
          [localPathToimageArray addObject:valueAfterEquals];
        }
    }

    NSEnumerator *enumObjectsInlocalPathToimageArray = [localPathToimageArray objectEnumerator];
    id valueOfPath;
    
    while ((valueOfPath = [enumObjectsInlocalPathToimageArray nextObject]) != nil) {

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appaccess:0821mcg@174.143.175.219:9856/TCM/%@",valueOfPath]];
//        NSLog(@"url -- %@",url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFImageRequestOperation *getOperation = [AFImageRequestOperation imageRequestOperationWithRequest:request  imageProcessingBlock:nil

          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
              [self writeImagesInInitialImages:image pathOfFile:valueOfPath];
 //             NSLog(@"Writing this file in initial images dir -- %@",valueOfPath);
          }
          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
              NSLog(@"Error from downloadimages is %@",error);
          }];        
        [operationsArray addObject:getOperation];
    }
//    NSLog(@"operationsArray -- %@  ",operationsArray );
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    [client  enqueueBatchOfHTTPRequestOperations:operationsArray
    progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations)
        {
        //    NSLog(@"%d / %d", numberOfFinishedOperations, totalNumberOfOperations);
        }
    completionBlock:^(NSArray *operationsArray)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showFirstView" object:self];
        //    NSLog(@"Yikesssssśssssssssssss");
        }];
   return YES;
}

- (void) writeImagesInInitialImages: (UIImage*)img pathOfFile:(NSString *)pof{
    
 //   NSData * data = [NSData dataWithContentsOfFile:img];
    NSData *data = UIImagePNGRepresentation(img);
    BOOL success;
    BOOL isDir;
    NSString *pathToInitialImages = [documentsPath stringByAppendingPathComponent:@"initialimages"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:pathToInitialImages isDirectory:&isDir];
    if (!success) {
        
        if ([self makeDocumentSubdir:@"initialimages"]) {
                    [fileManager createFileAtPath:[pathToInitialImages stringByAppendingPathComponent:[pof lastPathComponent]] contents:data attributes:nil];
                } else {
                    NSLog(@"unable to create initialimages dir");
                       }
            } else {
	                    [fileManager createFileAtPath:[pathToInitialImages stringByAppendingPathComponent:[pof lastPathComponent]] contents:data attributes:nil];
//                    NSLog(@"pathToImage : %@", pof);
                    }
}


-(NSString*)findDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;    
    documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"TCM.sqlite"];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TCM.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success) {
            NSLog(@"Failed to create writable DB. Error '%@'.", [error localizedDescription]);
        } else {
//            NSLog(@"DB copied.");
        }
    }else {
     //   NSLog(@"DB exists, no need to copy.");
    }
    return dbPath;
}

#pragma mark - Core Data stack


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
