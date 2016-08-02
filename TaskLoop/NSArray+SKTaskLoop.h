//
//  NSArray+SKTaskLoop.h
//  DemoTaskLoop
//
//  Created by Sunil on 6/13/16.
//  Copyright © 2016 Sunil. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BlockAllTaskCompletion)(void);
typedef void(^BlockTaskCompletion)(id result);
typedef void(^BlockTask)(id result, BlockTaskCompletion completion);

@interface NSArray (SKTaskLoop)


//Executes task one by one
-(void)enumerateTaskSequentially:(void (^)(id obj, NSUInteger idx, BlockTaskCompletion completion))block blockCompleteAllTask:(BlockAllTaskCompletion)blockAllTaskCompletion;

//Executes all task simultaneously
-(void)enumerateTaskParallely:(void (^)(id obj, NSUInteger idx, BlockTaskCompletion completion))block blockCompleteAllTask:(BlockAllTaskCompletion)blockAllTaskCompletion;

@end
