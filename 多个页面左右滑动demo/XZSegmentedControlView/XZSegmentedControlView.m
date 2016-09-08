//
//  XZSegmentedControlView.m
//  多个页面左右滑动demo
//
//  Created by xuzhen on 16/7/26.
//  Copyright © 2016年 FIF. All rights reserved.
//

#import "XZSegmentedControlView.h"
#import "XZSegmentCollectionViewCell.h"

@interface XZSegmentedControlView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIScrollView *_titleScrollView;
    UIButton *_selectedBtn;
    UICollectionView *_collectionView;
    NSInteger _count;
}
@end

@implementation XZSegmentedControlView
+(XZSegmentedControlView *)segmentControlViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _count=0;
    }
    return self;
}
-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray=titleArray;
    if (_selectedTitleArray) {
        [self createButtonAndSelectedView];
    }
}
-(void)setSelectedTitleArray:(NSArray *)selectedTitleArray
{
    _selectedTitleArray=selectedTitleArray;
    if (_titleArray) {
        [self createButtonAndSelectedView];
    }
}
-(void)createButtonAndSelectedView
{
    if (!_titleScrollView) {
        [self createUICollectionView];
        _titleScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        _titleScrollView.backgroundColor=[UIColor whiteColor];
        _titleScrollView.contentOffset=CGPointMake(0, 0);
        [self addSubview:_titleScrollView];
        CGFloat buttonWidth=0;
        if (self.titleArray.count<=5) {
            _titleScrollView.scrollEnabled=NO;
            buttonWidth=self.frame.size.width/self.titleArray.count;
            _titleScrollView.contentSize=CGSizeMake(0, 0);
        } else {
            _titleScrollView.scrollEnabled=YES;
            buttonWidth=self.frame.size.width/5;
            _titleScrollView.contentSize=CGSizeMake(self.titleArray.count*buttonWidth, 0);
        }
        for (int i=0; i<self.titleArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=[UIColor whiteColor];
            btn.frame=CGRectMake(i*buttonWidth, 0, buttonWidth, 47);
            btn.tag=100+i;
            [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:_normalColor==nil?[UIColor blackColor]:_normalColor forState:UIControlStateNormal];
            [btn setTitle:self.selectedTitleArray[i] forState:UIControlStateSelected];
            [btn setTitleColor:_selectedColor==nil?[UIColor cyanColor]:_selectedColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [_titleScrollView addSubview:btn];
            UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height, btn.frame.size.width, 3)];
            view1.backgroundColor=[UIColor whiteColor];
            view1.tag=2;
            [btn addSubview:view1];
            if (i==0) {
                btn.selected=YES;
                _selectedBtn=btn;
                view1.backgroundColor=_selectedColor==nil?[UIColor cyanColor]:_selectedColor;
            } else {
                btn.selected=NO;
                view1.backgroundColor=[UIColor whiteColor];
            }
        }
    }
}
-(void)btnTouch:(UIButton *)sender
{
    [self changeSelectedBtn:sender];
    
    //collctionView滚动到指定位置。
    NSIndexPath *scrollIndexPath=[NSIndexPath indexPathForRow:(sender.tag-100) inSection:0];
    [_collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
-(void)changeSelectedBtn:(UIButton *)willSelectedBtn
{
    _selectedBtn.selected=NO;
    UIView *selectedView=[_selectedBtn viewWithTag:2];
    selectedView.backgroundColor=[UIColor whiteColor];
    willSelectedBtn.selected=YES;
    _selectedBtn=willSelectedBtn;
    UIView *view1=[willSelectedBtn viewWithTag:2];
    view1.backgroundColor=_selectedColor==nil?[UIColor cyanColor]:_selectedColor;
    
    if (willSelectedBtn.tag-100>1&&willSelectedBtn.tag-100<self.titleArray.count-2&&self.titleArray.count>5) {
        
        [_titleScrollView setContentOffset:CGPointMake(willSelectedBtn.frame.size.width*(willSelectedBtn.tag-100-2), 0) animated:YES];
    }
}
-(void)createUICollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize=CGSizeMake(self.frame.size.width, self.frame.size.height);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing=0.0f;
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, _titleScrollView.frame.size.height+_titleScrollView.frame.origin.y, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.pagingEnabled=YES;
    _collectionView.showsHorizontalScrollIndicator=NO;
    [self addSubview:_collectionView];
    [_collectionView registerClass:NSClassFromString(@"XZSegmentCollectionViewCell") forCellWithReuseIdentifier:@"SegmentCell"];
}
#pragma mark-UICollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XZSegmentCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SegmentCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0.1);
}
#pragma mark-collctionView拖拽功能。
//结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UICollectionView class]]&&_count==1) {
        NSInteger row=(scrollView.contentOffset.x+self.frame.size.width/2.0)/self.frame.size.width;
        NSLog(@"row========%ld",row);
        UIButton *btn=(UIButton *)[_titleScrollView viewWithTag:(100+row)];
        [self changeSelectedBtn:btn];
    }
}
//结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        _count=1;
    }
}
@end