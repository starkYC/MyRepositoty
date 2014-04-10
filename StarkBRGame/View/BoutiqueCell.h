//
//  BoutiqueCell.h
//  LimitFreeDemo
//
//  Created by gaoyangchun on 14-1-7.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoutiqueModel.h"

@interface BoutiqueCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *times;

@property (nonatomic,copy) NSString *url;
- (void)fillData:(BoutiqueModel*)model;

- (IBAction)downLoadApp :(id)sender ;
@end
