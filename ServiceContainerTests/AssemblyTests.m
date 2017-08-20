//
//  AssemblyTests
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Assembly.h"
#import "TestClass.h"
#import "TestServiceProvider.h"

@interface AssemblyTests : XCTestCase

@property (nonatomic, strong) Assembly *assembly;

@end

@implementation AssemblyTests

- (void)setUp
{
	[super setUp];
	
	self.assembly = [[Assembly alloc] init];
}

- (void)tearDown
{
	self.assembly = nil;
	
	[super tearDown];
}

- (void)testThatSharedAssemblyReturnsSameInstance
{
	Assembly *one = Assembly.sharedAssembly;
	Assembly *other = Assembly.sharedAssembly;
	
	XCTAssertEqualObjects(one, other);
}

- (void)testRegisterServiceProviderOnBootingAssembly
{
	__block BOOL didCallRegister = NO;
	
	TestServiceProvider *provider = [TestServiceProvider new];
	provider.onRegisterBlock = ^(DependencyContainer * container) {
		didCallRegister = YES;
		XCTAssertEqualObjects(container, self.assembly);
	};
	
	[self.assembly addProvider:provider];
	[self.assembly boot];
	
	XCTAssertTrue(didCallRegister);
}

- (void)testRegisterMultipeServiceProvidersOnBootingAssembly
{
	__block BOOL didCallRegisterProvider1 = NO;
	TestServiceProvider *provider1 = [TestServiceProvider new];
	provider1.onRegisterBlock = ^(DependencyContainer * container) {
		didCallRegisterProvider1 = YES;
		XCTAssertEqualObjects(container, self.assembly);
	};
	
	__block BOOL didCallRegisterProvider2 = NO;
	TestServiceProvider *provider2 = [TestServiceProvider new];
	provider2.onRegisterBlock = ^(DependencyContainer * container) {
		didCallRegisterProvider2 = YES;
		XCTAssertEqualObjects(container, self.assembly);
	};
	
	[self.assembly addProviders:@[ provider1, provider2]];
	[self.assembly boot];
	
	XCTAssertTrue(didCallRegisterProvider1);
	XCTAssertTrue(didCallRegisterProvider2);
}

- (void)testServiceProviderNotRegisteredOnBootingAssembly
{
	TestServiceProvider *provider = [TestServiceProvider new];
	provider.onRegisterBlock = ^(DependencyContainer * container) {
		XCTFail(@"The provider should not be register.");
	};
	
	[self.assembly boot];
}

- (void)testServiceProviderNotRegisteredWithoutBootingAssembly
{
	TestServiceProvider *provider = [TestServiceProvider new];
	provider.onRegisterBlock = ^(DependencyContainer * container) {
		XCTFail(@"The provider should not be register.");
	};
	
	[self.assembly addProvider:provider];
}

- (void)testServiceProviderResolvesBinding
{
	TestClass *instance = [TestClass new];
	Protocol *protocol = @protocol(TestProtocol);
	
	TestServiceProvider *provider = [TestServiceProvider new];
	provider.onRegisterBlock = ^(DependencyContainer * container) {
		[container bindInstance:instance toProtocol:protocol];
	};
	
	[self.assembly addProvider:provider];
	[self.assembly boot];
	
	TestClass *resolvedInstance = [self.assembly resolve:protocol];
	
	XCTAssertNotNil(resolvedInstance);
	XCTAssertEqualObjects(instance, resolvedInstance);
}

@end
