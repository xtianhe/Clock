//
//  SoundViewController.m
//  Clock
//
//  Created by mehome-Tim on 2018/8/30.
//  Copyright © 2018 MH. All rights reserved.
//

#import "SoundViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

@interface SoundViewController ()
{
    NSArray *titleArray;
    NSArray *musicArray;

}
@property (nonatomic, retain) NSIndexPath *checkedItem;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation SoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"铃声";
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okAction)];
   
   
    self.navigationItem.rightBarButtonItem = btn;
    
    musicArray = @[
                   @"bayin.caf",
                   @"lightM_02.caf",
                   @"jingdian.caf",
                   @"huakai.caf",
                 
                   
                   ];
    
    titleArray = @[
                   @"八音盒",
                   @"经典",
                   @"经典2",
                   @"花开花落",
                 
                   
                   ];

    self.tableView.backgroundColor = [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:244.f/255.f alpha:1];
    self.tableView.tableFooterView = [UIView new];
    
    self.checkedItem = [NSIndexPath indexPathForRow:self.musicTag inSection:0];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)okAction{
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectMusic:)]) {
        [_delegate selectMusic:self.checkedItem.row];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}
- (void)selectCell:(UITableViewCell *)cell {
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    //[[cell textLabel] setTextColor:COLOR_GREEN];
    //IASK_IF_PRE_IOS7([[cell textLabel] setTextColor:kIASKgrayBlueColor];);
    
}

- (void)deselectCell:(UITableViewCell *)cell {
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    // [[cell textLabel] setTextColor:[UIColor darkGrayColor]];
    //IASK_IF_PRE_IOS7([[cell textLabel] setTextColor:[UIColor darkTextColor]];);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"kCellValue"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCellValue"];
        cell.tintColor = [UIColor blueColor];
        [[cell textLabel] setTextColor:[UIColor darkGrayColor]];
    }
    
    if ([indexPath isEqual:[self checkedItem]]) {
        [self selectCell:cell];
    } else {
        [self deselectCell:cell];
    }
    
    @try {
        [[cell textLabel] setText:[titleArray objectAtIndex:indexPath.row]];
    }
    @catch (NSException * e) {}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath == [self checkedItem]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    // NSArray *values         = [_currentSpecifier multipleValues];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self deselectCell:[tableView cellForRowAtIndexPath:[self checkedItem]]];
    [self selectCell:[tableView cellForRowAtIndexPath:indexPath]];
    [self setCheckedItem:indexPath];
    
    [self playSound];
    

    
    
}

-(void)playSound{
    
  
    // 1. 定义要播放的音频文件的URL
 
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:[musicArray objectAtIndex:self.checkedItem.row] withExtension:@""];
    [self.audioPlayer pause];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    self.audioPlayer.numberOfLoops = 1;
    // 5.开始播放
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
}


@end
