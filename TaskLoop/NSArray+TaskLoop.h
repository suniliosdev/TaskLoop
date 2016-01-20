//
//  NSArray+TaskLoop.h
//  DemoTaskLoop
//
//  Created by Sunil on 1/20/16.
//  Copyright © 2016 Sunil. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BlockAllTaskCompletion)(void);
typedef void(^BlockTaskCompletion)(id result);
typedef void(^BlockTask)(id result, BlockTaskCompletion completion);

@interface NSArray (TaskLoop)

//Executes task one by one
-(void)enumerateTaskSequentially:(void (^)(id obj, NSUInteger idx, BlockTaskCompletion completion))block blockCompleteAllTask:(BlockAllTaskCompletion)blockAllTaskCompletion;

//Executes all task simultaneously
-(void)enumerateTaskParallely:(void (^)(id obj, NSUInteger idx, BlockTaskCompletion completion))block blockCompleteAllTask:(BlockAllTaskCompletion)blockAllTaskCompletion;
@end
