//
//  ViewController.m
//  SYBigImageView
//
//  Created by 666gps on 2017/7/28.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import "ViewController.h"
#import "SYBigImage.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    SYBigImage * bigI = [[SYBigImage alloc]init];
    [self.imageView addGestureRecognizer:bigI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
