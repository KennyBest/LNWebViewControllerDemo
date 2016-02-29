//
//  ViewController.m
//  LNWebViewControllerDemo
//
//  Created by lining on 16/2/29.
//  Copyright © 2016年 lining. All rights reserved.
//

#import "ViewController.h"
#import "LNWebViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
- (IBAction)loadUrlCententSource:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadUrlCententSource:(id)sender {
    LNWebViewController *webViewController = [[LNWebViewController alloc] initWithUrl:self.urlTextField.text];
    [self.navigationController pushViewController:webViewController animated:YES];
}
@end
