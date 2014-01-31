//
//  MockKikUserDefaultsBackend.m
//  Kik
//
//  Created by Kyle Lobban on 2013-03-03.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "MockKikUserDefaultsBackend.h"

@implementation MockKikUserDefaultsBackend

- (BOOL)invocatorShouldBeCalledAndReturnYES
{
    return YES;
}

- (NSString *)invocatorShouldReturnString:(NSString *)string
{
    return string;
}

- (NSString *)testStringAlwaysReturnsHelloProperty
{
    return @"Hello";
}

@end
