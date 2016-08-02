//
//  NSArray+SKTaskLoop.m
//  DemoTaskLoop
//
//  Created by Sunil on 6/13/16.
//  Copyright © 2016 Sunil. All rights reserved.
//

#import "NSArray+SKTaskLoop.h"

@implementation NSArray (SKTaskLoop)



-(void)enumerateTaskSequentially:(void (^)(id obj, NSUInteger idx, BlockTaskCompletion completion))block blockCompleteAllTask:(BlockAllTaskCompletion)blockAllTaskCompletion{
    
    NSMutableArray *arrTasks = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BlockTask blockTask = ^(id result, BlockTaskCompletion completion){
            block(obj,idx,completion);
        };
        [arrTasks addObject:blockTask];
    }];
    
    __block __strong void (^weak_blockSequence)(void);
    void (^blockSequence)(void);
    
    weak_blockSequence = blockSequence = ^(void){
        
        if (arrTasks && arrTasks.count) {
            BlockTask task = arrTasks[0];
            if (task) {
                task(nil,^(id BlockTaskCompletion){
                    //this block get called when task completed
                    [arrTasks removeObjectAtIndex:0];
                    weak_blockSequence();
                });
            }
        }else{
            //all task completed
            if (blockAllTaskCompletion) {
                blockAllTaskCompletion();
            }
        }
    };
    blockSequence();
    
}


-(void)enumerateTaskParallely:(void (^)(id obj, NSUInteger idx, BlockTaskCompletion completion))block blockCompleteAllTask:(BlockAllTaskCompletion)blockAllTaskCompletion{
    
    NSMutableArray *arrTasks = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BlockTask blockTask = ^(id result, BlockTaskCompletion completion){
            block(obj,idx,completion);
        };
        [arrTasks addObject:blockTask];
    }];
    
    
    NSMutableArray *arrTaskCompleted=[NSMutableArray new];
    
    if (arrTasks && arrTasks.count) {
        
        for (int i=0; i<arrTasks.count; i++) {
            __block BlockTask task = arrTasks[i];
            if (task) {
                task(nil,^(id BlockTaskCompletion){
                    //this block get called when task completed
                    [arrTaskCompleted addObject:task];
                    if (arrTaskCompleted.count == arrTasks.count) {
                        //all task completed
                        if (blockAllTaskCompletion) {
                            blockAllTaskCompletion();
                        }
                    }
                });
            }
        }
    }else{
        //all task completed
        if (blockAllTaskCompletion) {
            blockAllTaskCompletion();
        }
    }
    
}

@end
