//
//  ClockTableViewCell.m
//  Clock
//
//  Created by mehome-Tim on 2018/8/30.
//  Copyright © 2018 MH. All rights reserved.
//

#import "ClockTableViewCell.h"

@implementation ClockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valuceChage:(UISlider *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(valuceChage:)]) {
        [_delegate valuceChage:sender];
    }
}
@end
