//
//  LearnGLTest2ViewController.m
//  LearnTest
//
//  Created by javalong on 2016/12/6.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "LearnGLTest2ViewController.h"
@import OpenGLES;
#import "ShaderOperations.h"

@interface LearnGLTest2ViewController ()
{
    EAGLContext *_glContext;   // 上下文
    CAEAGLLayer *_glLayer;     // 显示图层
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer;       // 帧缓存区
    
    GLuint _glProgram;    // shader程序
    GLuint _positionSlot; // 用于绑定shader中的Position参数
    GLuint _colorSlot;    // 用于绑定shader中的SourceColor参数
}
@end

@implementation LearnGLTest2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupGLContext];   // 上下文
    [self setupGLLayer];     // 显示图层
    [self setupRenderBuffer];// 渲染缓存
    [self setupFrameBuffer]; // 帧缓存
    
    // 设置清屏颜色
    glClearColor(1.0, 1.0, 1.0, 1.0);
    // 用来指定要用清屏颜色来清除由mask指定的buffer，此处是color buffer
    glClear(GL_COLOR_BUFFER_BIT);
    //glClear的填色动作类似photoshop中的油桶，用GL_COLOR_BUFFER_BIT声明要清理哪一个缓冲区。
    glViewport(0, 0, _glLayer.frame.size.width, _glLayer.frame.size.height);
    
    [self setupShaders];  // Shader脚本执行
    [self setupRender];   // 添加渲染像素
    
    // 将指定renderBuffer渲染在屏幕上
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
    
    // 将FBO转换为图片
    [self setupTransform];
}

- (void)setupGLContext
{
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
}

- (void)setupGLLayer
{
    _glLayer = [CAEAGLLayer layer];
    _glLayer.frame = CGRectMake(10, 74, self.view.frame.size.width - 20, 200);// self.view.frame;
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

- (void)setupShaders
{
    _glProgram = [ShaderOperations compileShaderVertexName:@"Test2ShaderVertex" fragmentName:@"Test2ShaderFragment"];
    glUseProgram(_glProgram);
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    _colorSlot    = glGetAttribLocation(_glProgram, "SourceColor");
}

- (void)setupRender
{
//    [self setupRenderUsingVertices];// 直接使用顶点数组
//    [self setupRenderUsingIndex];   // 使用顶点索引数组
//    [self setupRenderUsingVBO];     // 使用VBO 顶点缓存对象
    [self setupRenderUsingIndexVBO];  // 使用索引数组+VBO
}

#pragma mark 直接使用顶点数组，即单纯使用glDrawArrays

- (void)setupRenderUsingVertices
{
//    [self setupRenderVertices_triangles];
//    [self setupRenderVertices_triangle_strip];
    [self setupRenderVertices_triangle_fan];
}

- (void)setupRenderVertices_triangles
{
    // 顶点数组
    const GLfloat Vertices[] = { // 两个三角形顶点
        -1,-1,0,// 左下，黑色
        1,-1,0, // 右下，红色
        -1,1,0, // 左上，蓝色
        
        1,-1,0, // 右下，红色
        -1,1,0, // 左上，蓝色
        1,1,0,  // 右上，绿色
    };
    
    // 颜色数组
    const GLfloat Colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    // 纯粹使用顶点的方式，颜色与顶点要一一对应。
    // 在shader中DestinationColor为最终要传递给OpenGLES的颜色，要使用varying，即两个顶点之间颜色平滑渐变
    // 若不使用varying，则完全花掉。
    
    // 取出Vertices数组中的坐标点值，赋给_positionSlot
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, Vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // 取出Colors数组中的每个坐标点的颜色值，赋给_colorSlot
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    
    // 以上两个slot分别于着色器脚本中的Positon，SourceColor两个参数
    
    // 绘制两个三角形，不复用顶点，因此需要6个顶点坐标。
    // V0-V1-V2, V3-V4-V5
    
    /**
     *  参数1：三角形组合方式
     *  参数2：从顶点数组的哪个offset开始
     *  参数3：顶点个数6个
     */
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)setupRenderVertices_triangle_strip
{
    // 顶点数组
    const GLfloat Vertices[] = {
        -1,-1,0,// 左下，黑色
        1,-1,0, // 右下，红色
        -1,1,0, // 左上，蓝色
        1,1,0,  // 右上，绿色
    };
    
    // 颜色数组
    const GLfloat Colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    // 取出Vertices数组中的坐标点值，赋给_positionSlot
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, Vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // 取出Colors数组中的每个坐标点的颜色值，赋给_colorSlot
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    
    // 绘制两个三角形，复用两个顶点，因此只需要四个顶点坐标
    // V0-V1-V2, V1-V2-V3
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)setupRenderVertices_triangle_fan
{
    // 顶点数组
    const GLfloat Vertices[] = {
        -1,1,0, // 左上，蓝色
        -1,-1,0,// 左下，黑色
        1,-1,0, // 右下，红色
        1,1,0,  // 右上，绿色
    };
    
    // 颜色数组
    const GLfloat Colors[] = {
        0,0,1,1, // 左上，蓝色
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,1,0,1, // 右上，绿色
    };
    
    // 取出Vertices数组中的坐标点值，赋给_positionSlot
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, Vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // 取出Colors数组中的每个坐标点的颜色值，赋给_colorSlot
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    
    // 绘制两个三角形，复用两个顶点，因此只需要四个顶点坐标
    // V0-V1-V2, V0-V2-V3
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}



#pragma mark 使用顶点索引数组，使用glDrawElements

- (void)setupRenderUsingIndex
{
    // 顶点数组
    const GLfloat Vertices[] = {
        -1,-1,0,// 左下，黑色
        1,-1,0, // 右下，红色
        -1,1,0, // 左上，蓝色
        1,1,0,  // 右上，绿色
    };
    
    // 颜色数组
    const GLfloat Colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    // 索引数组，指定好了绘制三角形的方式
    // 与glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);一样。
    const GLubyte Indices[] = {
        0,1,2, // 三角形0
        1,2,3  // 三角形1
    };
    
    // 取出Vertices数组中的坐标点值，赋给_positionSlot
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, Vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // 注意，未使用VBO时，glVertexAttribPointer的最后一个参数是指向对应数组的指针。
    // 取出Colors数组中的每个坐标点的颜色值，赋给_colorSlot
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    
    /**
     *  参数1：三角形组合方式
     *  参数2：索引数组中的元素个数，即6个元素，才能绘制矩形
     *  参数3：索引数组中的元素类型
     *  参数4：索引数组
     */
    // 注意，未使用VBO时，glDrawElements的最后一个参数是指向对应索引数组的指针。
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, Indices);
    
    /**
     *  结论：
     *  不管使用哪种方式，顶点和颜色两个数组一定要一一对应。
     *  glDrawArrays:
     *  glDrawElements: 引入了索引，则很方便地实现顶点的复用。
     *
     *  在每个vertex上调用我们的vertex shader，以及每个像素调用fragment shader
     *  相比glDrawArray, 使用顶点索引数组可减少存储和绘制重复顶点的资源消耗
     */
}

