//
//  ViewController.m
//  Clock
//
//  Created by mehome-Tim on 2018/8/30.
//  Copyright © 2018 MH. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"

#define DefaultLearnTime 15
#define DefaultRestTime  5

@interface ViewController ()<ClockTableViewCellDelegate,SoundViewDelegate>
{
    NSInteger colockStatus; //0 休息 1 学习
    NSInteger learnTime;
    NSInteger restTime;
    NSInteger secondsCountDown;
    NSTimer * countDownTimer;
    
    SystemSoundID inSystemSoundID;
    NSInteger musicTag;
    NSInteger musicRestTag;
    NSInteger musicLearnTag;
    NSInteger selectTypeTag; //0 学习 1 休息
    
    NSArray *musicArray;
    NSArray *titleArray;

    
}
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    self.title = @"闹铃";
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.backgroundColor = [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:244.f/255.f alpha:1];
//    secondsCountDown = 15*60;
//    learnTime = 15*60;
//    restTime = 15*60;
    
    musicRestTag = [[NSUserDefaults standardUserDefaults] integerForKey:@"musicRestTag"];
    musicLearnTag = [[NSUserDefaults standardUserDefaults] integerForKey:@"musicLearnTag"];
    if (musicRestTag == 0) {
        musicRestTag = 2;
    }
    if (musicLearnTag == 0) {
        musicLearnTag = 3;
    }
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushActionNotify:)
                                                 name:kwillPushActoinNotify
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterFrontNotify:)
                                                 name:kwillEnterFrontgroudNotify
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterBackgroudNotify:)
                                                 name:kwillEnterBackgroudNotify
                                               object:nil];
    
    [self willEnterFrontNotify:nil];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kwillPushActoinNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kwillEnterFrontgroudNotify object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kwillEnterBackgroudNotify object:nil];

}

-(void)pushActionNotify:(NSNotification*)notify{
    
    NSString *actionId = [notify object];
    
    if ([actionId isEqualToString:@"beginRest"]) {
        
    } else if ([actionId isEqualToString:@"beginLearn"]){
        
    }
    
    
}

-(void)willEnterFrontNotify:(NSNotification*)notify{
    
    NSDate *beginDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"beginDate"];
    NSDate * date = [NSDate date];
    
    colockStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"colockStatus"];
    learnTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"learnTime"];
    restTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"restTime"];
    if (learnTime == 0) {
        
        learnTime = DefaultLearnTime*60;
    }
    if (restTime == 0) {
        restTime = DefaultRestTime*60;
    }
    
    [self.tableView reloadData];
    
    if (colockStatus == 0 && beginDate) {
        NSTimeInterval interval = [date timeIntervalSinceDate:beginDate];
        if (interval < restTime) {
            
            secondsCountDown = restTime - interval;
            [self continueTimer];

        }else{
            [self timeIsUp];
        }
    }else if (colockStatus == 1 && beginDate){
        
        NSTimeInterval interval = [date timeIntervalSinceDate:beginDate];
        if (interval < learnTime) {
            
            secondsCountDown = learnTime - interval;
            
            [self continueTimer];
            
        }else{
            [self timeIsUp];
        }

    }
    
    
}

