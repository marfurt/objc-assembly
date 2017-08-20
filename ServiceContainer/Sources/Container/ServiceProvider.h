//
//  ServiceProvider
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DependencyContainer;

NS_ASSUME_NONNULL_BEGIN

/**
 Service providers are used to register dependencies to the application.
 */
@protocol ServiceProvider <NSObject>

- (void)registerIn:(DependencyContainer *)container;

@end

NS_ASSUME_NONNULL_END
