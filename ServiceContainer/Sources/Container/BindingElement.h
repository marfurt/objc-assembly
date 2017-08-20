//
//  BindingElement
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DependencyContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindingElement : NSObject

+ (instancetype)bindingWithBlock:(BindingBlock)block sharedInstance:(BOOL)isShared;
- (instancetype)initWithBlock:(BindingBlock)block sharedInstance:(BOOL)isShared;
- (instancetype)initWithBlock:(BindingBlock)block;

@property (nonatomic, copy, readonly) BindingBlock block;
@property (nonatomic, assign, readonly) BOOL isShared;

@end

NS_ASSUME_NONNULL_END
