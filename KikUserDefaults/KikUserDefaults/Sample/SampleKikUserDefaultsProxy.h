//
//  SampleKikUserDefaultsProxy.h
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "KikUserDefaultsProxy.h"

/**
 * @brief To add a new user default, define the property here and make the property
 *        dynamic in the implementation (ExampleUserDefaultsHelperProxy.m). If you need
 *        a specialized getter or setter, add the methods to the backend in
 *        ExampleUserDefaultsHelperBackend.
 */
@interface SampleKikUserDefaultsProxy : KikUserDefaultsProxy

@property (nonatomic, assign) BOOL          testBool;
@property (nonatomic, assign) NSInteger     testInteger;
@property (nonatomic, copy)   NSString     *testString;
@property (nonatomic, copy)   NSDictionary *testDictionary;

@end
