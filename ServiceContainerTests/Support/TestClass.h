//
//  TestClass
//
//  Copyright © 2017 Nicolas Marfurt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestProtocol <NSObject>
@end

@interface TestClass : NSObject <TestProtocol>
@end

@interface TestSubclass : TestClass
@end


@protocol OtherTestProtocol <NSObject>
@end

@interface OtherTestClass : NSObject <OtherTestProtocol>
@end
