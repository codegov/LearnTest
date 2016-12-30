//
//  LearnGLTest31ViewController.m
//  LearnTest
//
//  Created by javalong on 2016/12/6.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "LearnGLTest31ViewController.h"
@import OpenGLES;
#import "ShaderOperations.h"
#import "Test3TouchView.h"

typedef NS_ENUM(NSUInteger, GPUImageRotationMode) {
    LGPUImageNoRotation,
    LGPUImageRotateLeft,
    LGPUImageRotateRight,
    LGPUImageFlipVertical,
    LGPUImageFlipHorizonal,
    LGPUImageRotateRightFlipVertical,
    LGPUImageRotateRightFlipHorizontal,
    LGPUImageRotate180
};

@interface LearnGLTest31ViewController ()<Test3TouchViewDelegate>
{
    EAGLContext *_glContext;   // 上下文
    CAEAGLLayer *_glLayer;     // 显示图层
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer;       // 帧缓存区
    GLuint _pixelBuffer;       // 像素缓存区
    
    GLuint _glProgram;         // shader程序
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _textureSlot;       // 纹理
    GLuint _textureCoordsSlot; // 纹理坐标
    GLuint _textureID;         // 纹理ID
    
    NSMutableArray *_touchPoints;
}
@end

@implementation LearnGLTest31ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearContext)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIImage *image = [UIImage imageNamed:@"image"];
    float x = (self.view.frame.size.width - image.size.width)/2.0;
    Test3TouchView *view = [[Test3TouchView alloc] initWithFrame:CGRectMake(x, 74, image.size.width, image.size.height)];
    view.delegate = self;
    [self.view addSubview:view];
    
    CFAbsoluteTime timeBefore = CFAbsoluteTimeGetCurrent();
    [self setup];
    CFAbsoluteTime timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("Time used : %f\n", timeCurrent - timeBefore);
}

- (void)clearContext
{
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setup
{
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
    
    [self setupGLTouch];
}

- (void)setupGLTouch
{
    [self setupShaders];   // Shader脚本执行
    [self setupBlendMode];
    [self setupTexture];   // 纹理
    
    UIImage *image = [UIImage imageNamed:@"image"];//[UIImage imageNamed:@"Radial"];
    [self setupImageToTexture:image];    // 图片转纹理
//    [self setupImageToTexture_pbo:image];
    [self setupRenderTexture];// 渲染纹理像素
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
//    _glLayer.frame = CGRectMake(10, 74, self.view.frame.size.width - 20, 200);
//    _glLayer.frame = self.view.frame;
    UIImage *image = [UIImage imageNamed:@"image"];
    float x = (self.view.frame.size.width - image.size.width)/2.0;
    _glLayer.frame = CGRectMake(x, 74, image.size.width, image.size.height);
    _glLayer.opaque = YES;
    // 描绘属性：这里不维持渲染内容
    // kEAGLDrawablePropertyRetainedBacking:若为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)计算得到的最终结果颜色的透明度会考虑目标颜色的透明度值。
    // 若为NO，则不考虑目标颜色的透明度值，将其当做1来处理。
    // 使用场景：目标颜色为非透明，源颜色有透明度，若设为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)得到的结果颜色会有一定的透明度（与实际不符）。若未NO则不会（符合实际）。
    _glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @(YES),
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

- (void)setupBlendModeForImage
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ZERO);
}

