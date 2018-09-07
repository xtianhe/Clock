//
//  SoundViewController.h
//  Clock
//
//  Created by mehome-Tim on 2018/8/30.
//  Copyright © 2018 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SoundViewDelegate<NSObject>
@optional

-(void)selectMusic:(NSInteger)tag;


@end
@interface SoundViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger musicTag;

@property (nonatomic, weak, nullable) id <SoundViewDelegate> delegate;


@end
