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
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *viewController  = [storyboard instantiateViewControllerWithIdentifier: @"initialTabBarController"];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
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
        //   NSLog(@"initial imgs: %@",[anObject lastPathComponent]);
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

//-(void) syncLocalAndRemoteDB{}

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
    [rs close];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appaccess:0821mcg@174.143.175.219:9858/TCM/returnLatest.php?ts=%@",[maxDateUploadedinCostumes stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
 //  NSLog(@"url %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:(NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:12.0];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *results = [responseObject valueForKeyPath:@"newCostumeElements"];
            arryElements = [results valueForKey:@"dateuploaded"];
         //   NSLog(@"The arryElements was %@",arryElements);
            NSString *NoChange = @"No Change";
            BOOL hasNewData = NO;
            if ((arryElements.count > 0) && (![arryElements  containsObject:NoChange])) {
                hasNewData = YES;
            }
            else {
                hasNewData = NO;
            }
            
            [self updateLocalData:hasNewData withThisData:responseObject];
            //   NSLog(@"in setCompletionBlockWithSuccess %@",results);
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"in ******** failure: %@", error);
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"showFirstView" object:self];
             }];
    
    [operation start];        
    [thisDB close];   
}

- (void) updateLocalData:(BOOL)hasNewData withThisData:(NSString *)json {
    if (hasNewData) {
        [self startUpdateProcess:json];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showFirstView" object:self];
        //  NSLog(@"nothing changes so figure out whats next %d",hasNewData);
    }
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
//        [thisDB executeUpdate:@"insert into costumes values(?,?,?,?,?,?)",dateUploaded,tnPath,fullPath,makersName,ip_fullPath,ip_tnPath];
    }
    [self createPathToImagesDictionary:[self createArrayOfImages:json]];
}

-(NSMutableArray *)createArrayOfImages:(NSString*)json
{
    arrayOfPaths  = [[NSMutableArray alloc] init];

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
}

- (void)createPathToImagesDictionary:(NSMutableArray *) arrayOfJsonValues {
    NSInteger count = [arrayOfJsonValues count];
//    NSLog(@"values in arrayOfJsonValues %@",arrayOfJsonValues);
    NSMutableArray *localArrayOfPaths = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *pathElement in arrayOfJsonValues){
            NSMutableDictionary *localDictPathToImages=[[NSMutableDictionary alloc] initWithCapacity:count];
        if ([[pathElement stringForKey:@"ip_fullpath"] length]!= 0 ){
            [localDictPathToImages setValue:[[pathElement stringForKey:@"ip_fullpath"]substringFromIndex:5] forKey:@"ip_fullpath"];
        }
        if ([[pathElement stringForKey:@"ip_tnpath"] length] != 0 ){
            [localDictPathToImages setValue:[[pathElement stringForKey:@"ip_tnpath"]substringFromIndex:5] forKey:@"ip_tnpath"];
        }
        if ([[pathElement stringForKey:@"tnpath"] length] != 0 ){
        [localDictPathToImages setValue:[[pathElement stringForKey:@"tnpath"] substringFromIndex:5] forKey:@"tnpath"];
        }
        if ([[pathElement stringForKey:@"fullpath"] length] != 0 ){
        [localDictPathToImages setValue:[[pathElement stringForKey:@"fullpath"] substringFromIndex:5] forKey:@"fullpath"];
        }
        [localArrayOfPaths addObject:localDictPathToImages];   
    }
//    NSLog(@"values in localArrayOfPaths %@",localArrayOfPaths);

    [self downloadImages:localArrayOfPaths];
}


- (BOOL)downloadImages: (NSMutableArray *) pathToImagearray{
    NSInteger count = [pathToImagearray count];
    NSMutableArray *operationsArray = [NSMutableArray array];
    NSMutableArray *localPathToimageArray = [[NSMutableArray alloc] initWithCapacity:count];
//   NSMutableArray *pathToimagesArray = [[NSMutableArray alloc] initWithCapacity:count];


    NSEnumerator *enumerator = [pathToImagearray objectEnumerator];
    id value;    

    while (value = [enumerator nextObject]) {
        [localPathToimageArray addObject:[value valueForKey:@"fullpath"]];
        [localPathToimageArray addObject:[value valueForKey:@"tnpath"]];       
    }

    NSEnumerator *enumObjectsInlocalPathToimageArray = [localPathToimageArray objectEnumerator];
    id valueOfPath;

    while ((valueOfPath = [enumObjectsInlocalPathToimageArray nextObject]) != nil) {
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://appaccess:0821mcg@174.143.175.219:9858/TCM/%@",valueOfPath]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *getOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        getOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [getOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self writeImagesInInitialImages:responseObject pathOfFile:valueOfPath];
            //      NSLog(@"value Of Path valueOFPath ID %@",valueOfPath);
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [operationsArray addObject:getOperation];
    }
    
    NSArray *batchOperations = [AFURLConnectionOperation batchOfRequestOperations:operationsArray
                               progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations)
            {
                if(numberOfFinishedOperations == totalNumberOfOperations)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"showFirstView" object:self];
                }
            }
          completionBlock:^(NSArray *operationsArray) {
              NSLog(@"Entering NSNotificationCenter");
              [[NSNotificationCenter defaultCenter] postNotificationName:@"showFirstView" object:self];
          }];
    [[NSOperationQueue mainQueue] addOperations:batchOperations waitUntilFinished:NO];
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
