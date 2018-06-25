//
//  LSZoomFlowLayout.h
//  ZoomCollectionView
//
//  Created by Marshal on 2018/6/21.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import <UIKit/UIKit.h>

//item视图居中协议
@protocol LSZoomFlowLayoutDelegate

//这些方法只需要在一样的scrollView协议里面调用即可
@required
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;//开始拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;//拖拽完毕后，开始减速，decelerate，表示直接拖拽停止了
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;//已经停止了

@end

//目前仅支持左右滑动效果
@interface LSZoomFlowLayout : UICollectionViewFlowLayout<LSZoomFlowLayoutDelegate>

@property (nonatomic, assign) CGFloat margin;//内容距离两侧的间距

+ (instancetype)defalutFlowLayout;

@end
