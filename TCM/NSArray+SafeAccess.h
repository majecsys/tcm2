//
//  NSArray+SafeAccess_h.h
//  TCM
//
//  Created by Ed Guinn on 6/25/13.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (SafeAccess)

- (instancetype)withoutNulls;
- (instancetype)arrayByRemovingObjectsOfClass:(id)obj;

- (id)objectAtIndex:(NSUInteger)index ifKindOf:(Class)kind;
- (id)objectAtIndex:(NSUInteger)index ifKindOf:(Class)kind defaultValue:(id)defaultValue;

- (NSArray*)arrayAtIndex:(NSUInteger)index;
- (NSArray*)arrayAtIndex:(NSUInteger)index defaultValue:(NSArray*)defaultValue;
- (NSDictionary*)dictionaryAtIndex:(NSUInteger)index;
- (NSDictionary*)dictionaryAtIndex:(NSUInteger)index defaultValue:(NSDictionary*)defaultValue;
- (NSString*)stringAtIndex:(NSUInteger)index;
- (NSString*)stringAtIndex:(NSUInteger)index defaultValue:(NSString*)defaultValue;
- (NSNumber*)numberAtIndex:(NSUInteger)index;
- (NSNumber*)numberAtIndex:(NSUInteger)index defaultValue:(NSNumber*)defaultValue;
// -boolAtIndex: is not provided. You are the owner of your default value mistakes.
- (BOOL)boolAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue;
- (NSDate*)dateAtIndex:(NSUInteger)index;
- (NSDate*)dateAtIndex:(NSUInteger)index defaultValue:(NSDate*)defaultValue;

@end
