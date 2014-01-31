//
//  KikUserDefaultsTests.m
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KikUserDefaultsBackend.h"
#import "MockKikUserDefaultsProxy.h"
#import "MockKikUserDefaultsBackend.h"

@interface NSUserDefaultsProxyTest : XCTestCase

@end

@implementation NSUserDefaultsProxyTest

- (void)testIntGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testIntProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testIntProperty == 0, @"testIntProperty is not zero.");
    proxy.testIntProperty = 5;
    XCTAssertTrue(proxy.testIntProperty == 5, @"testIntProperty is not five.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testIntProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testDoubleGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testDoubleProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testDoubleProperty == 0.0, @"testDoubleProperty is not zero.");
    proxy.testDoubleProperty = 6.32;
    XCTAssertTrue(proxy.testDoubleProperty == 6.32, @"testDoubleProperty is not 6.32.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testDoubleProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testFloatGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testFloatProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testFloatProperty == 0.0f, @"testFloatProperty is not zero.");
    proxy.testFloatProperty = 7.43f;
    XCTAssertTrue(proxy.testFloatProperty == 7.43f, @"testFloatProperty is not 7.43f.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testFloatProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testBoolGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testBoolProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testBoolProperty == NO, @"testBoolProperty is not NO.");
    proxy.testBoolProperty = YES;
    XCTAssertTrue(proxy.testBoolProperty == YES, @"testBoolProperty is not YES.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testBoolProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Objects

- (void)testStringGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testStringProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"testStringProperty: %@", proxy.testStringProperty);
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testStringProperty == nil, @"testStringProperty is not nil.");
    proxy.testStringProperty = @"hey";
    XCTAssertTrue([proxy.testStringProperty isEqualToString:@"hey"], @"testStringProperty is not 'hey'.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testStringProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testDateGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testDateProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testDateProperty == nil, @"testDateProperty is not nil.");
    proxy.testDateProperty = [NSDate dateWithTimeIntervalSince1970:5];
    XCTAssertTrue([proxy.testDateProperty isEqualToDate:[NSDate dateWithTimeIntervalSince1970:5]], @"testDateProperty is not equal to the set date.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testDateProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testDictionaryGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testDictionaryProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testDictionaryProperty == nil, @"testDictionaryProperty is not nil.");
    proxy.testDictionaryProperty = @{@"key": @"property"};
    XCTAssertTrue([proxy.testDictionaryProperty isEqualToDictionary:@{@"key": @"property"}], @"testDictionaryProperty is not equal to the set dictionary.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testDictionaryProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testNumberGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testNumberProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testNumberProperty == nil, @"testNumberProperty is not nil.");
    proxy.testNumberProperty = [NSNumber numberWithInt:54321];
    XCTAssertTrue([proxy.testNumberProperty isEqualToNumber:[NSNumber numberWithInt:54321]], @"testNumberProperty is not equal to the set number.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testNumberProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testArrayGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testArrayProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testArrayProperty == nil, @"testArrayProperty is not nil.");
    proxy.testArrayProperty = [NSArray arrayWithObject:[NSNumber numberWithInt:5]];
    XCTAssertTrue([proxy.testArrayProperty isEqualToArray:[NSArray arrayWithObject:[NSNumber numberWithInt:5]]], @"testArrayProperty is not equal to the set array.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testArrayProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testURLGetAndSet
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testURLProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testURLProperty == nil, @"testURLProperty is not nil.");
    proxy.testURLProperty = [NSURL URLWithString:@"google.com"];
    XCTAssertTrue([proxy.testURLProperty.absoluteString isEqualToString:@"google.com"], @"testURLProperty is not equal to the set URL.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testURLProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testRemoveProperties
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    KikUserDefaultsProxy *proxy = [[KikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Test" forKey:@"testRemovalKey"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Test2" forKey:@"testRemovalKey2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] objectForKey:@"testRemovalKey"] != nil, @"testRemovalKey was not set.");
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] objectForKey:@"testRemovalKey2"] != nil, @"testRemovalKey2 was not set.");
    
    [proxy removeProperties:@[@"testRemovalKey", @"testRemovalKey2"]];
    
    // Ensure the property was removed.
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] objectForKey:@"testRemovalKey"] == nil, @"testRemovalKey was not removed.");
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] objectForKey:@"testRemovalKey2"] == nil, @"testRemovalKey was not removed.");
}