- (void)setupBlendMode
{
    /**
     关于混合模式, 是一个非常大的话题. 这里只介绍glBlendFunc的使用.
     glBlendFunc的参数1作用于源数据, 参数2作用于目标数据. 混合作用的结果颜色是 源颜色源因子 + 目标颜色目标因子.
     例如, 我们这里的demo是直接将一张图片贴在OpenGL画布上, 因此图片取GL_ONE, 而目标数据即OpenGL画布取GL_ZERO.
     
     glEnable(GL_BLEND);
     glBlendFunc(GL_ONE, GL_ZERO);

     而另外一种非常常见的混合模式是:
     
     glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

     混合后的结果颜色是 source * source_alpha + destination * (1 - source_alpha).
     这种混合模式就是将两种颜色混合叠加的效果.
     只有RGBA模式下才使用blend模式.
     其他常见的混合模式有:
     
     glBlendFunc(GL_ONE, GL_ZERO) 完全使用源颜色, 完全不使用目标颜色. 和不使用blend的时候一致.
     glBlendFunc(GL_ZERO, GL_ONE) 完全不使用源颜色, 完全使用目标颜色. 即原图没有变化.
     glBlendFunc(GL_ONE, GL_ONE) 两种颜色的直接相加.
     */
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_ONE, GL_ZERO);
    
    glEnable(GL_BLEND);
    
    // 参数1: 源颜色, 即将要拿去加入混合的颜色. 纹理原图.
    // 参数2: 目标颜色, 即做处理之前的原来颜色. 原来颜色.
    //    glBlendFunc(GL_ZERO, GL_ZERO);                        // 黑色矩形. SRC为0, DST为0
    //    glBlendFunc(GL_ZERO, GL_ONE);                         // 目标颜色不受texture影响
    
    //    glBlendFunc(GL_ONE, GL_ZERO);                         // 纹理原图
    //    glBlendFunc(GL_ONE, GL_ONE);                          // 白色圆(不带黑色部分). 直接相加.
    //    glBlendFunc(GL_ONE, GL_ONE_MINUS_DST_ALPHA);          // 纹理原图
    
    //    glBlendFunc(GL_SRC_COLOR, GL_ZERO);                   // 纹理原图
    //    glBlendFunc(GL_SRC_COLOR, GL_ONE);                    // 白色圆(不带黑色部分).
    
    //    glBlendFunc(GL_DST_COLOR, GL_ZERO);                   // 黑框矩形, 中间白色圆变为透明.源颜色
    //    glBlendFunc(GL_DST_COLOR, GL_ONE);                    // 部分透明的白色圆, 目标白色则纯白圆, 目标深色则透明圆.
    
    //    glBlendFunc(GL_SRC_ALPHA, GL_ZERO);                   // 纹理原图, 渐变部分消失, 白色圆偏小
    //    glBlendFunc(GL_SRC_ALPHA, GL_ONE);                    // 白色圆(不带黑色部分). 常用于表达光亮效果.
    
    //    glBlendFunc(GL_DST_ALPHA, GL_ZERO);                   // 纹理原图, 渐变部分消失, 白色圆偏小
    //    glBlendFunc(GL_DST_ALPHA, GL_ONE);                    // 白色圆
    //    glBlendFunc(GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);    // 纹理原图
    
    //    glBlendFunc(GL_ONE_MINUS_SRC_COLOR, GL_ZERO);         // 黑色矩形, 圆周边缘类似半透明灰白
    //    glBlendFunc(GL_ONE_MINUS_SRC_COLOR, GL_ONE);          // 白色圆圈, 中间透明
    
    //    glBlendFunc(GL_ONE_MINUS_SRC_ALPHA, GL_ZERO);         // 黑色矩形, 圆周边缘类似半透明灰白
    //    glBlendFunc(GL_ONE_MINUS_SRC_ALPHA, GL_ONE);          // 白色圆圈, 中间透明
    
    //    glBlendFunc(GL_ONE_MINUS_DST_ALPHA, GL_ZERO);         // 纹理原图
    //    glBlendFunc(GL_ONE_MINUS_DST_ALPHA, GL_ONE);          // 目标颜色不受texture影响
    
    //    glBlendFunc(GL_SRC_ALPHA_SATURATE, GL_ZERO);          // 黑色矩形, 圆周边缘类似半透明灰白
    
    // 源颜色全取,目标颜色:若该像素的源颜色透明度为1(白色),则不取该目标颜色;若源颜色透明度为0(黑色),则全取目标颜色;若介于之间,则根据透明度来取目标颜色值. 所以黑色的圆周边缘也不存在了. 类似锐化?
    //    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    // 白色圆(圆周边缘还有点黑色部分). 通过透明度来混合. 源颜色*自身的alpha值, 目标颜色*(1-源颜色的alpha值). 常用于在物体前面绘制物体.
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)setupShaders
{
    _glProgram = [ShaderOperations compileShaderVertexName:@"Test31ShaderVertex" fragmentName:@"Test31ShaderFragment"];
    glUseProgram(_glProgram);
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    _colorSlot    = glGetUniformLocation(_glProgram, "SourceColor");
    _textureSlot  = glGetUniformLocation(_glProgram, "Texture");
    _textureCoordsSlot = glGetAttribLocation(_glProgram, "TextureCoords");
}

