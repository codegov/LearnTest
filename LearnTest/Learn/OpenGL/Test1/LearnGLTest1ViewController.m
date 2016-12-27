//
//  LearnGLTest1ViewController.m
//  LearnTest
//
//  Created by javalong on 2016/12/6.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "LearnGLTest1ViewController.h"
@import OpenGLES;

@interface LearnGLTest1ViewController ()
{
    EAGLContext *_glContext;
    CAEAGLLayer *_glLayer;
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer;       // 帧缓存区
}
@end

@implementation LearnGLTest1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupGLContext];
    [self setupGLLayer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    
    // 设置清屏颜色
    glClearColor(0.0, 0.0, 1.0, 1.0);
    // 用来指定要用清屏颜色来清除由mask指定的buffer，此处是color buffer
    glClear(GL_COLOR_BUFFER_BIT);
    //glClear的填色动作类似photoshop中的油桶，用GL_COLOR_BUFFER_BIT声明要清理哪一个缓冲区。
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    // 将指定renderBuffer渲染在屏幕上
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupGLContext
{
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
}

- (void)setupGLLayer
{
    _glLayer = [CAEAGLLayer layer];
    _glLayer.frame = self.view.frame;
    _glLayer.opaque = YES;
    // 描绘属性：这里不维持渲染内容
    // kEAGLDrawablePropertyRetainedBacking:若为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)计算得到的最终结果颜色的透明度会考虑目标颜色的透明度值。
    // 若为NO，则不考虑目标颜色的透明度值，将其当做1来处理。
    // 使用场景：目标颜色为非透明，源颜色有透明度，若设为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)得到的结果颜色会有一定的透明度（与实际不符）。若未NO则不会（符合实际）。
    _glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @(NO),
                                    kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    [self.view.layer addSublayer:_glLayer];
}

- (void)setupRenderBuffer
{
    if (_colorRenderBuffer)
    {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    // 生成一个renderBuffer，id是_colorRenderBuffer
    glGenRenderbuffers(1, &_colorRenderBuffer);
    // 设置为当前renderBuffer，则后面引用GL_RENDERBUFFER，即指的是_colorRenderBuffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    // 为color renderbuffer 分配存储空间
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    //renderBuffer对象本身不能直接使用，不能挂载到GPU上而直接输出内容的，要使用frameBuffer。
}

- (void)setupFrameBuffer
{
    //OpenGlES的FrameBuffer包含：renderBuffer，depthBuffer，stencilBuffer和accumulationBuffer。
    if (_frameBuffer)
    {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    // FBO用于管理colorRenderBuffer，离屏渲染
    glGenFramebuffers(1, &_frameBuffer);
    // 设置为当前framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    //先设置renderbuffer，然后设置framebuffer，顺序不能互换。
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
