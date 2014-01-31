//
//  KikUserDefaultsProxy.m
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "KikUserDefaultsProxy.h"
#import "objc/runtime.h"

@implementation KikUserDefaultsProxy

- (id)initWithKikUserDefaultsBackend:(KikUserDefaultsBackend *)backend
{
    _backend = backend;
    
    _cachePropertyNamesToTypes            = [[self class] propertyTypesForNames];
    _cacheSelectorToPropertyName          = [[NSMutableDictionary alloc] init];
    _cacheTypeSelectorForPropertySelector = [[NSMutableDictionary alloc] init];
    
    return self;
}

/**
 * @brief Set a default value for a property.
 * @note: Arrays and URLs do not work.
 */
- (void)setDefaultValue:(NSObject *)object
            forProperty:(NSString *)property
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{property : object}];
}

#pragma mark -
#pragma mark Required Inherited Methods

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *methodSignature = [_backend methodSignatureForSelector:aSelector];
    
    if (methodSignature) {
        return methodSignature;
    } else if (aSelector == @selector(resetDefaults) ||
               aSelector == @selector(removeProperties:)) {
        return [_backend methodSignatureForSelector:@selector(removeObjectsForKeys:)];
    } else if (aSelector == @selector(dictionaryRepresentation)) {
        return [_backend methodSignatureForSelector:@selector(dictionaryRepresentationForProperties:)];
    }
    
    return [_backend methodSignatureForSelector:[self typeSelectorForSelector:aSelector]];
}

// Invoke the invocation on whichever real object had a signature for it.
- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation setTarget:_backend];
    
    if ([invocation selector] == @selector(resetDefaults)) {
        NSArray *allProperties = [_cachePropertyNamesToTypes allKeys];
        
        [invocation setSelector:@selector(removeObjectsForKeys:)];
        [invocation setArgument:&allProperties atIndex:2];
        [invocation invoke];
        
        return;
    } else if ([invocation selector] == @selector(removeProperties:)) {
        [invocation setSelector:@selector(removeObjectsForKeys:)];
        [invocation invoke];
        
        return;
    } else if ([invocation selector] == @selector(typeForProperty:)) {
        // Specify the type as the second argument, which will be returned by the backend.
        __unsafe_unretained NSString *property = nil;
        [invocation getArgument:&property atIndex:2];
        
        NSString *type = _cachePropertyNamesToTypes[property];
        [invocation setArgument:&type atIndex:2];
        [invocation invoke];
        
        return;
    } else if ([invocation selector] == @selector(dictionaryRepresentation)) {
        NSMutableArray *allProperties = [NSMutableArray arrayWithArray:[_cachePropertyNamesToTypes allKeys]];
        
        // Also include all of the properties that are stored in NSUserDefaults but not in the properties.
        // This is useful for seeing if we're not releasing user defaults when we should be. Don't worry
        // about duplicate properties -- they're all being used in a dictionary anyway.
        [allProperties addObjectsFromArray:[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]];
        
        [invocation setSelector:@selector(dictionaryRepresentationForProperties:)];
        [invocation setArgument:&allProperties atIndex:2];
        [invocation invoke];
        
        return;
    } else if ([_backend respondsToSelector:[invocation selector]]) {
        [invocation invoke];
        return;
    }
    
    BOOL isSetter = [self selectorIsASetter:[invocation selector]];
    NSString* propertyName = [self propertyNameFromSelector:[invocation selector]];
    
    // Set the selector for the appropriate type.
    [invocation setSelector:[self typeSelectorForSelector:[invocation selector]]];
    
    if (isSetter) {
        [invocation setArgument:&propertyName atIndex:3];
    } else {
        [invocation setArgument:&propertyName atIndex:2];
    }

    [invocation invoke];
    
    if (isSetter) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Fire notification if needed.
        if (_backend.propertyNotifications[propertyName]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:USER_DEFAULTS_NOTIFICATION_TEMPLATE, propertyName]
                                                                object:nil
                                                              userInfo:@{ propertyName : [[NSUserDefaults standardUserDefaults] objectForKey:propertyName] }];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSMethodSignature *methodSignature = [_backend methodSignatureForSelector:aSelector];
    
    if (methodSignature) {
        return YES;
    } else if (aSelector == @selector(resetDefaults) ||
               aSelector == @selector(removeProperties:)) {
        return YES;
    } else if (aSelector == @selector(dictionaryRepresentation)) {
        return YES;
    }
    
    methodSignature = [_backend methodSignatureForSelector:[self typeSelectorForSelector:aSelector]];
    
    return (methodSignature != nil);
}

#pragma mark -
#pragma mark Private Methods

/**
 * @brief Returns YES if the selector begins with "set".
 */
- (BOOL)selectorIsASetter:(SEL)aSelector
{
	return ([NSStringFromSelector(aSelector) hasPrefix:@"set"]);
}

/**
 * @brief Returns the property name for a given selector.
 * Example: proxy.testProperty
 *          selector: @selector(testProperty)
 *          property name: @"testProperty"
 */
- (NSString *)propertyNameFromSelector:(SEL)selector
{
    // Check the cache to see if we've already encountered this selector.
    NSString *propertyName = _cacheSelectorToPropertyName[NSStringFromSelector(selector)];
    
    if (propertyName != nil)
    {
        return propertyName;
    }
    
    propertyName = NSStringFromSelector(selector);
    
    // If the selector is a setter, remove the "set" and make the first character lower case.
	if ([self selectorIsASetter:selector])
    {
		// Remove "set" from selector.
		NSString* signature = [propertyName substringWithRange:NSMakeRange(3, propertyName.length-4)];
        
		// Convert first character to lower case.
		NSString* signatureFirstChar = [[signature substringToIndex:1] lowercaseString];
		NSString* signatureFromSecondChar = [signature substringFromIndex:1];
        
        // Update the property name.
		propertyName = [signatureFirstChar stringByAppendingString:signatureFromSecondChar];
    }
    
    // Update the cache.
    _cacheSelectorToPropertyName[NSStringFromSelector(selector)] = propertyName;
    
    return propertyName;
}

