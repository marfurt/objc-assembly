//
//  BindingElement
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import "BindingElement.h"

@implementation BindingElement

+ (instancetype)bindingWithBlock:(BindingBlock)block sharedInstance:(BOOL)isShared
{
	return [[self alloc] initWithBlock:block sharedInstance:isShared];
}

- (instancetype)initWithBlock:(BindingBlock)block sharedInstance:(BOOL)isShared
{
	if ((self = [super init])) {
		_block = block;
		_isShared = isShared;
	}
	return self;
}

- (instancetype)initWithBlock:(BindingBlock)block
{
	return [self initWithBlock:block sharedInstance:NO];
}

@end
