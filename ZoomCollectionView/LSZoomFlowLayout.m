//
//  LSZoomFlowLayout.m
//  ZoomCollectionView
//
//  Created by Marshal on 2018/6/21.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "LSZoomFlowLayout.h"

static CGFloat defalutMargin = 75;//内容距离左右两侧的边距
static CGFloat defalutLineSpacing = 30;//两个item之间的最小间距

@interface LSZoomFlowLayout ()
{
    CGFloat _startX;
}


@end

@implementation LSZoomFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = defalutMargin;
        self.margin = defalutMargin;
    }
    return self;
}

+ (instancetype)defalutFlowLayout {
    LSZoomFlowLayout *layout = [[self alloc] init];
    if (layout) {
        [layout initLayout];
    }
    return layout;
}

- (void)initLayout {
    self.minimumLineSpacing = defalutLineSpacing;
    _margin = defalutMargin;
    //如果想修改itemSize的话可以在这里修改
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.itemSize = CGSizeMake(size.width-_margin*2, size.height-200);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, _margin, 0, _margin);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //获取界面内的cell属性(其实超过了一个界面)
    //防止防止更改属性的时候造成以外变更造成额外性能损耗，或者崩溃
    NSArray *ary = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    //计算当前这个屏幕的位置的中心点，在collectionView上面的实际偏移量
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat cx = self.collectionView.contentOffset.x + width/2;
    for (UICollectionViewLayoutAttributes *attr in ary) {
        //这里开始更改动画
        //开始计算控件相对于中心的距离，可以根据距离来设定偏移量
        CGFloat distance = fabs(attr.center.x-cx);
        CGFloat scale = cos(distance/width*M_PI*3/8);
        attr.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, scale);
        attr.alpha = scale;
    }
    return ary;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) [self handleItemCenter];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handleItemCenter];
}

- (void)handleItemCenter {
    //当scrollView减速的时候,判断并给视图归为
    //默认cell居中，距离两侧均为margin,间距为lineSpacing为30
    //margin系统已经计算，这里忽略
    //即第一个偏移应为0,到第n个偏移应为 (item+lineSpacing/2)*n ;实际第n偏移为(item+lineSpacing/2)*n
    
    //设置如果滑动宽度大于固定值可以下一个或者回到当前item
    CGFloat scrollMargin = 0.2;//滑动超过规定的距离可以下一个
    CGFloat itemWidth = self.itemSize.width + self.minimumLineSpacing;//实际一格长度
    CGFloat halfLineSpacing = self.minimumLineSpacing/2;//一般偏移
    
    CGFloat x = self.collectionView.contentOffset.x; //当前偏移量
    //滑动方向
    BOOL scrollToRight = YES;//是否向右滑动，默认为1;
    if (x < _startX) {
        scrollToRight = NO;//向左滑动
    }
    x += halfLineSpacing;//加上偏移量方便计算
    
    CGFloat currentX = x / itemWidth;
    CGFloat margin = currentX - (NSInteger)currentX;//最后的偏移量
    long finalIndex = (NSInteger)currentX; //最终index,先默认为当前
    if (scrollToRight) {
        if (margin > scrollMargin) {
            finalIndex += 1;
        }
    }else {
        if (margin > 1 - scrollMargin) {
            finalIndex += 1;
        }
    }

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:finalIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//当布局属性发生改变的时候界面视图跟着改变
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


@end