-(void)willEnterBackgroudNotify:(NSNotification*)notify{
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClockTableViewCell *cell = nil;
    if (indexPath.row == 0) {
       cell = [tableView dequeueReusableCellWithIdentifier:@"1"];

    }else if (indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"2"];
        self.learnTimelabel = cell.learnTimelabel;
        cell.learnTimeSlider.value = learnTime/60;
        self.learnTimelabel.text = [NSString stringWithFormat:@"%.f分钟",cell.learnTimeSlider.value];

        
    }else if (indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"3"];
        self.restTimelabel = cell.restTimelabel;
        cell.restTimeSlider.value = restTime/60;
         self.restTimelabel.text = [NSString stringWithFormat:@"%.f分钟",cell.restTimeSlider.value];
    }
    else if (indexPath.row == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"4"];
        
    }
    else if (indexPath.row == 4){
        cell = [tableView dequeueReusableCellWithIdentifier:@"5"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.learnMusicLabel.text = [titleArray objectAtIndex:musicLearnTag];
    }
    else if (indexPath.row == 5){
        cell = [tableView dequeueReusableCellWithIdentifier:@"6"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.restMusicLabel.text = [titleArray objectAtIndex:musicRestTag];

    }
    cell.delegate = self;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row == 4) {
        
        SoundViewController *sound = [[SoundViewController alloc] initWithNibName:@"SoundViewController" bundle:nil];
       // UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:sound];
        sound.delegate = self;
        sound.musicTag = musicLearnTag;
        selectTypeTag = 0;
        
        [self.navigationController pushViewController:sound animated:YES];
        
    }else if (indexPath.row == 5){
        SoundViewController *sound = [[SoundViewController alloc] initWithNibName:@"SoundViewController" bundle:nil];
        // UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:sound];
        sound.delegate = self;
        sound.musicTag = musicRestTag;
        selectTypeTag = 1;
        
        [self.navigationController pushViewController:sound animated:YES];
    }
}
-(void)valuceChage:(UISlider *)sender
{
    NSString * timeStr = [NSString stringWithFormat:@"%.f",sender.value];

    if (sender.tag == 100) {
        
        self.learnTimelabel.text = [NSString stringWithFormat:@"%@分钟",timeStr];
        learnTime = [timeStr integerValue] * 60;
       // NSLog(@"learn time: %@",[NSString stringWithFormat:@"%ld分钟",learnTime]);
        [[NSUserDefaults standardUserDefaults] setInteger:learnTime forKey:@"learnTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
    }else if (sender.tag == 101){
        
        self.restTimelabel.text = [NSString stringWithFormat:@"%@分钟",timeStr];
        restTime = [timeStr integerValue] * 60;
        [[NSUserDefaults standardUserDefaults] setInteger:restTime forKey:@"restTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    
}

-(void)selectMusic:(NSInteger)tag{
    
    if (selectTypeTag == 0) {
         musicLearnTag = tag;
        
        [[NSUserDefaults standardUserDefaults] setInteger:musicLearnTag forKey:@"musicLearnTag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        musicRestTag = tag;
        
        [[NSUserDefaults standardUserDefaults] setInteger:musicRestTag forKey:@"musicRestTag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.tableView reloadData];
   
}


-(void)playSound{
    

    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
   // AudioServicesPlayAlertSound(sound);

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:[musicArray objectAtIndex:musicTag] withExtension:@""];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    self.audioPlayer.numberOfLoops = -1;
    // 5.开始播放
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
}
void systemAudioCallback(SystemSoundID sound,void * clientData)
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //AudioServicesPlayAlertSound(sound);
}

//时间到
-(void)timeIsUp{
    

    
    NSString * title = nil;
    NSString * msg = nil;
    
    if (colockStatus == 0) { //休息结束...
        title = @"休息结束";
        msg = @"开始学习";
        musicTag = musicRestTag;
    }else{
        
        title = @"学习结束";
        msg = @"开始休息";
         musicTag = musicLearnTag;
    }
    
  UIAlertController * alert =  [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self beginAction:nil];
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    self.timeCountLable.text=@"00:00:00";

    [self playSound];
    [countDownTimer invalidate];
    
    
}

- (IBAction)beginAction:(UIButton*)sender {
    [self addNotify];
   // return;
    
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    
    [self.audioPlayer pause];

    self.beginBtn.enabled = NO;
    
    NSDate * date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"beginDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if (colockStatus == 0) { //开始学习
        
        secondsCountDown = learnTime;
 
        colockStatus = 1;
        [self.beginBtn setTitle:@"学习中..." forState:UIControlStateNormal];
 
    }
    else{
        
        secondsCountDown = restTime;

        colockStatus = 0;
        [self.beginBtn setTitle:@"休息中..." forState:UIControlStateNormal];

    }
    
    


    [[NSUserDefaults standardUserDefaults] setInteger:colockStatus forKey:@"colockStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [countDownTimer invalidate];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    [countDownTimer fire];
  
    
}

-(void)continueTimer{
    
    self.beginBtn.enabled = NO;

    if (colockStatus == 0) { //开始学习

        [self.beginBtn setTitle:@"休息中..." forState:UIControlStateNormal];
        
    }else{

        [self.beginBtn setTitle:@"学习中..." forState:UIControlStateNormal];
        
    }
    
    [countDownTimer invalidate];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    [countDownTimer fire];
    
}

- (IBAction)endAction:(id)sender {
    
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    [self.audioPlayer pause];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"beginDate"];
    
    [countDownTimer invalidate];

    colockStatus = 0;
    self.beginBtn.enabled = YES;
    [self.beginBtn setTitle:@"开始学习" forState:UIControlStateNormal];

    self.timeCountLable.text = @"";
   // [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
}

//实现倒计时动作
-(void)countDownAction{
    //倒计时-1
    secondsCountDown--;
    
    //重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    self.timeCountLable.text=format_time;
    
    
    //当倒计时到0时做需要的操作，比如验证码过期不能提交
    if(secondsCountDown <= 0){
        
        [self timeIsUp];
       
    }
    
}

-(void)addNotify{
    
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    if (colockStatus == 0) { //开始学习
        content.title = @"学习结束";
        content.body = @"点击开始休息";
        content.badge = @0;
        content.sound = [UNNotificationSound soundNamed:[musicArray objectAtIndex:musicLearnTag]];
        content.categoryIdentifier = @"learn_category";
        secondsCountDown = learnTime;

    }else{
        content.title = @"休息结束";
        content.body = @"点击开始学习";
        content.badge = @0;
        content.sound = [UNNotificationSound soundNamed:[musicArray objectAtIndex:musicRestTag]];
        content.categoryIdentifier = @"rest_category";
        secondsCountDown = restTime;

    }

    
    
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:secondsCountDown repeats:NO];
//
//    UNTimeIntervalNotificationTrigger *trigger2 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
//
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:@"clockIdentifier" content:content trigger:trigger1];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        NSLog(@"addNotificationRequest withCompletionHandler");
        
    }];
    

}





@end
