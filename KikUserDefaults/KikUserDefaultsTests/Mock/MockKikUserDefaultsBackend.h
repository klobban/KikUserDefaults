//
//  MockKikUserDefaultsBackend.h
//  Kik
//
//  Created by Kyle Lobban on 2013-03-03.
//  Copyright (c) 2013 Kik Interactive. All rights reserved.
//

#import "KikUserDefaultsBackend.h"
#import "MockKikUserDefaultsProxy.h"

@interface MockKikUserDefaultsBackend : KikUserDefaultsBackend

- (BOOL)invocatorShouldBeCalledAndReturnYES;

- (NSString *)invocatorShouldReturnString:(NSString *)string;

@end

@interface MockKikUserDefaultsProxy (Extra)

- (BOOL)invocatorShouldBeCalledAndReturnYES;

- (NSString *)invocatorShouldReturnString:(NSString *)string;

@end