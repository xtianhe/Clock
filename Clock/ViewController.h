//
//  ViewController.h
//  Clock
//
//  Created by mehome-Tim on 2018/8/30.
//  Copyright © 2018 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockTableViewCell.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;

@property (weak, nonatomic) UILabel * learnTimelabel ;

@property (weak, nonatomic) IBOutlet UILabel *timeCountLable;
@property (weak, nonatomic) UILabel * restTimelabel ;

- (IBAction)beginAction:(id)sender;
- (IBAction)endAction:(id)sender;

@end

