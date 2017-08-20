//
//  DependencyContainer
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import "DependencyContainer.h"
#import "BindingElement.h"

@interface DependencyContainer ()

@property (nonatomic, strong) NSMutableDictionary *instances;
@property (nonatomic, strong) NSMutableDictionary *bindings;
@property (nonatomic, strong) NSMutableDictionary *aliases;

@end

@implementation DependencyContainer

#pragma mark Initialization

- (instancetype)init
{
	if (self = [super init]) {
		self.instances = [[NSMutableDictionary alloc] init];
		self.bindings = [[NSMutableDictionary alloc] init];
		self.aliases = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

#pragma mark Binding and Resolving Protocols

- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocol
{
	NSAssert([instance conformsToProtocol:protocol], @"The instance %@ should conform to the protocol %@", NSStringFromClass([instance class]), NSStringFromProtocol(protocol));
	
	NSString *key = [self keyForProtocol:protocol];
	
	self.instances[key] = instance;
}

- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocol usingAlias:(NSString *)alias
{
	[self bindInstance:instance toProtocol:protocol];
	[self setAlias:alias forProtocol:protocol];
}

- (void)bindBlock:(BindingBlock)block toProtocol:(Protocol *)protocol
{
	[self bindBlock:block toProtocol:protocol asSharedInstance:NO];
}

- (void)bindBlock:(BindingBlock)block toProtocol:(Protocol *)protocol asSharedInstance:(BOOL)isShared
{
	NSString *key = [self keyForProtocol:protocol];
	
	self.bindings[key] = [BindingElement bindingWithBlock:block sharedInstance:isShared];
}

- (void)bindClass:(Class)class toProtocol:(Protocol *)protocol
{
	NSAssert([class conformsToProtocol:protocol], @"The class %@ should conform to the protocol %@", class, NSStringFromProtocol(protocol));
	
	BindingBlock block = ^id(DependencyContainer *container) {
		return [container build:class];
	};
	
	[self bindBlock:block toProtocol:protocol];
}

- (nullable id)resolve:(Protocol *)protocol
{
	NSString *key = [self keyForProtocol:protocol];
	
	// Resolve the instance, if any
	id instance = self.instances[key];
	if (instance) {
		return instance;
	}
	
	// Resolve the block, if any
	BindingElement *element = self.bindings[key];
	if (!element) {
		return nil;
	}
	
	__weak typeof(self) container = self;
	instance = element.block(container);
	
	if (!instance) {
		return nil;
	}
	
	// Keep the shared instance for future resolution
	if (element.isShared) {
		[self bindInstance:instance toProtocol:protocol];
	}
	
	return instance;
}

- (id)build:(Class)class
{
	return [[class alloc] init];
}

- (NSString *)keyForProtocol:(Protocol *)protocol
{
	return NSStringFromProtocol(protocol);
}

#pragma mark Using Aliases

- (void)setAlias:(NSString *)name forProtocol:(Protocol *)protocol
{
	self.aliases[name] = protocol;
}

- (BOOL)isAlias:(NSString *)name
{
	return (self.aliases[name] != nil);
}

- (nullable id)resolveAlias:(NSString *)name
{
	Protocol *protocol = self.aliases[name];
	
	if (!protocol) {
		return nil;
	}
	
	return [self resolve:protocol];
}

#pragma mark Forwarding

- (id)valueForUndefinedKey:(NSString *)key
{
	if ([self isAlias:key]) {
		return [self resolveAlias:key];
	}
	
	return [super valueForUndefinedKey:key];
}

- (BOOL)respondsToSelector:(SEL)selector
{
	if ([self isAlias:NSStringFromSelector(selector)]) {
		return YES;
	}
	
	return [super respondsToSelector:selector];
}

@end

