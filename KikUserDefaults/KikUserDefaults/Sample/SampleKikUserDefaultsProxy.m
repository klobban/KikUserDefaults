//
//  SampleKikUserDefaultsProxy.m
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "SampleKikUserDefaultsProxy.h"

@implementation SampleKikUserDefaultsProxy

@dynamic testBool;
@dynamic testInteger;
@dynamic testString;
@dynamic testDictionary;

#pragma mark - Initialization

- (id)initWithKikUserDefaultsBackend:(KikUserDefaultsBackend *)backend
{
    if (self = [super initWithKikUserDefaultsBackend:backend]) {
        [self setDefaultValue:[NSNumber numberWithBool:YES]
                  forProperty:@"testBool"];
        
        [self setDefaultValue:[NSNumber numberWithInteger:5]
                  forProperty:@"testInteger"];
        
        [self setDefaultValue:@"defaultStringValue"
                  forProperty:@"testString"];
        
        [self setDefaultValue:@{ @"key" : @"value" }
                  forProperty:@"testDictionary"];
    }
    
    return self;
}

@end
