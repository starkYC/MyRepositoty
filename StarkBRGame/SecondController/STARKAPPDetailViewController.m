//
//  STARKAPPDetailViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKAPPDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface STARKAPPDetailViewController ()

@end

@implementation STARKAPPDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self initToolBar];
    [self initData];
}

- (void)initToolBar{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.toolbarHidden = NO;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back setFrame:CGRectMake(10, 5, 50, 30)];
    [back addTarget:self action:@selector(backtoRoot) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    [down setTitle:@"down" forState:UIControlStateNormal];
    [down setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [down setFrame:CGRectMake(200, 5, 50, 30)];
    [down addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *downItem = [[UIBarButtonItem alloc] initWithCustomView:down];
   
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //toolbar是整个navigation堆栈里的view共同的,但toolbar上面的items却是每个view单独拥有的
    //现在只是设置了当前view的toolbaritem,与其他view的toolbaritme是没有关系的
     [self setToolbarItems:[NSArray arrayWithObjects:backItem,flexItem, downItem,flexItem, nil]];
   // [self setToolbarItems:[NSArray arrayWithObjects:flexItem, backItem, flexItem, downItem, flexItem, nil]];
}

- (void)download{
}
- (void)backtoRoot{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData{
    
    NSRange range = [_model.title rangeOfString:@"-"];
    if (range.location != NSNotFound) {
        NSString * str = [_model.title substringToIndex:range.location];
         _titleLabel.text = str;
        // model.title = str;
    }
    [_imgView setImageWithURL:[NSURL URLWithString:_model.imageAdr]];
   
    
    //调整frame
    CGSize size = [_model.summary sizeWithFont:_summaryLabel.font constrainedToSize:CGSizeMake(_summaryLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect summaryFrame = _summaryLabel.frame;
    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, size.height-summaryFrame.size.height + _contentView.frame.size.height);
    _lineLabel.frame = CGRectMake(_lineLabel.frame.origin.x, _lineLabel.frame.origin.y+size.height-summaryFrame.size.height, _lineLabel.frame.size.width, _lineLabel.frame.size.height);
    
    NSString *s = @"11111111112"@"1111111111213486465464dsadasdljlasjeqowiejqwoihdklsandaskjdhaskfhakshedqweqwdasdqwljelqwfalksfalsfhdsadasfasfasfasf";
    CGSize si = [s sizeWithFont:_sistemLabel.font constrainedToSize:CGSizeMake(_sistemLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect sistemFrame = _sistemLabel.frame;
    _otherView.frame = CGRectMake(_otherView.frame.origin.x, _otherView.frame.origin.y + size.height - summaryFrame.size.height, _otherView.frame.size.width, si.height - sistemFrame.size.height +_otherView.frame.size.height);
    summaryFrame.size.height = size.height;
    _summaryLabel.frame = summaryFrame;
     _summaryLabel.text = _model.summary;
    NSLog(@"y:%.2f",_lineLabel.frame.origin.y);
    NSLog(@"h:%.2f",summaryFrame.size.height);
    sistemFrame.size.height = si.height;
    _sistemLabel.frame = sistemFrame;
    _sistemLabel.text = s;
    NSLog(@"x:%.2f",_otherView.frame.origin.y);
    NSLog(@"h:%.2f",_otherView.frame.size.height);
    
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.frame.size.width, _otherView.frame.size.height+_otherView.frame.origin.y);
}

- (void)changeFrame:(id)sender{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
