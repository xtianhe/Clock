//
//  ClockTableViewCell.h
//  Clock
//
//  Created by mehome-Tim on 2018/8/30.
//  Copyright © 2018 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClockTableViewCellDelegate<NSObject>
@optional

-(void)valuceChage:(UISlider *)sender;


@end

@interface ClockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISlider *learnTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider *restTimeSlider;

@property (weak, nonatomic)IBOutlet UILabel * learnTimelabel ;

@property (weak, nonatomic)IBOutlet UILabel * restTimelabel ;
@property (weak, nonatomic) IBOutlet UILabel *learnMusicLabel;
@property (weak, nonatomic) IBOutlet UILabel *restMusicLabel;


@property (nonatomic, weak, nullable) id <ClockTableViewCellDelegate> delegate;

@end
