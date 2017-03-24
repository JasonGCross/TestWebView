//
//  ViewController.h
//  TestWebView
//
//  Created by Jason Cross on 3/23/17.
//  Copyright © 2017 Athletigen Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;

@interface ViewController : UIViewController <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (copy, nonatomic) NSString * htmlFileName;
@end

