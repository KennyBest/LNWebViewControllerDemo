//
//  LNWebViewController.h
//  LNWebViewControllerDemo
//
//  Created by lining on 16/2/29.
//  Copyright © 2016年 lining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNWebViewController : UIViewController

/**
 *  请求URL
 */
@property (nonatomic,copy) NSString *url;

/**
 *  进度条颜色
 */
@property (nonatomic,strong) UIColor *progressColor;

@property (nonatomic,assign) BOOL isShowOrigin;

/**
 *  init方法
 *
 *  @param url 请求url
 *
 *  @return instancetype
 */
- (instancetype)initWithUrl:(NSString *)url;
@end
