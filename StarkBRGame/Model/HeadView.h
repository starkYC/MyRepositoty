//
//  HeadView.h
//  StarkBRGame
//
//  Created by Spring on 14-4-9.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    UIPageControl *_pageControl;
    NSURLConnection *connection;
    NSMutableData *loadData;

}
//图片对应的缓存在沙河中的路径
@property (nonatomic, retain) NSString *fileName;

//指定默认未加载时，显示的默认图片
@property (nonatomic, retain) UIImage *placeholderImage;
//请求网络图片的URL
@property (nonatomic, retain) NSString *imageURL;

@end
