//
//  ViewController.m
//  DemoTaskLoop
//
//  Created by Sunil on 1/20/16.
//  Copyright © 2016 Sunil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){

}
@property(nonatomic,strong) NSArray *arrImages;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //let say you want to download images from url asynchronously
    self.arrImages = @[
                       @"http://freddesign.co.uk/wp-content/uploads/2013/09/blue_aqua_apple_logo.jpg",
                       @"http://vignette2.wikia.nocookie.net/lego/images/b/b8/Ws-space-apple-logo.jpg/revision/latest/scale-to-width-down/640?cb=20111229061816",
                       @"http://incitrio.com/wp-content/uploads/2015/01/Apple_gray_logo.png",
                       @"http://images.thecarconnection.com/hug/apple-logo_100433916_h.jpg"
                       ];
    
}

-(IBAction)btnSequentiallyCalled:(id)sender{
    
    
    
    [self.arrImages enumerateTaskSequentially:^(id obj, NSUInteger idx, BlockTaskCompletion completion) {
        NSLog(@"task %d start",(int)idx+1);
        NSURL *url = [NSURL URLWithString:obj];
        [self downloadImageWithURL:url withCompletion:completion];
        
    } blockCompleteAllTask:^{
        NSLog(@"all task completed");
    }];
}
-(IBAction)btnParallelyCalled:(id)sender{
    
    [self.arrImages enumerateTaskParallely:^(id obj, NSUInteger idx, BlockTaskCompletion completion) {
        NSLog(@"task %d start",(int)idx+1);
        NSURL *url = [NSURL URLWithString:obj];
        [self downloadImageWithURL:url withCompletion:completion];
        
    } blockCompleteAllTask:^{
        NSLog(@"all task completed");
    }];
    
}

-(void)downloadImageWithURL:(NSURL*)url withCompletion:(BlockTaskCompletion)completion{

    NSURLSessionDownloadTask *downloadTask =  [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //download completed so Call 'completion' block
        //This is important - Do not forgot to call 'completion' block after task completed
        //'completion' block indicate that this task is now completed and our task manager can move on.
        completion(nil);
    }];
    [downloadTask resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
