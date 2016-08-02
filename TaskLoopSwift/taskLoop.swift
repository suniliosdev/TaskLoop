//
//  SKTaskLoop.swift
//  DemoTaskLoop
//
//  Created by Sunil on 6/13/16.
//  Copyright © 2016 Sunil. All rights reserved.
//

import Foundation

typealias BlockTaskCompletion = (AnyObject?) -> Void
typealias BlockAllTaskCompletion = Void -> Void
typealias BlockTask = (AnyObject?, BlockTaskCompletion) -> Void

typealias BlockEnum = (AnyObject,NSInteger,BlockTaskCompletion) -> Void

extension NSArray
{
    func enumerateTaskSequentially(block:((bObj:AnyObject,bIndex:NSInteger,block:((bbOje:AnyObject?) -> Void)) -> Void),blockCompleteAllTask:(Void -> Void)?){
        var arrTasks:Array<BlockTask?> = []
        
        self.enumerateObjectsUsingBlock { (obj:AnyObject, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            let blockTask:BlockTask?
            blockTask = {(result:AnyObject?, completion:BlockTaskCompletion) in
                block(bObj: obj, bIndex: index, block: completion)
            }
            arrTasks.append(blockTask)
        }
        
        var blockSequence: ((Void) -> Void)!
        //var weak_blockSequence: (Void) -> Void
        let weak_blockSequence: ((Void) -> Void)! = { (Void) in
            if  arrTasks.count != 0 {
                let task = arrTasks[0] as BlockTask?
                if task != nil {
                    task!(nil,{(Void) in
                        arrTasks.removeAtIndex(0)
                        blockSequence()
                    })
                }
            }else{
                if blockCompleteAllTask != nil {
                    blockCompleteAllTask!()
                }
            }
        }
        blockSequence = weak_blockSequence
        blockSequence()
    }
    
    
    func enumerateTaskParallely(block:((AnyObject,NSInteger,((AnyObject?) -> Void)) -> Void),blockCompleteAllTask:(Void -> Void)?){
        var arrTasks:Array<BlockTask?> = []
        self.enumerateObjectsUsingBlock { (obj:AnyObject, index:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            let blockTask:BlockTask?
            blockTask = {(result:AnyObject?, completion:BlockTaskCompletion) in
                block(obj,index,completion)
            }
            arrTasks.append(blockTask)
        }
        
        var arrTaskCompleted:Array<BlockTask?> = []
        
        if arrTasks.count != 0 {
            for var i=0;i<arrTasks.count;i++ {
                let task = arrTasks[i] as BlockTask?
                if task != nil {
                    task!(nil,{(Void) in
                        arrTaskCompleted.append(task)
                        if arrTaskCompleted.count == arrTasks.count {
                            if blockCompleteAllTask != nil {
                                blockCompleteAllTask!()
                            }
                        }
                    })
                }
            }
        }else{
            if blockCompleteAllTask != nil {
                blockCompleteAllTask!()
            }
        }
        
    }
    
}
