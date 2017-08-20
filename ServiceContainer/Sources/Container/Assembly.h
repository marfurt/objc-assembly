//
//  Assembly
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DependencyContainer.h"
#import "ServiceProvider.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The Assembly is the central place of the application to register bindings and resolve dependencies.
 
 Generally, you define several service providers for your application that provide bindings for a certain context. Then you have to call the boot method to register those service providers.
 */
@interface Assembly : DependencyContainer

@property (class, readonly, strong) Assembly *sharedAssembly;

- (void)addProvider:(id<ServiceProvider>)provider;
- (void)addProviders:(NSArray<id<ServiceProvider>> *)providers;

- (void)boot;

@end

NS_ASSUME_NONNULL_END