- (void)testCustomGetter
{
    MockKikUserDefaultsBackend *backend = [[MockKikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    proxy.testStringAlwaysReturnsHelloProperty = @"This is pretty much ignored.";
    
    XCTAssertTrue([proxy.testStringAlwaysReturnsHelloProperty isEqualToString:@"Hello"], @"testStringAlwaysReturnsHelloProperty did not return 'Hello'.");
}

- (void)testPropertyTypes
{
    MockKikUserDefaultsBackend *backend = [[MockKikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    XCTAssertTrue(CLASS_TYPE_IS_BOOL([proxy typeForProperty:@"testBoolProperty"]), @"testBoolProperty is not a boolean.");
    XCTAssertFalse(CLASS_TYPE_IS_NUMBER([proxy typeForProperty:@"testBoolProperty"]), @"testBoolProperty is number...?");
    
    XCTAssertTrue(CLASS_TYPE_IS_NUMBER([proxy typeForProperty:@"testIntProperty"]), @"testIntProperty is not an integer.");
    XCTAssertFalse(CLASS_TYPE_IS_BOOL([proxy typeForProperty:@"testIntProperty"]), @"testBoolProperty is a boolean...?");
    
    XCTAssertTrue(CLASS_TYPE_IS_STRING([proxy typeForProperty:@"testStringProperty"]), @"testStringProperty is not a string.");
    XCTAssertFalse(CLASS_TYPE_IS_NUMBER([proxy typeForProperty:@"testStringProperty"]), @"testStringProperty is a number...?");
}

- (void)testBackendInvocator
{
    MockKikUserDefaultsBackend *backend = [[MockKikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Test that invocator works.
    XCTAssertTrue([proxy invocatorShouldBeCalledAndReturnYES], @"Invocator did not return YES.");
    XCTAssertTrue([[proxy invocatorShouldReturnString:@"test"] isEqualToString:@"test"], @"Invocator did not return the correct value.");
}

- (void)testNotifications
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testNotificationProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    id notificationIdentifier = [proxy observeProperty:@"testNotificationProperty"
                                          withCallback:^(NSString *value) {
                                              XCTAssertTrue([value isEqualToString:@"Hey"], @"Callback was not set to the correct value.");
                                          }];
    
    XCTAssertTrue([backend.propertyNotifications objectForKey:@"testNotificationProperty"] != nil, @"testNotificationProperty is not firing notifications.");
    
    // Since the default notification center is synchronous, the assertion in the callback will be checked
    // immediately after setting this property.
    proxy.testNotificationProperty = @"Hey";
    
    [proxy stopWatchingPropertyWithNotificationIdentifer:notificationIdentifier];
    
    XCTAssertTrue([backend.propertyNotifications objectForKey:@"testNotificationProperty"] == nil, @"testNotificationProperty is still firing notifications.");
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testNotificationProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)testResetDefaults
{
    KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
    MockKikUserDefaultsProxy *proxy = [[MockKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    // Make sure the property does not exist.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"testIntProperty"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Try setting and getting the property.
    XCTAssertTrue(proxy.testIntProperty == 0, @"testIntProperty is not zero.");
    proxy.testIntProperty = 5;
    XCTAssertTrue(proxy.testIntProperty == 5, @"testIntProperty is not five.");
    
    [proxy resetDefaults];
    
    XCTAssertTrue(proxy.testIntProperty == 0, @"testIntProperty is not zero.");
}

@end