- (void)setupTexture
{
    glEnable(GL_TEXTURE_2D);
    glGenTextures(1, &_textureID);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    /**
     *  纹理过滤函数
     *  图象从纹理图象空间映射到帧缓冲图象空间(映射需要重新构造纹理图像,这样就会造成应用到多边形上的图像失真),
     *  这时就可用glTexParmeteri()函数来确定如何把纹理象素映射成像素.
     *  如何把图像从纹理图像空间映射到帧缓冲图像空间（即如何把纹理像素映射成像素）
     */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);// S方向上的贴图模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);// T方向上的贴图模式
    // 线性过滤：使用距离当前渲染像素中心最近的4个纹理像素加权平均值
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
}

- (void)setupImageToTexture:(UIImage *)image
{
    /**
     *  加载image, 使用CoreGraphics将位图以RGBA格式存放. 将UIImage图像数据转化成OpenGL ES接受的数据.
     *  然后在GPU中将图像纹理传递给GL_TEXTURE_2D。
     *  @return 返回的是纹理对象，该纹理对象暂时未跟GL_TEXTURE_2D绑定（要调用bind）。
     *  即GL_TEXTURE_2D中的图像数据都可从纹理对象中取出。
     */
    // 将image绑定到GL_TEXTURE_2D上，即传递到GPU中
//    UIImage *image = [UIImage imageNamed:@"maitian_jingse.jpg"];
//    UIImage *image = [UIImage imageNamed:@"image"];
//    UIImage *image = [UIImage imageNamed:@"Radial"];
    GLuint width   = (GLuint)image.size.width;
    GLuint height  = (GLuint)image.size.height;
    CGRect rect    = CGRectMake(0, 0, width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imgData  = malloc(width * height * 4);
    CGContextRef context = CGBitmapContextCreate(imgData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, image.CGImage);
    
    /**
     *  将图像数据传递给到GL_TEXTURE_2D中, 因其于textureID纹理对象已经绑定，所以即传递给了textureID纹理对象中。
     *  glTexImage2d会将图像数据从CPU内存通过PCIE上传到GPU内存。
     *  不使用PBO时它是一个阻塞CPU的函数，数据量大会卡。
     */
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData);
    
    // 结束后要做清理
    glBindTexture(GL_TEXTURE_2D, 0); //解绑
    CGContextRelease(context);
    free(imgData);
}

