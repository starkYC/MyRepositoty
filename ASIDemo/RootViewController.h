//
//  RootViewController.h
//  ASIDemo
//
//  Created by gaoyangchun on 14-3-17.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

#import "ASIDownloadCache.h"

@interface RootViewController : UIViewController<ASIHTTPRequestDelegate,ASIProgressDelegate,NSURLConnectionDelegate>

@property (retain,nonatomic) ASINetworkQueue *netWorkQueue;
@property (nonatomic,copy) NSString *myPath;
@property (nonatomic,retain)ASIDownloadCache *myCache;

@property (retain, nonatomic) IBOutlet UIProgressView *myProess;
@property (retain, nonatomic) IBOutlet UIView *secMyProess;
- (IBAction)downLoad:(id)sender ;
- (IBAction)stopDownLoad:(id)sender;
- (IBAction)secdownLoad:(id)sender;

- (IBAction)stop:(id)sender;
@end