#pragma mark 使用VBO，Vertex Buffer Object

- (void)setupRenderUsingVBO
{
    // 定义一个Vertex结构, 其中包含了坐标和颜色
    typedef struct {
        float Position[3];
        float Color[4];
    } Vertex;
    
    // 顶点数组
    const Vertex Vertices[] = {
        {{-1,-1,0}, {0,0,0,1}},// 左下，黑色
        {{1,-1,0}, {1,0,0,1}}, // 右下，红色
        {{-1,1,0}, {0,0,1,1}}, // 左上，蓝色
        {{1,1,0}, {0,1,0,1}},  // 右上，绿色
    };
    
    // GL_ARRAY_BUFFER用于顶点数组
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    // 绑定vertexBuffer到GL_ARRAY_BUFFER，
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    // 给VBO传递数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    // 注意，未使用VBO时，glVertexAttribPointer的最后一个参数是指向对应数组的指针。
    // 但是，当使用VBO时，glVertexAttribPointer的最后一个参数是要获取的参数在GL_ARRAY_BUFFER（每一个Vertex）的偏移量
    // 取出Vertex结构体的Position，赋给_positionSlot
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glEnableVertexAttribArray(_positionSlot);
    
    // 注意，未使用VBO时，glVertexAttribPointer的最后一个参数是指向对应数组的指针。
    // 但是，当使用VBO时，glVertexAttribPointer的最后一个参数是要获取的参数在GL_ARRAY_BUFFER（每一个Vertex）的偏移量
    // Vertex结构体，偏移3个float的位置，即是Color值
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 3));
    glEnableVertexAttribArray(_colorSlot);
    
    // 使用glDrawArrays也可绘制，此时仅从GL_ARRAY_BUFFER中取出顶点数据，
    // 而索引数组就可以不要了，即GL_ELEMENT_ARRAY_BUFFER实际上没有用到。
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)setupRenderUsingIndexVBO
{
    // 定义一个Vertex结构, 其中包含了坐标和颜色
    typedef struct {
        float Position[3];
        float Color[4];
    } Vertex;
    
    // 顶点数组
    const Vertex Vertices[] = {
        {{-1,-1,0}, {0,0,0,1}},// 左下，黑色
        {{1,-1,0}, {1,0,0,1}}, // 右下，红色
        {{-1,1,0}, {0,0,1,1}}, // 左上，蓝色
        {{1,1,0}, {0,1,0,1}},  // 右上，绿色
    };
    
    // 索引数组
    const GLubyte Indices[] = {
        0,1,2, // 三角形0
        1,2,3  // 三角形1
    };
    
    // setup VBOs
    
    // GL_ARRAY_BUFFER用于顶点数组
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    // 绑定vertexBuffer到GL_ARRAY_BUFFER，
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    // 给VBO传递数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    // GL_ELEMENT_ARRAY_BUFFER用于顶点数组对应的Indices，即索引数组
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    // 注意，未使用VBO时，glVertexAttribPointer的最后一个参数是指向对应数组的指针。
    // 但是，当使用VBO时，glVertexAttribPointer的最后一个参数是要获取的参数在GL_ARRAY_BUFFER（每一个Vertex）的偏移量
    // 取出Vertex结构体的Position，赋给_positionSlot
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glEnableVertexAttribArray(_positionSlot);
    
    // 注意，未使用VBO时，glVertexAttribPointer的最后一个参数是指向对应数组的指针。
    // 但是，当使用VBO时，glVertexAttribPointer的最后一个参数是要获取的参数在GL_ARRAY_BUFFER（每一个Vertex）的偏移量
    // Vertex结构体，偏移3个float的位置，即是Color值
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 3));
    glEnableVertexAttribArray(_colorSlot);
    
    // 使用glDrawArrays也可绘制，此时仅从GL_ARRAY_BUFFER中取出顶点数据，
    // 而索引数组就可以不要了，即GL_ELEMENT_ARRAY_BUFFER实际上没有用到。
    // glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    
    // 而使用glDrawElements的方式：本身就用到了索引，即GL_ELEMENT_ARRAY_BUFFER。
    // 所以，GL_ARRAY_BUFFER和GL_ELEMENT_ARRAY_BUFFER两个都需要。
    
    /**
     *  参数1：三角形组合方式
     *  参数2：索引数组中的元素个数，即6个元素，才能绘制矩形
     *  参数3：索引数组中的元素类型
     *  参数4：索引数组在GL_ELEMENT_ARRAY_BUFFER（索引数组）中的偏移量
     */
    // 注意，未使用VBO时，glDrawElements的最后一个参数是指向对应索引数组的指针。
    // 但是，当使用VBO时，参数4表示索引数据在VBO（GL_ELEMENT_ARRAY_BUFFER）中的偏移量
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

