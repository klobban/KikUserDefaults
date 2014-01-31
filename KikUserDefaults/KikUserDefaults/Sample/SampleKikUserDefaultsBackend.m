//
//  SampleKikUserDefaultsBackend.m
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "SampleKikUserDefaultsBackend.h"
#import "SampleKikUserDefaultsProxy.h"

@implementation SampleKikUserDefaultsBackend

@synthesize proxy = _proxy;

#pragma mark - Custom Property Methods

- (NSString *)testString
{
    return @"Custom property method implemented!";
}

@end
