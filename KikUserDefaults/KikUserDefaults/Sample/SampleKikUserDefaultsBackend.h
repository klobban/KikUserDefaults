//
//  SampleKikUserDefaultsBackend.h
//  Kik
//
//  Created by Kyle Lobban on 2013-03-01.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "KikUserDefaultsBackend.h"
#import "SampleKikUserDefaultsProxy.h"

#pragma mark - Backend Declaration

/**
 * @brief This ExampleUserDefaultsHelperBackend is an example of how to subclass
 *        the NSUserDefaultsHelper backend.
 */
@interface SampleKikUserDefaultsBackend : KikUserDefaultsBackend

@property (nonatomic, weak) SampleKikUserDefaultsProxy *proxy;

@end