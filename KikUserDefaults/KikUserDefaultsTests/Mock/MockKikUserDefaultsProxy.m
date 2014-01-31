//
//  MockKikUserDefaultsProxy.m
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "MockKikUserDefaultsProxy.h"

@implementation MockKikUserDefaultsProxy

@dynamic testIntProperty, testDoubleProperty, testFloatProperty, testBoolProperty;
@dynamic testStringProperty, testDateProperty, testDictionaryProperty, testNumberProperty, testArrayProperty, testURLProperty;
@dynamic testStringAlwaysReturnsHelloProperty;
@dynamic testNotificationProperty;

- (id)initWithNSUserDefaultsBackend:(KikUserDefaultsBackend *)backend
{
    self = [super initWithKikUserDefaultsBackend:backend];
    return self;
}

@end
