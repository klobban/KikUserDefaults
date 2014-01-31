//
//  AppDelegate.m
//  KikUserDefaults
//
//  Created by Kyle Lobban on 1/31/2014.
//  Copyright (c) 2014 Kik Interactive. All rights reserved.
//

#import "AppDelegate.h"
#import "SampleKikUserDefaultsBackend.h"
#import "SampleKikUserDefaultsProxy.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Just some sample code.
    SampleKikUserDefaultsBackend *backend = [[SampleKikUserDefaultsBackend alloc] init];
    SampleKikUserDefaultsProxy *proxy = [[SampleKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
    
    proxy.testBool = NO;
    
    // Sample observation.
    [proxy observeProperty:@"testInteger" withCallback:^(NSNumber *number) {
        // Do something with the updated "testInteger" value.
    }];
    
    proxy.testInteger = 5;
    
    return YES;
}

@end
