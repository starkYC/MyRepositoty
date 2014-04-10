//
//  RootViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "Reachability.h"
#import "ReachAble.h"
#import "MJRefresh.h"
#import "YCGameMgr.h"
#import "YCFileMgr.h"
#import "YCNotifyMsg.h"

@interface RootViewController ()
{
    NSMutableArray *_dataArray;
    
   
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSInteger Flag;
}
@end

@implementation RootViewController

@synthesize reqPage = _reqPage;
@synthesize locPage = _locPage;
@synthesize Data = _Data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        Flag = 1;
        self.locPage = 0;
        self.reqPage = 1;
        self.Data = [[NSMutableData alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (BOOL)checkOutLocalData:(NSString *)vc andPage:(NSInteger)page{
    
    if ([vc isEqualToString:@"boutique"]) {
        NSString *fileName = [NSString stringWithFormat:@"page%ld.txt",(long)page];
        NSString *gameDataPath = [YCFileMgr getGameDataFile];
        NSString *pagePath = [gameDataPath stringByAppendingPathComponent:fileName];
        NSData   *gamedata = [NSData dataWithContentsOfFile:pagePath];
        
        if (gamedata) {
            self.Data = (NSMutableData*)gamedata;
            return YES;
        }else{
            return NO;
        }

    }else if ([vc isEqualToString:@"activity"]){
        
        NSString *fileName = [NSString stringWithFormat:@"page%ld.txt",(long)page];
        NSString *avtivityDataPath = [YCFileMgr getActivityDataFile];
        NSString *pagePath = [avtivityDataPath stringByAppendingPathComponent:fileName];
        NSData   *activitydata = [NSData dataWithContentsOfFile:pagePath];
        
        if (activitydata) {
            self.Data = (NSMutableData*)activitydata;
            return YES;
        }else{
            return NO;
        }

    }else{
        return NO;
    }
}
- (BOOL)checkNetWork{
    
    BOOL isConnect = [[ReachAble reachAble] isConnectionAvailable];
    return isConnect;
}

- (void)startRequest:(NSString *)vc andUrl:(NSString *)url{
  
    STRLOG(@"%ld页,请求",(long)self.reqPage);
    [self addMessage:url method:@selector(DataReceicve:)];
    [[YCGameMgr sharedInstance] getDataFromServer:vc andUrl:url andPage:self.reqPage];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)DataReceicve:(NSNotification*)Notifi{
    
    [self removeMessage:Notifi.name];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    STRLOG(@"DataReceicve");
    STRLOG(@"code:%ld", (long)[YCNotifyMsg shareYCNotifyMsg].code);
    switch ([YCNotifyMsg shareYCNotifyMsg].code) {
        case 0:
            self.locPage = self.reqPage;
            self.Data = [[YCGameMgr sharedInstance].dict objectForKey:Notifi.name];
            break;
        case 1:
            STRLOG(@"NOTIFY_CODE_HTTP_ERR");
            [self showAlert:1];
            return;
            break;
        case 2:
            STRLOG(@"NOTIFY_CODE_RESPONDATA_ERR");
            [self showAlert:2];
            return;
            break;
        default:
            break;
    }
}

- (void)showAlert:(NSInteger)code{
  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 100;
    [alert show];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    UIAlertView *alert = (UIAlertView *)[self.view viewWithTag:100];
     [alert removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark  Custom Method

#pragma mark  NSNotificationCenter
- (void)addMessage:(NSString*)messageName method:(SEL)method{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:method name:messageName object:nil];
}

- (void)removeMessage:(NSString *)messageName{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:messageName object:nil];
}@end
