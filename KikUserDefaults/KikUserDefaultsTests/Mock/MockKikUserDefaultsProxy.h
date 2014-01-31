//
//  MockKikUserDefaultsProxy.h
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "KikUserDefaultsProxy.h"

@interface MockKikUserDefaultsProxy : KikUserDefaultsProxy

@property (nonatomic, assign) int           testIntProperty;
@property (nonatomic, assign) float         testFloatProperty;
@property (nonatomic, assign) double        testDoubleProperty;
@property (nonatomic, assign) BOOL          testBoolProperty;

@property (nonatomic, assign) NSString     *testStringProperty;
@property (nonatomic, assign) NSDate       *testDateProperty;
@property (nonatomic, assign) NSDictionary *testDictionaryProperty;
@property (nonatomic, assign) NSNumber     *testNumberProperty;
@property (nonatomic, assign) NSArray      *testArrayProperty;
@property (nonatomic, assign) NSURL        *testURLProperty;

@property (nonatomic, assign) NSString     *testStringAlwaysReturnsHelloProperty;

@property (nonatomic, assign) NSString     *testNotificationProperty;

@end