- (void)setupImageToTexture_pbo:(UIImage *)image  // openGLES3 支持  测试性能不佳  待查原因
{
//    UIImage *image    = [UIImage imageNamed:@"maitian_jingse_9.jpg"];
//    UIImage *image    = [UIImage imageNamed:@"image"];
    CGDataProviderRef providerRef = CGImageGetDataProvider(image.CGImage);
    CFDataRef dataRef = CGDataProviderCopyData(providerRef);
    const UInt8 *dataPtr = CFDataGetBytePtr(dataRef);
    CGFloat imgDataSize  = image.size.width * image.size.height * 4;
    
//    glEnable(GL_TEXTURE_2D);
//    glGenTextures(1, &_textureID);
//    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    /**
     从本地内存向GPU的传输（UNPACK），包括各种glTexImage、glDrawPixel；
     从GPU到本地内存的传输（PACK），包括glGetTexImage、glReadPixel等。也正因如此，PBO也有PACK和UNPACK模式的区别。
     */
    glGenBuffers(1, &_pixelBuffer);
    glBindBuffer(GL_PIXEL_UNPACK_BUFFER, _pixelBuffer);
    glBufferData(GL_PIXEL_UNPACK_BUFFER, imgDataSize, NULL, GL_STREAM_DRAW);
    
    GLvoid *pixelUnpackBuffer = glMapBufferRange(GL_PIXEL_UNPACK_BUFFER, 0, imgDataSize, GL_MAP_WRITE_BIT);
    if (!pixelUnpackBuffer)
    {
        NSLog(@"Error:Map Buffer Range Failed.");
        exit(1);
    }
    memcpy(pixelUnpackBuffer, dataPtr, imgDataSize);
    glUnmapBuffer(GL_PIXEL_UNPACK_BUFFER);
    
    /**
     glPixelStorei(GL_UNPACK_ALIGNMENT,1)控制的是所读取数据的对齐方式，默认4字节对齐，即一行的图像数据字节数必须是4的整数倍，即读取数据时，读取4个字节用来渲染一行，之后读取4字节数据用来渲染第二行。对RGB 3字节像素而言，若一行10个像素，即30个字节，在4字节对齐模式下，OpenGL会读取32个字节的数据，若不加注意，会导致glTextImage中致函数的读取越界，从而全面崩溃。
     */
    glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
    
    /**
     *  纹理过滤函数
     *  图象从纹理图象空间映射到帧缓冲图象空间(映射需要重新构造纹理图像,这样就会造成应用到多边形上的图像失真),
     *  这时就可用glTexParmeteri()函数来确定如何把纹理象素映射成像素.
     *  如何把图像从纹理图像空间映射到帧缓冲图像空间（即如何把纹理像素映射成像素）
     */
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);// S方向上的贴图模式
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);// T方向上的贴图模式
//    // 线性过滤：使用距离当前渲染像素中心最近的4个纹理像素加权平均值
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image.size.width, image.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    // 结束后要做清理
    glBindTexture(GL_TEXTURE_2D, 0); //解绑
    CFRelease(dataRef);
}

- (void)setupRenderTexture
{
    // 第一行和第三行不是严格必须的，默认使用GL_TEXTURE0作为当前激活的纹理单元
    glActiveTexture(GL_TEXTURE5); // 指定纹理单元GL_TEXTURE5
    glBindTexture(GL_TEXTURE_2D, _textureID); // 绑定，即可从_textureID中取出图像数据。
    glUniform1i(_textureSlot, 5); // 与纹理单元的序号对应
    
    // 渲染需要的数据要从GL_TEXTURE_2D中得到。
    // GL_TEXTURE_2D与_textureID已经绑定
    [self setupRender];
    
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void)setupRender
{
    [self setupRenderUsingIndexVBO];  // 使用索引数组+VBO
}

- (void)setupRenderUsingIndexVBO
{
//    const GLfloat texCoords[] = {
//        0, 0,//左下
//        1, 0,//右下
//        0, 1,//左上
//        1, 1,//右上
//    };
    
    const GLfloat *texCoords = [[self class] textureCoordinatesForRotation:LGPUImageRotateLeft] ;
    
    const GLfloat vertices[] = {
        -1, -1, 0,   //左下
        1,  -1, 0,   //右下
        -1, 1,  0,   //左上
        1,  1,  0    //右上
    };
    
    // 索引数组
    const GLubyte indices[] = {
        0,1,2, // 三角形0
        1,2,3  // 三角形1
    };
    
//    //====== setup VBO======//
//    // GL_ARRAY_BUFFER用于顶点数组
//    GLuint vertexBuffer;
//    glGenBuffers(1, &vertexBuffer);
//    // 绑定vertexBuffer到GL_ARRAY_BUFFER，
//    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
//    // 给VBO传递数据
//    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
//    
//    //====== setup VBO Index======//
//    // GL_ELEMENT_ARRAY_BUFFER用于顶点数组对应的Indices，即索引数组
//    GLuint indexBuffer;
//    glGenBuffers(1, &indexBuffer);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    
    // 注意，未使用VBO时，glVertexAttribPointer的最后一个参数是指向对应数组的指针。
    // 但是，当使用VBO时，glVertexAttribPointer的最后一个参数是要获取的参数在GL_ARRAY_BUFFER（每一个Vertex）的偏移量
    // 取出Vertex结构体的Position，赋给_positionSlot
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // _colorSlot对应SourceColor参数, uniform类型, 使用glUniform4f来传递参数至shader.
    glUniform4f(_colorSlot, 0.5f, 0.3f, 0.0f, 1.0f);
    
    // 纹理坐标
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
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
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, indices);
}

