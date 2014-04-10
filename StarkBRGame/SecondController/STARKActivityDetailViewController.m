//
//  STARKActivityDetailViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKActivityDetailViewController.h"

@interface STARKActivityDetailViewController ()

@end

@implementation STARKActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;

        self.navigationItem.title = @"活动详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.view.bounds = [[UIScreen mainScreen] bounds];
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *three = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
    UIBarButtonItem *four = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:nil];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //toolbar是整个navigation堆栈里的view共同的,但toolbar上面的items却是每个view单独拥有的
    //现在只是设置了当前view的toolbaritem,与其他view的toolbaritme是没有关系的
    
    [self setToolbarItems:[NSArray arrayWithObjects:flexItem, three, flexItem, four, flexItem, nil]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
