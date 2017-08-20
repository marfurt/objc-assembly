//
//  DependencyContainer
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DependencyContainer;

NS_ASSUME_NONNULL_BEGIN

typedef NSString * Alias;
typedef _Nonnull id (^BindingBlock)(DependencyContainer *);

/**
 The DependencyContainer is a tool for managing class dependencies and performing dependency injection.
 */
@interface DependencyContainer : NSObject

- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocol;
- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocol usingAlias:(NSString *)string;
- (void)bindBlock:(BindingBlock)block toProtocol:(Protocol *)protocol;
- (void)bindBlock:(BindingBlock)block toProtocol:(Protocol *)protocol asSharedInstance:(BOOL)isShared;
- (void)bindClass:(Class)class toProtocol:(Protocol *)protocol;

- (void)setAlias:(NSString *)name forProtocol:(Protocol *)protocol;
- (BOOL)isAlias:(NSString *)name;

- (nullable id)resolve:(Protocol *)protocol;
- (nullable id)resolveAlias:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

