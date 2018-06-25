//
//  ViewController.m
//  ZoomCollectionView
//
//  Created by Marshal on 2018/6/20.
//  Copyright © 2018年 Marshal. All rights reserved.
//

#import "ViewController.h"
#import "LSZoomFlowLayout.h"

static NSString *LSCollectionIdentifier = @"LSCollectionIdentifier";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataAry;

@property (nonatomic, weak) LSZoomFlowLayout<LSZoomFlowLayoutDelegate> *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initCollection];
}

- (void)initData {
    _dataAry = [NSMutableArray array];
    
}

- (void)initCollection {
    LSZoomFlowLayout *layout = [LSZoomFlowLayout defalutFlowLayout];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.layout = layout;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LSCollectionIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_layout scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_layout scrollViewDidEndDragging:scrollView willDecelerate:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_layout scrollViewDidEndDecelerating:scrollView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LSCollectionIdentifier forIndexPath:indexPath];
    UIColor *color = nil;
    NSInteger r = indexPath.row % 4;
    if (r == 0) {
        color = [UIColor greenColor];
    }else if (r == 1) {
        color = [UIColor redColor];
    }else if (r == 2) {
        color = [UIColor grayColor];
    }else {
        color = [UIColor yellowColor];
    }
    cell.contentView.backgroundColor = color;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
