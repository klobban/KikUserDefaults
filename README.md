KikUserDefaults
===============

The KikUserDefaults classes aim to make NSUserDefaults behave more like typical properties by removing much of the boilerplate around management and provides access through the use of an NSProxy.

## Creation

1. Subclass `KikUserDefaultsProxy` and add properties that you wish to be stored as an NSUserDefault.
2. Make those properties `dynamic` in the implementation of your subclass.
3. Set default values using `setDefaultValue:forProperty:` in the constructor of your subclass.

## Observation

Any object can observe changes to user defaults through callbacks:

	[kikUserDefaultsProxy observeProperty:@"test" withCallback:^(NSString *value) {
		// Perform operation with updated "test" property value.
	}];

## Sample

Using KikUserDefaults involves subclassing `KikUserDefaultsProxy`, adding the properties (which will be treated like NSUserDefaults) that you need, and hooking it up to a `KikUserDefaultsBackend`. From then on, just read and write to those properties and the NSUserDefaults will be updated automatically.

#### Interface

	@interface SampleKikUserDefaultsProxy : KikUserDefaultsProxy
	
	@property (nonatomic, assign) BOOL hasEmail;
	
	@end

#### Implementation

	@implementation SampleKikUserDefaultsProxy
	
	// All properties must be declared as dynamic.
	@dynamic hasEmail;
	
	- (id)initWithKikUserDefaultsBackend:(KikUserDefaultsBackend *)backend
	{
    	if (self = [super initWithKikUserDefaultsBackend:backend]) {
        	[self setDefaultValue:[NSNumber numberWithBool:YES]
            	      forProperty:@"hasEmail"];
        }
        
	    return self;
    }
	
	@end
	
#### Usage

	KikUserDefaultsBackend *backend = [[KikUserDefaultsBackend alloc] init];
	SampleKikUserDefaultsProxy *proxy = [SampleKikUserDefaultsProxy alloc] initWithKikUserDefaultsBackend:backend];
	
	// Setting this property to NO will in turn update the NSUserDefault in storage and notify
	// any observers.
	proxy.hasEmail = NO;