- (void)setupRenderWithTouchPoints:(NSArray *)touchPoints
{
    // 第一行和第三行不是严格必须的，默认使用GL_TEXTURE0作为当前激活的纹理单元
    glActiveTexture(GL_TEXTURE5); // 指定纹理单元GL_TEXTURE5
    glBindTexture(GL_TEXTURE_2D, _textureID); // 绑定，即可从_textureID中取出图像数据。
    glUniform1i(_textureSlot, 5); // 与纹理单元的序号对应
    
    // 渲染需要的数据要从GL_TEXTURE_2D中得到。
    // GL_TEXTURE_2D与_textureID已经绑定
    [self setupRenderUsingIndexVBOWithTouchPoints:touchPoints];
    
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void)setupRenderUsingIndexVBOWithTouchPoints:(NSArray *)touchPoints
{
    CGFloat lineWidth = 5.0;
    CGFloat width  = _glLayer.frame.size.width;
    CGFloat height = _glLayer.frame.size.height;
    for (id rawPoint in touchPoints)
    {
        CGPoint point = [rawPoint CGPointValue];
        GLfloat vertices[] = {
            -1 + 2 * (point.x - lineWidth) / width, 1 - 2 * (point.y + lineWidth) / height, 0.0f, // 左下
            -1 + 2 * (point.x + lineWidth) / width, 1 - 2 * (point.y + lineWidth) / height, 0.0f, // 右下
            -1 + 2 * (point.x - lineWidth) / width, 1 - 2 * (point.y - lineWidth) / height, 0.0f, // 左上
            -1 + 2 * (point.x + lineWidth) / width, 1 - 2 * (point.y - lineWidth) / height, 0.0f  // 右上
        };
        
        const GLubyte indices[] = {
            0, 1, 2, // 三角形0
            1, 2, 3  // 三角形1
        };
        
        const GLfloat texCoords[] = {
            0, 0,//左下
            1, 0,//右下
            0, 1,//左上
            1, 1,//右上
        };
        
//        //====== setup VBO======//
//        // GL_ARRAY_BUFFER用于顶点数组
//        GLuint vertexBuffer;
//        glGenBuffers(1, &vertexBuffer);
//        // 绑定vertexBuffer到GL_ARRAY_BUFFER，
//        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
//        // 给VBO传递数据
//        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
//        
//        //====== setup VBO Index======//
//        // GL_ELEMENT_ARRAY_BUFFER用于顶点数组对应的Indices，即索引数组
//        GLuint indexBuffer;
//        glGenBuffers(1, &indexBuffer);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
//        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
        
        
        // 注意，未使用VBO时，glVertexAttribPointer的最后一个参数是指向对应数组的指针。
        // 但是，当使用VBO时，glVertexAttribPointer的最后一个参数是要获取的参数在GL_ARRAY_BUFFER（每一个Vertex）的偏移量
        // 取出Vertex结构体的Position，赋给_positionSlot
        glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
        glEnableVertexAttribArray(_positionSlot);
        
        // _colorSlot对应SourceColor参数, uniform类型, 使用glUniform4f来传递参数至shader.
        glUniform4f(_colorSlot, 1.0f, 0.0f, 0.0f, 1.0f);
        
        // 纹理坐标
        glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
        glEnableVertexAttribArray(_textureCoordsSlot);
        
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, indices);
    }
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}


#pragma mark - Test3TouchView Delegate

- (void)test3TouchViewWithPoints:(NSArray *)points rect:(CGRect)rect
{
    [self setupRenderWithTouchPoints:points];
}

#pragma mark - touch events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _touchPoints = [NSMutableArray array];
    for (UITouch *t in touches)
    {
        CGPoint p = [t locationInView:self.view];
        [_touchPoints addObject:[NSValue valueWithCGPoint:p]];
    }
    [self setupRenderWithTouchPoints:_touchPoints];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        CGPoint p = [t locationInView:self.view];
        [_touchPoints addObject:[NSValue valueWithCGPoint:p]];
    }
    [self setupRenderWithTouchPoints:_touchPoints];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setupRenderWithTouchPoints:_touchPoints];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setupRenderWithTouchPoints:_touchPoints];
}

