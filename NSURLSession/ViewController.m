//
//  ViewController.m
//  NSURLSession
//
//  Created by HCL on 16/3/8.
//  Copyright © 2016年 胡成龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progress.text=@"%0";
    self.progressView.progress=0;
}

- (IBAction)download:(id)sender {
    //数据任务
//    NSString *urlStr=@"http://pic1a.nipic.com/2008-11-26/200811268173650_2.jpg";
//    NSURL *url=[NSURL URLWithString:urlStr];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    NSURLSessionConfiguration *sessionConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session=[NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageView.image=[UIImage imageWithData:data];
//        });
//        if (error) {
//            NSLog(@"%@",error);
//        }
//    }];
//    [dataTask resume];

    //下载任务
    NSString *urlStr=@"http://e.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=b7bcfdd8d258ccbf1be9bd3c29e89006/9213b07eca80653808b5f07994dda144ad348278.jpg";
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *sessionConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithRequest:request];
    [downloadTask resume];
    
    //block回调不能触发代理方法
    //    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        NSFileManager *fileManager = [NSFileManager defaultManager];
    //        NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    //        NSURL *documentsDirectory = URLs[0];
    //        NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    //        [fileManager removeItemAtURL:destinationPath error:NULL];
    //        BOOL success=[fileManager copyItemAtURL:location toURL:destinationPath error:nil];
    //        if (success) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                self.imageView.image=[UIImage imageWithContentsOfFile:[destinationPath path]];
    //            });
    //        }
    //        if (error) {
    //            NSLog(@"%@",error);
    //        }
    //    }];
}

- (IBAction)delete:(id)sender {
    self.imageView.image=nil;
    self.progress.text=@"%0";
    self.progressView.progress=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLSessionDownloadDelegate
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress.text=[NSString stringWithFormat:@"%.0f%%",currentProgress*100];
        //可以取消下载(支持断点续传)
//        if ([self.progress.text isEqualToString:@"70%"]) {
//            [downloadTask cancel];
//        }
        self.progressView.progress=currentProgress;
    });
    NSLog(@"%.0f%%",currentProgress*100);
    double size=(double)totalBytesWritten/1000/1000;
    NSLog(@"已下载%.3fMB",size);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
    [fileManager removeItemAtURL:destinationPath error:NULL];
    BOOL success=[fileManager copyItemAtURL:location toURL:destinationPath error:nil];
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image=[UIImage imageWithContentsOfFile:[destinationPath path]];
        });
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"%@",error);
    }
    else{
        NSLog(@"下载成功!!");
    }
}

@end
