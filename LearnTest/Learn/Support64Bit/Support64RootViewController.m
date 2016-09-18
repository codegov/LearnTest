//
//  Support64RootViewController.m
//  LearnTest
//
//  Created by syq on 15/4/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "Support64RootViewController.h"

@interface Support64RootViewController ()

@end

@implementation Support64RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"===%ld %@",sizeof(CFIndex), (sizeof(CFIndex) == 8 ? @"64位" : @"非63位"));
    
    /// =======================================
    long l1 = 100000000001;
    int lc = l1; // 错误 64-bit上数据将被截取
    long ly = l1; // 正确
    
    NSLog(@"long==%d %ld", lc, ly);
    
    /// =======================================
    CGFloat value = 200.0;
    CFNumberRef num1 = CFNumberCreate(kCFAllocatorDefault, kCFNumberFloatType, &value); //64-bit下出现错误
    
    CFNumberRef num2 = CFNumberCreate(kCFAllocatorDefault, kCFNumberCGFloatType, &value); //正确
    
    NSLog(@"num == %@ %@ %f", num1, num2, value);
    
    ///=========================================
    //结果是，for循环一次都没有进。-1与NSUInteger比较时隐式转换成NSUInteger，变成了一个很大的数字：
    NSUInteger ui = 10;
    for (int i = -1; i < ui; i ++) {
        NSLog(@"==========%d", i);
    }
    
    /// =========================================
    //原因：一个有符号的值和一个同样精度的无符号的值相加结果是无符号的。这个无符号的结果被转换到更高精度的数值上时采用零扩展。
    int a = -2;
    
    unsigned int b = 1;
    
    NSInteger c = a + b;
    
    int ua = a + b;
    
    printf("%ld %d\n", c, ua);
    
    /// =========================================
    //不要将指针类型pointer赋值给整型int
    
    int pa = 5;
    int *pc = &pa;
    
    /* 32-bit下正常，64-bit下错误。最新的Xcode6.0编译提示警告:'Cast to int* for smaller integer type int'*/
    int *pd1 = (int *)((int)pc + 4);
    
    /* 正确, 指针可以直接增加*/
    int *pd2 = pc + 1;
    
    //如果我们一定要把指针转化为整型，可以把上述代码改为:
    /* 32-bit和64-bit都正常。*/
    int *pd3 = (int *)((uintptr_t)c + 4);
    
    ///============================================
    //永远不要使用malloc去为变量申请特定内存的大小，改为使用sizeof来获取变量或者结构体的大小。
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
