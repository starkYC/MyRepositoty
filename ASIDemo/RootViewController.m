//
//  RootViewController.m
//  ASIDemo
//
//  Created by gaoyangchun on 14-3-17.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    ASINetworkQueue   *que = [[ASINetworkQueue alloc] init];
    self.netWorkQueue = que;
    [que release];
    
    [self.netWorkQueue reset];
    [self.netWorkQueue setShowAccurateProgress:YES];
    
    
    //初始化Documents路径
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	//初始化临时文件路径
	NSString *folderPath = [path stringByAppendingPathComponent:@"temp"];
    self.myPath = [[NSString alloc] initWithString:path];
	//创建文件管理器
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//判断temp文件夹是否存在
	BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
	
	if (!fileExists) {//如果不存在说创建,因为下载时,不会自动创建文件夹
		[fileManager createDirectoryAtPath:folderPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
    
       //设置缓存路径
    self.myCache  = [[[ASIDownloadCache alloc]init]autorelease];
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [self.myCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
    [self.myCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
}

- (IBAction)secdownLoad:(id)sender{
  /*  {
    NSURL *url = [NSURL URLWithString:@"http://dl_dir.qq.com/invc/qqpinyin/QQPinyin_Setup_4.6.2028.400.exe"];
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //初始化保存ZIP文件路径
    NSString *savePath = [self.myPath stringByAppendingPathComponent:@"MyDefine.zip"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
//        self.secMyProess.progress = 1.0f;
//        return;
    }
	//初始化临时文件路径
	NSString *tempPath = [self.myPath stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/QQ2_%d",[sender tag]]];
    
	//设置文件保存路径
	[request setDownloadDestinationPath:savePath];
	//设置临时文件路径
	[request setTemporaryFileDownloadPath:tempPath];
    //设置进度条的代理,
	[request setDownloadProgressDelegate:self];
	//设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:YES];
    
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"2" forKey:@"2"]];
    
    [request setDownloadCache:self.myCache];
     [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    request.tag = 200;
	//添加到ASINetworkQueue队列去下载
	[self.netWorkQueue addOperation:request];
    [self.netWorkQueue go];
    	//收回request
	[request release];
    }*/
    
    NSURL *url = [NSURL URLWithString:@"http://dl_dir.qq.com/invc/qqpinyin/QQPinyin_Setup_4.6.2028.400.exe"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    NSURLConnection *connection  = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (IBAction)downLoad:(id)sender {
  
    NSURL *url = [NSURL URLWithString:@"http://dl_dir.qq.com/invc/qqpinyin/QQPinyin_Setup_4.6.2028.400.exe"];
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.tag = 100;
	//设置ASIHTTPRequest代理
	request.delegate = self;
    //初始化保存ZIP文件路径
   NSString *savePath = [self.myPath stringByAppendingPathComponent:[NSString stringWithFormat:@"QQ_%d.zip",[sender tag]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
//        self.myProess.progress = 1.0f;
//        return;
    }
	//初始化临时文件路径
	NSString *tempPath = [self.myPath stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/QQ_%d.zip",[sender tag]]];
   
	//设置文件保存路径
	[request setDownloadDestinationPath:savePath];
	//设置临时文件路径
	[request setTemporaryFileDownloadPath:tempPath];
    //设置进度条的代理,
	[request setDownloadProgressDelegate:self];
	//设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:YES];
   
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"1" forKey:@"1"]];
[request setDownloadCache:self.myCache];
 [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    [ request setShouldContinueWhenAppEntersBackground:YES ];

    
	//添加到ASINetworkQueue队列去下载
	[self.netWorkQueue addOperation:request];
    [self.netWorkQueue go];

	//收回request
	[request release];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"error:%@",error);
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSLog(@"responseData:%@",request.responseData);
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"error:%@",error);
}

- (IBAction)stopDownLoad:(id)sender{
    
    self.netWorkQueue.shouldCancelAllRequestsOnFailure = NO;
    for (ASIHTTPRequest *request in [self.netWorkQueue operations]) {
      
        if (request.tag == 100) {
            [request clearDelegatesAndCancel];
        }
    }
}

- (IBAction)stop:(id)sender{
    
    self.netWorkQueue.shouldCancelAllRequestsOnFailure = NO;
    for (ASIHTTPRequest *request in [self.netWorkQueue operations]) {
        if (request.tag == 200) {
            [request clearDelegatesAndCancel];
        }
    }
}

- (void)setProgress:(float)newProgress{
    NSLog(@"newProgress:%f",newProgress);
    self.myProess.progress = newProgress;
}

//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小，可以显示下载进度多少字节
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
	NSLog(@"didReceiveResponseHeaders-%@",[responseHeaders valueForKey:@"Content-Length"]);
    NSLog(@"contentlength=%f",request.contentLength/1024.0/1024.0);
}
//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
//   
//
//    NSLog(@"data:%@",data);
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myProess release];
    [_secMyProess release];
    [super dealloc];
}
@end
