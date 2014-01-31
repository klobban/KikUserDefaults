//
//  KikUserDefaultsBackend.h
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_DEFAULTS_NOTIFICATION_TEMPLATE @"KikUserDefaults_%@"

typedef void (^userDefaultsPropertyCallback_t)(id value);

/**
 * @brief The backend is responsible for getting and setting the user defaults
 * from NSDefaultsHelperProxy.
 */
@interface KikUserDefaultsBackend : NSObject
{
    /**
     * @brief Map property name to notification identifiers.
     */
    NSMutableDictionary *_propertyNotifications;
}

@property (nonatomic, readonly) NSMutableDictionary *propertyNotifications;

// Primitive Types

- (BOOL)boolForKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;

- (int)intForKey:(NSString *)key;
- (void)setInt:(int)value forKey:(NSString *)key;

- (double)doubleForKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;

- (float)floatForKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;

// Objects

- (NSString *)stringForKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key;

- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (void)setDictionary:(NSString *)value forKey:(NSString *)key;

- (NSNumber *)numberForKey:(NSString *)key;
- (void)setNumber:(NSNumber *)value forKey:(NSString *)key;

- (NSDate *)dateForKey:(NSString *)key;
- (void)setDate:(NSDate *)value forKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key;
- (void)setArray:(NSArray *)value forKey:(NSString *)key;

- (NSURL *)urlForKey:(NSString *)key;
- (void)setURL:(NSURL *)value forKey:(NSString *)key;

// Helpers

- (void)removeObjectsForKeys:(NSArray *)keys;

- (NSString *)typeForProperty:(NSString *)property;

- (id)observeProperty:(NSString *)property
         withCallback:(userDefaultsPropertyCallback_t)callback;

- (void)stopWatchingPropertyWithNotificationIdentifer:(id)observerIdentifier;

- (NSDictionary *)dictionaryRepresentationForProperties:(NSArray *)properties;

@end
