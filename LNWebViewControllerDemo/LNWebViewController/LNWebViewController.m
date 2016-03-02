//
//  LNWebViewController.m
//  LNWebViewControllerDemo
//
//  Created by lining on 16/2/29.
//  Copyright © 2016年 lining. All rights reserved.
//

#import "LNWebViewController.h"
#import <WebKit/WebKit.h>

@interface LNWebViewController ()<WKNavigationDelegate>
@property (nonatomic,assign) BOOL isShowUrlTitle;

@property (nonatomic,strong) UILabel *urlTipLabel;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) WKWebView *webView;

@end

@implementation LNWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isShowUrlTitle = !self.title.length;
    self.isShowUrlTitle ? self.title = @"正在加载..." : self.title;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    //self.urlTipLabel.text = [NSString stringWithFormat:@"网页由%@提供",self.webView.URL.absoluteString];
    
    //将进度条添加到导航栏下面
    [self.navigationController.navigationBar addSubview:self.progressView];
    //添加进度条和标题 监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - lazy load
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGRect barBounds = self.navigationController.navigationBar.bounds;
        CGRect progressFrame = CGRectMake(0, barBounds.size.height, barBounds.size.width, 3.0f);
        _progressView = [[UIProgressView alloc] initWithFrame:progressFrame];
        _progressView.alpha = 0.0f;
        _progressView.progressTintColor = self.progressColor ? self.progressColor : [UIColor colorWithRed:119.0/255 green:228.0/255 blue:115.0/255 alpha:1];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}


- (UILabel *)urlTipLabel {
    if (!_urlTipLabel) {
        CGRect frame = CGRectMake(0, 10, self.view.frame.size.width, 20);
        _urlTipLabel = [[UILabel alloc] initWithFrame:frame];
        _urlTipLabel.backgroundColor = [UIColor clearColor];
        _urlTipLabel.textColor = [UIColor redColor];
        _urlTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.webView addSubview:_urlTipLabel];
        [self.webView insertSubview:_urlTipLabel belowSubview:self.webView.scrollView];
    }
    return _urlTipLabel;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - init
- (instancetype)initWithUrl:(NSString *)url {
    if ((self = [super init])) {
        [self.url hasPrefix:@"http://"]?(self.url = url):(self.url = [NSString stringWithFormat:@"http://%@",url]);
    }
    return self;
}

#pragma mark - observer 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }
}

#pragma mark - overide
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title" context:NULL];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.progressView removeFromSuperview];
}
@end
