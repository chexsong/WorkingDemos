//
//  ViewController.m
//  ButtonLongPress
//
//  Created by chexsong on 14-8-30.
//  Copyright (c) 2014年 xiaosong. All rights reserved.
//

#import "ViewController.h"
#import "OBShapedButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 1; //定义按的时间
    
    OBShapedButton *newButton = [[OBShapedButton alloc]initWithFrame:CGRectMake(200, 200.0, 100, 100)];
    newButton.tag = 200;
    
    [newButton setBackgroundImage:[UIImage imageNamed:@"button-normal"] forState:UIControlStateNormal];
    [newButton setBackgroundImage:[UIImage imageNamed:@"button-highlighted"] forState:UIControlStateHighlighted];
    
    [newButton addGestureRecognizer:longPress];
    [newButton addTarget:self action:@selector(btnShort:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:newButton];
    
}

-(void)btnLong:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIButton *newBTN =(UIButton *) longPress.view;
        NSLog(@"长按按钮的tag值:%d",newBTN.tag);
    }
    
}

-(void)btnShort:(UIButton *)newBtn
{
    NSLog(@"短按按钮的tag值%d",newBtn.tag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
