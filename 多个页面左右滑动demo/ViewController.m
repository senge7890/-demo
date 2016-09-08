//
//  ViewController.m
//  多个页面左右滑动demo
//
//  Created by xuzhen on 16/7/26.
//  Copyright © 2016年 FIF. All rights reserved.
//

#import "ViewController.h"
#import "XZSegmentedControlView/XZSegmentedControlView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *array=[NSArray arrayWithObjects:@"心",@"肝",@"脾",@"肺",@"肾",@"火",@"木",@"土",@"金",@"水",nil];
    XZSegmentedControlView *segmentedView=[XZSegmentedControlView segmentControlViewWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    segmentedView.normalColor=[UIColor blackColor];
    segmentedView.selectedColor=[UIColor colorWithRed:174.0f/255.0f green:199.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    /**
     *  注意：
     *
     *  titleArray为未选中状态时的头部标题名称数组。
     *  selectedTitleArray为选中状态时的头部标题名称数组。
     *  如果两个都一样的话请都传。两个数组的个数和各自的对应关系都必须一样。
     */
    segmentedView.titleArray=array;
    segmentedView.selectedTitleArray=array;
    [self.view addSubview:segmentedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