- (void)dealloc
{
    if (_textureID)
    {
        glDeleteTextures(1, &_textureID);
        _textureID = 0;
    }
    if (_frameBuffer)
    {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    if (_colorRenderBuffer)
    {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    if (_glProgram)
    {
        glDeleteProgram(_glProgram);
        _glProgram = 0;
    }
    if ([EAGLContext currentContext] == _glContext)
    {
        [EAGLContext setCurrentContext:nil];
    }
}

+ (const GLfloat *)textureCoordinatesForRotation:(GPUImageRotationMode)rotationMode;
{
    /**
     c  d
     a  b
     */
    static const GLfloat noRotationTextureCoordinates[] = {
        0.0f, 0.0f,//左下 a
        1.0f, 0.0f,//右下 b
        0.0f, 1.0f,//左上 c
        1.0f, 1.0f,//右上 d
    };
    
    // 从坐标原点比划旋转，即从屏幕底部比划旋转
    /**
     c  d       a  c
            >>
     a  b       b  d
     */
    static const GLfloat rotateLeftTextureCoordinates[] = {
        1.0f, 0.0f,// b
        1.0f, 1.0f,// d
        0.0f, 0.0f,// a
        0.0f, 1.0f,// c
    };
    
    /**
     c  d       d  b
            >>
     a  b       c  a
     */
    static const GLfloat rotateRightTextureCoordinates[] = {
        0.0f, 1.0f,// c
        0.0f, 0.0f,// a
        1.0f, 1.0f,// d
        1.0f, 0.0f,// b
    };
    
    /**
     c  d       a  b
            >>
     a  b       c  d
     */
    static const GLfloat verticalFlipTextureCoordinates[] = {
        0.0f, 1.0f,// c
        1.0f, 1.0f,// d
        0.0f, 0.0f,// a
        1.0f, 0.0f,// b
    };
    
    /**
     c  d       d  c
            >>
     a  b       b  a
     */
    static const GLfloat horizontalFlipTextureCoordinates[] = {
        1.0f, 0.0f,// b
        0.0f, 0.0f,// a
        1.0f, 1.0f,// d
        0.0f, 1.0f,// c
    };
    
    /**
     c  d       b  d
            >>
     a  b       a  c
     */
    static const GLfloat rotateRightVerticalFlipTextureCoordinates[] = {
        0.0f, 0.0f,// a
        0.0f, 1.0f,// c
        1.0f, 0.0f,// b
        1.0f, 1.0f,// d
    };
    
    /**
     c  d       c  a
            >>
     a  b       d  b
     */
    static const GLfloat rotateRightHorizontalFlipTextureCoordinates[] = {
        1.0f, 1.0f,// d
        1.0f, 0.0f,// b
        0.0f, 1.0f,// c
        0.0f, 0.0f,// a
    };
    
    /**
     c  d       b  a
            >>
     a  b       d  c
     */
    static const GLfloat rotate180TextureCoordinates[] = {
        1.0f, 1.0f,// d
        0.0f, 1.0f,// c
        1.0f, 0.0f,// b
        0.0f, 0.0f,// a
    };
    
    switch(rotationMode)
    {
        case LGPUImageNoRotation: return noRotationTextureCoordinates;
        case LGPUImageRotateLeft: return rotateLeftTextureCoordinates;
        case LGPUImageRotateRight: return rotateRightTextureCoordinates;
        case LGPUImageFlipVertical: return verticalFlipTextureCoordinates;
        case LGPUImageFlipHorizonal: return horizontalFlipTextureCoordinates;
        case LGPUImageRotateRightFlipVertical: return rotateRightVerticalFlipTextureCoordinates;
        case LGPUImageRotateRightFlipHorizontal: return rotateRightHorizontalFlipTextureCoordinates;
        case LGPUImageRotate180: return rotate180TextureCoordinates;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
