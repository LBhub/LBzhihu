//
//  StartViewController.m
//  LBzhihu
//
//  Created by lb on 15/11/3.
//  Copyright © 2015年 李波. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()<UIScrollViewDelegate>
{
    NSArray *imgs;
}

@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) UIButton *beginBtn;


@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    imgs = @[@"icon.bundle/start1.png",@"icon.bundle/start2.png"];
    
    [self addUI];
}


- (void)addUI{
    CGFloat width = CGRectGetWidth(self.view.frame);
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(width * imgs.count, CGRectGetHeight(self.view.frame)) ;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    int i = 0;
    for (NSString *imageName in imgs) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, CGRectGetHeight(self.view.frame))];
        imageView.image = [UIImage imageNamed:imageName];
        i ++;
        [self.scrollView addSubview:imageView];
        
        if (i == imgs.count - 1) {
            
            self.beginBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 40, CGRectGetWidth(self.view.frame), 40)];
            [self.beginBtn setTitle:@"开始" forState:(UIControlStateNormal)];
            [self.beginBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
            [self.beginBtn addTarget:self action:@selector(goMainView) forControlEvents:(UIControlEventTouchUpInside)];
            [imageView addSubview:self.beginBtn];
        }
    }
    
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(width * 0.2, CGRectGetHeight(self.view.frame) * 0.8, width * 0.6, 40)];
    self.pageControl.numberOfPages = imgs.count;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int offsetX = scrollView.contentOffset.x + (self.view.frame.size.width * 0.5);
    
    self.pageControl.currentPage = offsetX / self.view.frame.size.width;
}

- (void)goMainView{
    NSLog(@"ddd");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
