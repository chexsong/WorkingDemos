//
//  RootVC.m
//  SaveWebImage
//
//  Created by 车小松 on 14-8-11.
//  Copyright (c) 2014年 车小松. All rights reserved.
//

#import "RootVC.h"

@interface RootVC ()<UIWebViewDelegate,UIActionSheetDelegate>
{
    CGPoint    tapLocation;
    NSTimer    *contextualMenuTimer;
}

@end

@implementation RootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    aWebView.delegate = self;
    aWebView.scalesPageToFit = YES;
    
    self.mainWebView = aWebView;
    [self.view addSubview:aWebView];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://image.baidu.com/"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    [self.mainWebView loadRequest:request];

    

    
    UILongPressGestureRecognizer *longtapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longtap:)];
    [self.view addGestureRecognizer:longtapGesture];
    
    
    // Do any additional setup after loading the view.
}

-(void)longtap:(UILongPressGestureRecognizer * )longtapGes{
    
    if (longtapGes.state == UIGestureRecognizerStateBegan) {
        CGPoint pt = [longtapGes locationInView:self.view];
        pt= [self.mainWebView convertPoint:pt fromView:nil];
        
        CGPoint offset  = [self.mainWebView.scrollView contentOffset];
        CGSize viewSize = [self.view frame].size;
        CGSize windowSize = [self.view frame].size;
        
        CGFloat f = windowSize.width / viewSize.width;
        pt.x = pt.x * f + offset.x;
        pt.y = pt.y * f + offset.y;
        
        [self openContextualMenuAt:pt];
    }
}


- (void)openContextualMenuAt:(CGPoint)pt
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"txt"];
    
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.mainWebView stringByEvaluatingJavaScriptFromString: jsCode];
    
    NSString *tags = [self.mainWebView stringByEvaluatingJavaScriptFromString:
                      [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Contextual Menu"
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if ([tags rangeOfString:@",A,"].location != NSNotFound) {
        [sheet addButtonWithTitle:@"打开链接"];
    }
    
    if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
        NSString *str = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString *imgStr= [self.mainWebView stringByEvaluatingJavaScriptFromString: str];
        NSLog(@"启动一个request下载图片:%@",imgStr);
        [sheet addButtonWithTitle:@"保存图片"];
    }
    
    
    [sheet addButtonWithTitle:@"在Safari中打开"];
    
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 这里实际启动request，下载图片
    // 我看见UC 浏览器断网也是可以下载图片的，我大概知道是通过JS，但具体操作就不知道了，有没有人知道是怎么实现的，分享下
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