#pragma mark 将FBO转换为图片

- (void)setupTransform
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_glLayer.frame) + 10, CGRectGetWidth(self.view.frame) - 20, 200)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [self transformFBOToImage];
    [self.view addSubview:imageView];
}

- (UIImage *)transformFBOToImage
{
    CGSize currentFBOSize = _glLayer.frame.size;
    NSUInteger totalBytesForImage = (int)currentFBOSize.width * (int)currentFBOSize.height * 4;
    
    GLubyte *_rawImagePixelsTemp = (GLubyte *)malloc(totalBytesForImage);
    
    glReadPixels(0, 0, (int)currentFBOSize.width, (int)currentFBOSize.height, GL_RGBA, GL_UNSIGNED_BYTE, _rawImagePixelsTemp);
    glUseProgram(0); //unbind the shader
    // 从FBO中读取图像数据，离屏渲染。
    // 图像经过render之后，已经在FBO中了，即使不将其拿到RenderBuffer中，依然可以使用getResultImage取到图像数据。
    // 用[_eaglContext presentRenderbuffer:GL_RENDERBUFFER];，实际上就是将FBO中的图像拿到RenderBuffer中（即屏幕上）
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, _rawImagePixelsTemp, totalBytesForImage, (CGDataProviderReleaseDataCallback)&freeData);
    CGColorSpaceRef defaultRGBColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef cgImageFromBytes = CGImageCreate((int)currentFBOSize.width, (int)currentFBOSize.height, 8, 32, 4 * (int)currentFBOSize.width, defaultRGBColorSpace, kCGBitmapByteOrderDefault, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    UIImage *finalImage = [UIImage imageWithCGImage:cgImageFromBytes scale:1.0 orientation:UIImageOrientationDownMirrored];
    
    CGImageRelease(cgImageFromBytes);
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(defaultRGBColorSpace);
    
    return finalImage;
}

static void freeData(void *info, const void *data, size_t size)
{
    free((unsigned char *)data);
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
