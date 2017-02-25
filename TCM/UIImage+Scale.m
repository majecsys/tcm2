//
//  UIImage+Scale.m
//  TCM
//
//  Created by Ed Guinn on 6/1/13.
//
//

#import "UIImage+Scale.h"

@implementation UIImage (scale)


-(UIImage*)scaleToSize:(CGSize)size scale:(CGFloat)scale
{
    // Create a bitmap graphics context
    // This will also set it as the current context
 //   UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, (scale /= 2));
    
    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

@end
