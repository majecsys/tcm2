//
//  NSDictionary+SafeAccess.m
//  TCM
//
//  Created by Ed Guinn on 6/25/13.
//
//

#import "NSDictionary+SafeAccess.h"

@implementation NSDictionary (SafeAccess)

- (instancetype)withoutNulls
{
    NSMutableDictionary* replaced = [NSMutableDictionary dictionaryWithDictionary:self];
    NSString* blank = @"";
    
    for(NSString* key in self)
    {
        id object = [self objectForKey:key];
        if([object isKindOfClass:[NSNull class]] == YES)
            [replaced setObject:blank forKey:key];
        else if([object isKindOfClass:[NSDictionary class]] == YES)
            [replaced setObject:[(NSDictionary*)object withoutNulls] forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}

- (id)objectForKey:(id)key ifKindOf:(Class)kind
{
    return [self objectForKey:key ifKindOf:kind defaultValue:nil];
}

- (id)objectForKey:(id)key ifKindOf:(Class)kind defaultValue:(id)defaultValue
{
    id obj = self[key];
    return [obj isKindOfClass:kind] ? obj : defaultValue;
}

#pragma mark - Type specific helpers

- (NSArray*)arrayForKey:(id)key
{
    return [self arrayForKey:key defaultValue:@[]];
}

- (NSArray*)arrayForKey:(id)key defaultValue:(NSArray*)defaultValue
{
    return [self objectForKey:key ifKindOf:[NSArray class] defaultValue:defaultValue];
}

- (NSDictionary*)dictionaryForKey:(id)key
{
    return [self dictionaryForKey:key defaultValue:@{}];
}

- (NSDictionary*)dictionaryForKey:(id)key defaultValue:(NSDictionary*)defaultValue
{
    return [self objectForKey:key ifKindOf:[NSDictionary class] defaultValue:defaultValue];
}

- (NSString*)stringForKey:(id)key
{
    return [self stringForKey:key defaultValue:@""];
}

- (NSString*)stringForKey:(id)key defaultValue:(NSString*)defaultValue
{
    return [self objectForKey:key ifKindOf:[NSString class] defaultValue:defaultValue];
}

- (NSNumber*)numberForKey:(id)key
{
    return [self numberForKey:key defaultValue:nil];
}

- (NSNumber*)numberForKey:(id)key defaultValue:(NSNumber*)defaultValue
{
    return [self objectForKey:key ifKindOf:[NSNumber class] defaultValue:defaultValue];
}

- (BOOL)boolForKey:(id)key defaultValue:(BOOL)defaultValue
{
    NSNumber* defVal = @(defaultValue);
    return [[self objectForKey:key ifKindOf:[NSNumber class] defaultValue:defVal] boolValue];
}

- (NSDate*)dateForKey:(id)key
{
    return [self dateForKey:key defaultValue:nil];
}

- (NSDate*)dateForKey:(id)key defaultValue:(NSDate*)defaultValue
{
    return [self objectForKey:key ifKindOf:[NSDate class] defaultValue:defaultValue];
}

@end
