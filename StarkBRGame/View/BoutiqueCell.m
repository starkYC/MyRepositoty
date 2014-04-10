//
//  BoutiqueCell.m
//  LimitFreeDemo
//
//  Created by gaoyangchun on 14-1-7.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "BoutiqueCell.h"

#import "UIImageView+WebCache.h"

@implementation BoutiqueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)fillData:(BoutiqueModel*)model{
    
    if (model) {
        //设置图片
        NSRange range = [model.title rangeOfString:@"-"];
        if (range.location != NSNotFound) {
            NSString * str = [model.title substringToIndex:range.location];
            _title.text = str;
            _title.adjustsFontSizeToFitWidth = YES;
           // model.title = str;
        }
        [_image setImageWithURL:[NSURL URLWithString:model.imageAdr]];
        
        _size.text = model.size;
        _times.text = model.times;
        _version.text = model.version;
        _url = model.appID;
    }

}
- (IBAction)downLoadApp :(id)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