/**
 * @brief Returns the type-based selector for a given selector.
 * Example: method call:   proxy.testProperty = 6 (where testProperty is an int)
 *          selector:      @selector(setTestProperty:)
 *          type selector: @selector(setInt:forKey:)
 *
 */
- (SEL)typeSelectorForSelector:(SEL)selector
{
    // Check if the type selector already exists in the cache.
    NSString *propertySelector = _cacheTypeSelectorForPropertySelector[NSStringFromSelector(selector)];
    
    if (propertySelector != nil) {
        return NSSelectorFromString(propertySelector);
    }
    
    BOOL isSetter = [self selectorIsASetter:selector];
    NSString *rawPropertyType = _cachePropertyNamesToTypes[[self propertyNameFromSelector:selector]];
    SEL typeSelector = nil;
    
    // Given the raw property type, find the appropriate type-based selector.
    if (rawPropertyType) {
        if (strcmp([rawPropertyType UTF8String], @encode(BOOL)) == 0) {
            if (isSetter) {
                typeSelector = @selector(setBool:forKey:);
            } else {
                typeSelector = @selector(boolForKey:);
            }
        } else if (strcmp([rawPropertyType UTF8String], @encode(int)) == 0) {
            if (isSetter) {
                typeSelector = @selector(setInt:forKey:);
            } else {
                typeSelector = @selector(intForKey:);
            }
        } else if (strcmp([rawPropertyType UTF8String], @encode(float)) == 0) {
            if (isSetter) {
                typeSelector = @selector(setFloat:forKey:);
            } else {
                typeSelector = @selector(floatForKey:);
            }
        } else if (strcmp([rawPropertyType UTF8String], @encode(double)) == 0) {
            if (isSetter) {
                typeSelector = @selector(setDouble:forKey:);
            } else {
                typeSelector = @selector(doubleForKey:);
            }
        } else if ([rawPropertyType isEqualToString:NSStringFromClass([NSString class])]) {
            if (isSetter) {
                typeSelector = @selector(setString:forKey:);
            } else {
                typeSelector = @selector(stringForKey:);
            }
        } else if ([rawPropertyType isEqualToString:NSStringFromClass([NSDictionary class])]) {
            if (isSetter) {
                typeSelector = @selector(setDictionary:forKey:);
            } else {
                typeSelector = @selector(dictionaryForKey:);
            }
        } else if ([rawPropertyType isEqualToString:NSStringFromClass([NSNumber class])]) {
            if (isSetter) {
                typeSelector = @selector(setNumber:forKey:);
            } else {
                typeSelector = @selector(numberForKey:);
            }
        } else if ([rawPropertyType isEqualToString:NSStringFromClass([NSDate class])]) {
            if (isSetter) {
                typeSelector = @selector(setDate:forKey:);
            } else {
                typeSelector = @selector(dateForKey:);
            }
        } else if ([rawPropertyType isEqualToString:NSStringFromClass([NSArray class])]) {
            if (isSetter) {
                typeSelector = @selector(setArray:forKey:);
            } else {
                typeSelector = @selector(arrayForKey:);
            }
        } else if ([rawPropertyType isEqualToString:NSStringFromClass([NSURL class])]) {
            if (isSetter) {
                typeSelector = @selector(setURL:forKey:);
            } else {
                typeSelector = @selector(urlForKey:);
            }
        }
    }
    
    // Update the cache and return the type selector (if one exists).
    if (typeSelector) {
        _cacheTypeSelectorForPropertySelector[NSStringFromSelector(selector)] = NSStringFromSelector(typeSelector);
        return typeSelector;
    }
    
    return nil;
}

/**
 * @brief Grab all properties and types (up to NSProxy) and return 
 *        a dictionary (to be used later to compared against @encode(<type>)).
 */
+ (NSMutableDictionary *)propertyTypesForNames
{
    NSMutableDictionary *propertyTypeDictionary = nil;
    
    if ([self superclass] != [NSProxy class]) {
        propertyTypeDictionary = [[self superclass] propertyTypesForNames];
    } else {
        propertyTypeDictionary = [NSMutableDictionary dictionary];
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char * propertyNameCString = property_getName(property);
        const char *rawPropertyType = getPropertyType(property);
        
        NSString *convertedPropertyType = [NSString stringWithUTF8String:rawPropertyType];
        NSString *convertedName = [NSString stringWithUTF8String:propertyNameCString];
        
        propertyTypeDictionary[convertedName] = convertedPropertyType;
    }
    
    free(properties);
    
    return propertyTypeDictionary;
}

/**
 * @brief Extract the raw property type given a property. This function was borrowed from:
 *        http://stackoverflow.com/questions/754824/get-an-object-properties-list-in-objective-c/8380836#8380836
 *        https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 */
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // C-primitive type.
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1
                                                      length:strlen(attribute) - 1
                                                    encoding:NSASCIIStringEncoding];
            
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // Objective-C "id" type.
            return "id";
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            // Some other Objective-C type.
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3
                                                      length:strlen(attribute) - 4
                                                    encoding:NSASCIIStringEncoding];
            
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    
    return "";
}

@end
