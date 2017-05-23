//
//  BOPrivacyStatementViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOPrivacyStatementViewController.h"

@interface BOPrivacyStatementViewController () <UIWebViewDelegate>

@end

@implementation BOPrivacyStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"https://lunagao.github.io/PrivacyStatementHtml/bamboo.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView setHidden:NO];
    [self.loading stopAnimating];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSURL *url = [NSURL URLWithString:@"https://lunagao.github.io/PrivacyStatementHtml/bamboo.html"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2)) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [self.webView loadRequest:[ NSURLRequest requestWithURL: url]];
        self.webView.delegate = self;
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        
        if ([error code] == 404) {
            self.webView.hidden = YES;
            //TODO: i18n
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网络访问失败" message:@"请检查网络" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
}

@end
