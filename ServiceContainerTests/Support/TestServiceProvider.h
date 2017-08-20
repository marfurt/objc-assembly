//
//  TestServiceProvider
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestServiceProvider : NSObject <ServiceProvider>

@property (nonatomic, copy, nullable) void (^onRegisterBlock)(DependencyContainer *);

@end

NS_ASSUME_NONNULL_END
