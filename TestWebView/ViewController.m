//
//  ViewController.m
//  TestWebView
//
//  Created by Jason Cross on 3/23/17.
//  Copyright © 2017 Athletigen Technologies, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView * placeholderWebView;
@end

@implementation ViewController

- (void) awakeFromNib {
    [super awakeFromNib];
    self.htmlFileName = @"TestPage";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect oldFrame = self.placeholderWebView.frame;
    
    self.webView = [[WKWebView alloc] initWithFrame:oldFrame];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.panGestureRecognizer.enabled = NO;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    [self copyConstraintsFromView:self.placeholderWebView toView:self.webView];
    [self.placeholderWebView removeFromSuperview];

    if(nil != self.htmlFileName) {
        [self loadWebViewWithLocalFileName:self.htmlFileName];
    }
}

- (void)copyConstraintsFromView:(UIView *)sourceView toView:(UIView *)destView
{
    for (NSLayoutConstraint *constraint in sourceView.superview.constraints) {
        if (constraint.firstItem == sourceView)
        {
            [sourceView.superview addConstraint:[NSLayoutConstraint constraintWithItem:destView
                                                                             attribute:constraint.firstAttribute
                                                                             relatedBy:constraint.relation
                                                                                toItem:constraint.secondItem
                                                                             attribute:constraint.secondAttribute
                                                                            multiplier:constraint.multiplier
                                                                              constant:constraint.constant]];
        }
        else if (constraint.secondItem == sourceView)
        {
            [sourceView.superview addConstraint:[NSLayoutConstraint constraintWithItem:constraint.firstItem
                                                                             attribute:constraint.firstAttribute
                                                                             relatedBy:constraint.relation
                                                                                toItem:destView
                                                                             attribute:constraint.secondAttribute
                                                                            multiplier:constraint.multiplier
                                                                              constant:constraint.constant]];
        }
    }
}


- (void) loadWebViewWithLocalFileName:(NSString*)webFileName {
    NSError* error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:webFileName ofType: @"html"];
    NSString *res = [NSString stringWithContentsOfFile: path encoding:NSUTF8StringEncoding error: &error];
    
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    if(nil == error) {
        [self.webView loadHTMLString:res baseURL:baseURL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  Web View Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest * request = navigationAction.request;
    
    [[UIApplication sharedApplication] openURL:[request URL]];
    decisionHandler(WKNavigationActionPolicyAllow);
}


@end
