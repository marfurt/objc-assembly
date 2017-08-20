//
//  Assembly
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import "Assembly.h"

@interface Assembly ()

@property (nonatomic, strong) NSMutableSet *providers;

@end

@implementation Assembly

#pragma mark Initialization

+ (Assembly *)sharedAssembly
{
	static Assembly *sharedInstance = nil;
	static dispatch_once_t onceToken = 0;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

- (instancetype)init
{
	if (self = [super init]) {
		self.providers = [[NSMutableSet alloc] init];
	}
	
	return self;
}

#pragma mark Managing Service Providers

- (void)addProvider:(id<ServiceProvider>)provider
{
	[self.providers addObject:provider];
}

- (void)addProviders:(NSArray<id<ServiceProvider>> *)providers
{
	[self.providers addObjectsFromArray:providers];
}

#pragma mark Booting Service Providers

- (void)boot
{
	for (id<ServiceProvider> provider in self.providers) {
		[provider registerIn:self];
	}
}

@end
