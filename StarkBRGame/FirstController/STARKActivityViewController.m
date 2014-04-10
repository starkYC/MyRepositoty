//
//  STARKActivityViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKActivityViewController.h"
#import "ActivityCell.h"
#import "STARKActivityDetailViewController.h"

#import "MJRefresh.h"
#import "YCGameMgr.h"
#import "YCFileMgr.h"
#import "YCNotifyMsg.h"
#import "GDataXMLNode.h"
#import "BoutiqueModel.h"

@interface STARKActivityViewController ()
{
    NSMutableArray *_dataArray;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger Flag;
}

@end

@implementation STARKActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         Flag = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;

    _dataArray  = [[NSMutableArray alloc] init];
    
    // 1集成刷新控件
    // 1.1.下拉刷新
    [self addHeader];    
    // 1.2.上拉加载更多
    [self addFooter];
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [[MJRefreshHeaderView alloc] init];
    header.scrollView = self.activityTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        Flag = 1;
        STRLOG(@"active");
        self.reqPage  = 190;
        NSString *str =@"https://itunes.apple.com/br/rss/topfreeapplications/limit=10/genre=6014/xml";
        [self ActivitystartRequest:str];
        STRLOG(@"%@----开始进入刷新状态", refreshView.class);
    };
    [header beginRefreshing];
    _header = header;
}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.activityTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSString *strUrl = @"https://itunes.apple.com/br/rss/topfreeapplications/limit=10/genre=6014/xml";
        Flag = 0;
        self.reqPage ++;
        [self ActivitystartRequest:strUrl];
        STRLOG(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}
- (void)ActivitystartRequest:(NSString *)url{
   
    if (![self checkNetWork]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的网络异常，请检查后重新刷新" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self fillReqRefresh];
        return;
    }
    STRLOG(@"check");
    /*
     下拉刷新
     */
    if (self.reqPage == 1 && (self.locPage != 0 || self.reqPage<=self.locPage) ) {
        //清除activityData目录下游戏数据
        STRLOG(@"clear all activityData");
        [YCFileMgr removeFile:[YCFileMgr getActivityDataFile]];
    }

    if ([self checkOutLocalData:@"activity" andPage:self.reqPage]) {
        self.locPage = self.reqPage;
        [self reloadData:self.Data];
    }else{
        [self startRequest:@"activity" andUrl:url];
    }
}

- (void)fillReqRefresh{
    
    if (Flag == 1) {
        [self doneWithView:_header];
    }else{
        [self doneWithView:_footer];
    }
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    STRLOG(@"done");

  // [super doneWithView:refreshView];
    [refreshView endRefreshing];
    // 刷新表格
    [self.activityTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
}

- (void)DataReceicve:(NSNotification*)Notifi{
    
    [super DataReceicve:Notifi];
    if ( [YCNotifyMsg shareYCNotifyMsg].code == 0) {
        [self reloadData:self.Data];
    }
    [self fillReqRefresh];
}

- (NSString *)getValueWithElement:(GDataXMLElement *)element childName:(NSString *)name{
    
    NSArray *array = [element elementsForName:name];
    GDataXMLElement *child = (GDataXMLElement  *)[array objectAtIndex:0];
    return child.stringValue;
}

- (void)reloadData:(NSData*)data{
    
    if (Flag == 1) {
        [_dataArray removeAllObjects];
    }
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    //拿到根元素(节点)
    GDataXMLElement *root = [doc rootElement];
    NSArray *entrys = [root elementsForName:@"entry"];
    NSMutableArray *array = [NSMutableArray array];
    for (GDataXMLElement *entry in entrys) {
        NSString *title = [self getValueWithElement:entry childName:@"title"];
        NSString *summary = [self getValueWithElement:entry childName:@"summary"];
        NSString *appID = [self getValueWithElement:entry childName:@"id"];
        NSString *imageAdr = [self getValueWithElement:entry childName:@"im:image"];
        NSString *price = [self getValueWithElement:entry childName:@"im:price"];
        BoutiqueModel *model = [[BoutiqueModel alloc] init];
        model.price = price;
        model.title = title;
        model.summary = summary;
        model.imageAdr = imageAdr;
        model.appID = appID;
        [array addObject:model];
    }
    [_dataArray addObject:array];
    [self fillReqRefresh];
}


#pragma mark --tableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   STARKActivityDetailViewController *detail = [[STARKActivityDetailViewController alloc] initWithNibName:@"STARKActivityDetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:detail animated:YES];
    
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    int count = (int)(section +1);
    NSString *title = [NSString stringWithFormat:@"第%d页",count];
    return title;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

#pragma mark --tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
      return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)[[_dataArray objectAtIndex:section] count]);
    return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle ] loadNibNamed:@"ActivityCell" owner:self options:nil] lastObject];
    }
    NSArray *array  = [_dataArray objectAtIndex:indexPath.section];
    BoutiqueModel *model = [array objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.title;
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
