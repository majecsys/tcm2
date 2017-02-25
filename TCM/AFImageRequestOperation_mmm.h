//
//  AFImageRequestOperation_mmm.h
//  TCM
//
//  Created by Ed Guinn on 7/4/13.
//
//

#import "AFImageRequestOperation.h"

@interface AFImageRequestOperation ()

@end


NSMutableArray *operationsArray = [NSMutableArray array];
for (NSString *imageURL in imageURLArray) {
    AFImageRequestOperation *getImageOperation =
    [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]
                                         imageProcessingBlock:nil
                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                          //
                                                          // Save image
                                                          //
                                                      }
                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                          if((error.domain == NSURLErrorDomain) && (error.code == NSURLErrorCancelled))
                                                              NSLog(@"Image request cancelled!");
                                                          else
                                                              NSLog(@"Image request error!");
                                                      }];
    [operationsArray addObject:profileImageOperation];
}
//
// Lock user interface by pop-up dialog with process indicator and "Cancel download" button
//
[afhttpClient enqueueBatchOfHTTPRequestOperations:operationsArray
                                    progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                        //
                                        // Handle process indicator
                                        //
                                    } completionBlock:^(NSArray *operations) {
                                        //
                                        // Remove blocking dialog, do next tasks
                                        //
                                    }];