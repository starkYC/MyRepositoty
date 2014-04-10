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
        
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self  setValueForUI];

}

- (void)setValueForUI{
    
    NSRange range = [_model.title rangeOfString:@"-"];
    if (range.location != NSNotFound) {
        NSString * str = [_model.title substringToIndex:range.location];
         self.navigationItem.title = str;
        // model.title = str;
    }
    [_appImage setImageWithURL:[NSURL URLWithString:_model.imageAdr]];
   // _appTitle.text = _model.title;
        _appPrice.text = _model.price;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end