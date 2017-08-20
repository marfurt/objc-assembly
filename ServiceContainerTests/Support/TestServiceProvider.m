//
//  TestServiceProvider
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import "TestServiceProvider.h"

@implementation TestServiceProvider

- (void)registerIn:(DependencyContainer *)container
{
	if (self.onRegisterBlock) {
		self.onRegisterBlock(container);
	}
}

@end
