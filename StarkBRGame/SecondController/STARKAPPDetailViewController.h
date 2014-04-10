//
//  STARKAPPDetailViewController.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "BoutiqueModel.h"

@interface STARKAPPDetailViewController : RootViewController<UIScrollViewDelegate>
{
    //截图放大
    UIScrollView *_bigScrollView;
    UIPageControl *_pageControl;
}
@property (nonatomic,assign) BoutiqueModel *model;

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *screenShotView;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *devLabel;
@property (weak, nonatomic) IBOutlet UILabel *lanLabel;
@property (weak, nonatomic) IBOutlet UILabel *sistemLabel;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UIView *contentView;



@end
