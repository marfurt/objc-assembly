//
//  DependencyContainerTests
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DependencyContainer.h"
#import "TestClass.h"

@interface DependencyContainerTests : XCTestCase

@property (nonatomic, strong) DependencyContainer *dependencyContainer;

@end

@implementation DependencyContainerTests

- (void)setUp
{
    [super setUp];
	
	self.dependencyContainer = [[DependencyContainer alloc] init];
}

- (void)tearDown
{
	self.dependencyContainer = nil;
	
    [super tearDown];
}

- (void)testThatResolvingProtocolReturnsBoundInstance
{
	TestClass *instance = [TestClass new];
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer bindInstance:instance toProtocol:protocol];
	
	TestClass *resolvedInstance = [self.dependencyContainer resolve:protocol];
	
	XCTAssertEqualObjects(instance, resolvedInstance);
}

- (void)testThatResolvingUnboundProtocolReturnsNil
{
	TestClass *instance = [TestClass new];
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer bindInstance:instance toProtocol:protocol];
	
	id resolvedInstance = [self.dependencyContainer resolve:@protocol(OtherTestProtocol)];
	
	XCTAssertNil(resolvedInstance);
	XCTAssertNotEqualObjects(instance, resolvedInstance);
}

- (void)testThatResolvingProtocolReturnsInstanceFromExecutedBlock
{
	Protocol *protocol = @protocol(TestProtocol);
	BindingBlock block = ^id(DependencyContainer *container) {
		return [TestClass new];
	};
	
	[self.dependencyContainer bindBlock:block toProtocol:protocol];
	
	TestClass *resolvedInstance = [self.dependencyContainer resolve:protocol];
	TestClass *otherResolvedInstance = [self.dependencyContainer resolve:protocol];
	
	XCTAssertNotNil(resolvedInstance);
	XCTAssertNotNil(otherResolvedInstance);
	XCTAssertNotEqualObjects(resolvedInstance, otherResolvedInstance);
}

- (void)testThatResolvingProtocolReturnsSharedInstance
{
	Protocol *protocol = @protocol(TestProtocol);
	BindingBlock block = ^id(DependencyContainer *container) {
		return [TestClass new];
	};
	
	[self.dependencyContainer bindBlock:block toProtocol:protocol asSharedInstance:YES];
	
	TestClass *resolvedInstance = [self.dependencyContainer resolve:protocol];
	TestClass *otherResolvedInstance = [self.dependencyContainer resolve:protocol];
	
	XCTAssertNotNil(resolvedInstance);
	XCTAssertNotNil(otherResolvedInstance);
	XCTAssertEqualObjects(resolvedInstance, otherResolvedInstance);
}

- (void)testResolvingAClass
{
	Class class = [TestClass class];
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer bindClass:class toProtocol:protocol];
	
	TestClass *resolvedInstance = [self.dependencyContainer resolve:protocol];
	
	XCTAssertNotNil(resolvedInstance);
	XCTAssertTrue([resolvedInstance isKindOfClass:class]);
}

#pragma mark Aliases

- (void)testResolvingAlias
{
	NSString *alias = @"alias";
	TestClass *instance = [TestClass new];
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer bindInstance:instance toProtocol:protocol];
	[self.dependencyContainer setAlias:alias forProtocol:protocol];
	
	TestClass *resolvedInstance = [self.dependencyContainer resolveAlias:alias];
	
	XCTAssertNotNil(resolvedInstance);
	XCTAssertEqualObjects(resolvedInstance, instance);
}

- (void)testResolvingAliasSetAtBinding
{
	NSString *alias = @"alias";
	TestClass *instance = [TestClass new];
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer bindInstance:instance toProtocol:protocol usingAlias:alias];
	
	TestClass *resolvedInstance = [self.dependencyContainer resolveAlias:alias];
	
	XCTAssertNotNil(resolvedInstance);
	XCTAssertEqualObjects(resolvedInstance, instance);
}

- (void)testResolvingUnsetAlias
{
	NSString *alias = @"alias";
	TestClass *instance = [TestClass new];
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer bindInstance:instance toProtocol:protocol];
	
	TestClass *resolvedInstance = [self.dependencyContainer resolveAlias:alias];
	
	XCTAssertNil(resolvedInstance);
}

- (void)testResolvingUnboundAlias
{
	NSString *alias = @"alias";
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer setAlias:alias forProtocol:protocol];
	
	TestClass *resolvedInstance = [self.dependencyContainer resolveAlias:alias];
	
	XCTAssertNil(resolvedInstance);
}

- (void)testIsAlias
{
	NSString *alias = @"alias";
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer setAlias:alias forProtocol:protocol];
	
	BOOL isAlias = [self.dependencyContainer isAlias:alias];
	
	XCTAssertTrue(isAlias);
}

- (void)testIsNotAlias
{
	NSString *alias = @"alias";
	
	BOOL isAlias = [self.dependencyContainer isAlias:alias];
	
	XCTAssertFalse(isAlias);
}

- (void)testResolvingAliasUsingValueForKey
{
	NSString *alias = @"testService";
	TestClass *instance = [TestClass new];
	Protocol *protocol = @protocol(TestProtocol);
	
	[self.dependencyContainer bindInstance:instance toProtocol:protocol usingAlias:alias];
	
	TestClass *resolvedInstance = [self.dependencyContainer valueForKey:alias];
	
	XCTAssertNotNil(resolvedInstance);
	XCTAssertEqualObjects(resolvedInstance, instance);
}

@end
