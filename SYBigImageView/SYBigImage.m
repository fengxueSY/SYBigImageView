//
//  SYBigImage.m
//  SYBigImageView
//
//  Created by 666gps on 2017/7/28.
//  Copyright © 2017年 666gps. All rights reserved.
//

#import "SYBigImage.h"

@implementation SYBigImage{
    
    float windowWidth;
    float windowHeight;
    
    CGRect oldRect;
    UIView * backView;
    CGFloat pinchChangeValue;
    CGPoint panChangeValueOld;
}
-(instancetype)init{
    if (self = [super init]) {
        windowWidth = [UIScreen mainScreen].bounds.size.width;
        windowHeight = [UIScreen mainScreen].bounds.size.height;
        [self addTarget:self action:@selector(bigImageAction)];
    }
    return self;
}
-(void)bigImageAction{
   
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0;
    [window addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBackView)];
    [backView addGestureRecognizer:tap];
    
    UIImageView * backImageView = (UIImageView *)self.view;
    oldRect = backImageView.frame;
    
    UIImageView * showImageView = [[UIImageView alloc]initWithFrame:[self.view convertRect:self.view.bounds toView:window]];
    showImageView.image = backImageView.image;
    showImageView.tag = 190231;
    showImageView.userInteractionEnabled = YES;
    [backView addSubview:showImageView];
    
    //缩放手势
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [showImageView addGestureRecognizer:pinch];
    
    //移动手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [showImageView addGestureRecognizer:pan];
    
    //放大图片的主要代码
    [UIView animateWithDuration:0.3 animations:^{
      showImageView.frame = CGRectMake(0,(windowHeight - backImageView.image.size.height * windowWidth / backImageView.image.size.width) / 2, windowWidth, backImageView.image.size.height * windowWidth / backImageView.image.size.width);
        backView.alpha = 1;
    }];
}
//缩放
-(void)pinchAction:(UIPinchGestureRecognizer *)sender{
    //这里关键是找到放大的比例,首先要理清楚要放大的倍数是多少，如果直接使用sender.scale 这样就是在前一次放大的基础上，再次放大那么多倍，而我们实际要的效果是在前一次放大的基础上，再放大移动的数值，所以每次手指移动放大的倍数应该是上次的sender.scale值减去当前的sender.scale
    
     UIImageView * showImageView = (UIImageView *)[backView viewWithTag:190231];
    if (sender.state == UIGestureRecognizerStateBegan) {
        pinchChangeValue = 1;
        return;
    }
    CGFloat change = 1 - (pinchChangeValue - sender.scale);
//    NSLog(@"每次放大的比例。-----  %f -- %f",change,sender.scale);
    showImageView.transform = CGAffineTransformScale(showImageView.transform, change, change);
    pinchChangeValue = sender.scale;
}
//移动
-(void)panAction:(UIPanGestureRecognizer *)sender{
   //这里和缩放差不多相同的原理
    if (sender.state == UIGestureRecognizerStateBegan) {
        panChangeValueOld = sender.view.center;
        return;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        float newY = panChangeValueOld.y + translation.y;
        float newX = panChangeValueOld.x + translation.x;
        sender.view.center = CGPointMake(newX, newY);
    }
    
}
//隐藏
-(void)hideBackView{
    UIImageView * showImageView = (UIImageView *)[backView viewWithTag:190231];
    //放大图片的主要代码
    [UIView animateWithDuration:0.3 animations:^{
        showImageView.frame = oldRect;
        backView.alpha = 0;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];

}
@end
