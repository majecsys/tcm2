//
//  NSDictionary+SafeAccess.h
//  TCM
//
//  Created by Ed Guinn on 6/25/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeAccess)

- (instancetype)withoutNulls;

- (id)objectForKey:(id)key ifKindOf:(Class)kind;
- (id)objectForKey:(id)key ifKindOf:(Class)kind defaultValue:(id)defaultValue;

- (NSArray*)arrayForKey:(id)key;
- (NSArray*)arrayForKey:(id)key defaultValue:(NSArray*)defaultValue;
- (NSDictionary*)dictionaryForKey:(id)key;
- (NSDictionary*)dictionaryForKey:(id)key defaultValue:(NSDictionary*)defaultValue;
- (NSString*)stringForKey:(id)key;
- (NSString*)stringForKey:(id)key defaultValue:(NSString*)defaultValue;
- (NSNumber*)numberForKey:(id)key;
- (NSNumber*)numberForKey:(id)key defaultValue:(NSNumber*)defaultValue;
// -boolForKey: is not provided. You are the owner of your default value mistakes.
- (BOOL)boolForKey:(id)key defaultValue:(BOOL)defaultValue;
- (NSDate*)dateForKey:(id)key;
- (NSDate*)dateForKey:(id)key defaultValue:(NSDate*)defaultValue;

@end