//
//  KikUserDefaultsBackend.m
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "KikUserDefaultsBackend.h"
#import "KikUserDefaultsProxy.h"

@implementation KikUserDefaultsBackend

@synthesize propertyNotifications = _propertyNotifications;

- (id)init
{
    if (self = [super init]) {
        _propertyNotifications = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    // Remove any dangling notifiers.
    for (NSString *property in [_propertyNotifications allKeys]) {
        for (id notificationIdentifer in _propertyNotifications[property]) {
            [[NSNotificationCenter defaultCenter] removeObserver:notificationIdentifer];
        }
    }
}

#pragma mark -
#pragma mark Primitive Types

- (BOOL)boolForKey:(NSString *)key;
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}

- (int)intForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (void)setInt:(int)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

- (double)doubleForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
}

- (float)floatForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
}

#pragma mark -
#pragma mark Objects

- (NSString *)stringForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

- (void)setString:(NSString *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}

- (void)setDictionary:(NSString *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSNumber *)numberForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setNumber:(NSNumber *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSDate *)dateForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setDate:(NSDate *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSArray *)arrayForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

- (void)setArray:(NSArray *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSURL *)urlForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:key];
}

- (void)setURL:(NSURL *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setURL:value forKey:key];
}

#pragma mark -
#pragma mark Helpers

/**
 * @brief Given a list of keys, remove the objects associated with them in NSUserDefaults.
 */
- (void)removeObjectsForKeys:(NSArray *)keys
{
    // Remove all keys.
    for (NSString *key in keys) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)typeForProperty:(NSString *)type
{
    return type;
}

/**
 * @brief Be notified of changes to a property through a callback block. The object returned
 * is the notification identifier object, which can be used to unregister from the notification
 * center (used with stopWatchingPropertyWithNotificationIdentifier:).
 */
- (id)observeProperty:(NSString *)property
         withCallback:(userDefaultsPropertyCallback_t)callback
{
    id notificationIdentifier = [[NSNotificationCenter defaultCenter] addObserverForName:[NSString stringWithFormat:USER_DEFAULTS_NOTIFICATION_TEMPLATE, property]
                                                                                  object:nil
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note) {
                                                                                  callback(note.userInfo[property]);
                                                                              }];
    
    NSMutableArray *notifierArray = _propertyNotifications[property];
    
    if (notifierArray == nil) {
        notifierArray = [NSMutableArray arrayWithObject:notificationIdentifier];
    } else {
        [notifierArray addObject:notifierArray];
    }
    
    _propertyNotifications[property] = notifierArray;
    
    return notificationIdentifier;
}

/**
 * @brief Given a notification identifier, remove the observer from the notification center.
 * The notification identifier must be a valid observer returned by the observeProperty: method.
 */
- (void)stopWatchingPropertyWithNotificationIdentifer:(id)observerIdentifier
{
    // Find and remove the notification identifier from the notification array associated
    // with the property entry.
    for (NSString *property in [_propertyNotifications allKeys]) {
        NSMutableArray *notifierArray = _propertyNotifications[property];
        
        if ([notifierArray containsObject:observerIdentifier]) {
            [notifierArray removeObject:observerIdentifier];
            
            if (notifierArray.count == 0) {
                // If this was the last notification identifier, we can remove the
                // property from the dictionary. This will stop notifications from being sent.
                [_propertyNotifications removeObjectForKey:property];
                break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:observerIdentifier];
}

/**
 * @brief Return a dictionary of property names to values.
 */
- (NSDictionary *)dictionaryRepresentationForProperties:(NSArray *)properties
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (NSString *property in properties) {
        id value = [[NSUserDefaults standardUserDefaults] objectForKey:property];
        
        if (value) {
            dictionary[property] = value;
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
