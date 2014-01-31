//
//  KikUserDefaultsProxy.h
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KikUserDefaultsBackend.h"

#define CLASS_TYPE_IS_STRING(type) ([type isEqualToString:NSStringFromClass([NSString class])])
#define CLASS_TYPE_IS_NUMBER(type) (strcmp([type UTF8String], @encode(int)) == 0 || \
                                    strcmp([type UTF8String], @encode(float)) == 0 || \
                                    strcmp([type UTF8String], @encode(double)) == 0)
#define CLASS_TYPE_IS_INT(type)    (strcmp([type UTF8String], @encode(int)) == 0)
#define CLASS_TYPE_IS_FLOAT(type)  (strcmp([type UTF8String], @encode(float)) == 0)
#define CLASS_TYPE_IS_DOUBLE(type) (strcmp([type UTF8String], @encode(double)) == 0)
#define CLASS_TYPE_IS_BOOL(type)   (strcmp([type UTF8String], @encode(BOOL)) == 0)

/**
 * @brief The KikUserDefaultsProxy interface acts as a mediary between
 * the client and backend and allows NSDefaults to be created and handled
 * automatically.
 */
@interface KikUserDefaultsProxy : NSProxy
{
    KikUserDefaultsBackend *_backend;
    
    // Cache property name <> property type. This speeds up the lookup for
    // determining the type of a property.
    NSMutableDictionary *_cachePropertyNamesToTypes;
    
    // Cache selector <> property name. This speeds up the lookup for determing a
    // property name based on selector.
    //
    // Example: method call:   proxy.testProperty
    //          selector:      @selector(testProperty)
    //          property name: @"testProperty"
    NSMutableDictionary *_cacheSelectorToPropertyName;
    
    // Cache type selector <> property selector. This speeds up the lookup for a
    // property based selector.
    //
    // Example: method call:   proxy.testProperty = 6 (where testProperty is an int)
    //          selector:      @selector(setTestProperty:)
    //          type selector: @selector(setInt:forKey:)
    NSMutableDictionary *_cacheTypeSelectorForPropertySelector;
}

- (id)initWithKikUserDefaultsBackend:(KikUserDefaultsBackend *)backend;

- (void)setDefaultValue:(NSObject *)object forProperty:(NSString *)property;

@end

@interface KikUserDefaultsProxy (Special)

- (void)removeProperties:(NSArray *)properties;

- (NSString *)typeForProperty:(NSString *)property;

- (void)resetDefaults;

- (id)observeProperty:(NSString *)property
         withCallback:(userDefaultsPropertyCallback_t)callback;

- (void)stopWatchingPropertyWithNotificationIdentifer:(id)observerIdentifier;

- (NSDictionary *)dictionaryRepresentation;

@end
