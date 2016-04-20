# TaskLoop

[![Join the chat at https://gitter.im/SunilSpaceo/DemoTaskLoop](https://badges.gitter.im/SunilSpaceo/DemoTaskLoop.svg)](https://gitter.im/SunilSpaceo/DemoTaskLoop?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

'TaskLoop' is category of NSArray designed to manage asynchronous tasks in loop. 

## Problem
let say you are calling a function in for loop

```objective-c
[self.arrImages enumerateObjectsUsingBlock:^(id  _Nonnull URL, NSUInteger idx, BOOL * _Nonnull stop) {
	[self downloadImageWithURL:URL]
}];

-(void)downloadImageWithURL:(NSURL*)url{

    NSURLSessionDownloadTask *downloadTask =  [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }];
    [downloadTask resume];
}
```

Here 'downloadImageWithURL:' is asynch function so our loop will not wait until image download it will call function and continue to next iteration. But let say you want to stop for loop until image has been downloaded?

## Solution
import "NSArray+TaskLoop.h" category and use 'enumerateTaskSequentially' like 

```objective-c
[array enumerateTaskSequentially:^(id URL, NSUInteger idx, BlockTaskCompletion completion) {
    [self downloadImageWithURL:URL withCompletion:completion];
} blockCompleteAllTask:^{
    NSLog(@"all task completed");
}];

//add completion in function pararmete
-(void)downloadImageWithURL:(NSURL*)url withCompletion:(BlockTaskCompletion)completion{
    NSURLSessionDownloadTask *downloadTask =  [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       //IMPORTANT: download completed so Call 'completion' block
       completion(nil);
    }];
    [downloadTask resume];
}
```
