//
//  HeadView.m
//  StarkBRGame
//
//  Created by Spring on 14-4-9.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置图片墙
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(320*5, 150);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
       
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(130, 100, 39, 37)];
        _pageControl.numberOfPages = 5;
        _pageControl.currentPage = 0;
        
        for (int i =0; i<5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320,0,320,150)];
            imageView.image = image;
            [_scrollView addSubview:imageView];
        }
        [self addSubview:_scrollView];
        [self addSubview:_pageControl];
    }
    return self;
}
//重写imageURL的Setter方法
-(void)setImageURL:(NSString *)imageURL
{
   
    if(self.imageURL)
    {
        //确定图片的缓存地址
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        NSString *tmpPath=[docDir stringByAppendingPathComponent:@"AsynImage"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:tmpPath])
        {
            [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSArray *lineArray = [self.imageURL componentsSeparatedByString:@"/"];
        self.fileName = [NSString stringWithFormat:@"%@/%@", tmpPath, [lineArray objectAtIndex:[lineArray count] - 1]];
        
        //判断图片是否已经下载过，如果已经下载到本地缓存，则不用重新下载。如果没有，请求网络进行下载。
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:_fileName])
        {
            //下载图片，保存到本地缓存中
            [self loadImage];
        }
        else
        {
            //本地缓存中已经存在，直接指定请求的网络图片
           loadData = [NSMutableData dataWithContentsOfFile:_fileName];
        }
    }
}

//网络请求图片，缓存到本地沙河中
-(void)loadImage
{
    //    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.imageURL]];
    //    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    //    [conn start];
    
    //对路径进行编码
    @try {
        //请求图片的下载路径
        //定义一个缓存cache
        // NSURLCache *urlCache = [NSURLCache sharedURLCache];
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:1*124*1024 diskCapacity:1*1024*1024 diskPath:_fileName];
        /*设置缓存大小为1M*/
        // [urlCache setMemoryCapacity:1*1024*1024];
        
        //设子请求超时时间为30s
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.imageURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        
        //从请求中获取缓存输出
        NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
        [cache storeCachedResponse:response forRequest:request];
        
        if(response != nil)
        {
            //            NSLog(@"如果又缓存输出，从缓存中获取数据");
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        }
        
        /*创建NSURLConnection*/
        if(!connection)
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        //开启一个runloop，使它始终处于运行状态
        
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    }
    @catch (NSException *exception) {
        //        NSLog(@"没有相关资源或者网络异常");
    }
    @finally {
        ;//.....
    }
}

#pragma mark - NSURLConnection Delegate Methods
//请求成功，且接收数据(每接收一次调用一次函数)
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(loadData==nil)
    {
        loadData=[[NSMutableData alloc]initWithCapacity:2048];
    }
    [loadData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //打印状态码
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *newREsponse=(NSHTTPURLResponse*)response;
        
        NSLog(@"状态码:%ld",(long)[newREsponse statusCode]);
    }
    
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
    //    NSLog(@"将缓存输出");
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //    NSLog(@"即将发送请求");
    return request;
}
//下载完成，将文件保存到沙河里面
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    //图片已经成功下载到本地缓存，指定图片
    if([loadData writeToFile:_fileName atomically:YES])
    {
        
        // 根据data 给scrollview 赋图
    }
    
    connection = nil;
    loadData = nil;
    
}
//网络连接错误或者请求成功但是加载数据异常
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    //如果发生错误，则重新加载
    connection = nil;
    loadData = nil;
    [self loadImage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // NSLog(@"x:%f",scrollView.contentOffset.x);
    // NSLog(@"y:%f",scrollView.contentOffset.y);
    CGPoint pt = scrollView.contentOffset;
    //通过scrollView的偏移量，更新页码显示
    _pageControl.currentPage = pt.x/320;
    NSLog(@"%ld",(long)_pageControl.currentPage);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end