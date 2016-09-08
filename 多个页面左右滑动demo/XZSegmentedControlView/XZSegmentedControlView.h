//
//  XZSegmentedControlView.h
//  多个页面左右滑动demo
//
//  Created by xuzhen on 16/7/26.
//  Copyright © 2016年 FIF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZSegmentedControlView : UIView
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *selectedTitleArray;
@property(nonatomic,strong)UIColor *normalColor;
@property(nonatomic,strong)UIColor *selectedColor;
+(XZSegmentedControlView *)segmentControlViewWithFrame:(CGRect)frame;
@end
