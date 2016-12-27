//
//  ShaderOperations.m
//  LearnTest
//
//  Created by javalong on 2016/12/19.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "ShaderOperations.h"

@implementation ShaderOperations

+ (GLuint)compileShaderFileName:(NSString *)fileName withType:(GLenum)shaderType
{
    // 1 查找shader文件
    NSString *shaderPath   = [[NSBundle mainBundle] pathForResource:fileName ofType:@"glsl"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString)
    {
        NSLog(@"Error loading shader:%@", error.localizedDescription);
        exit(1);
    }
    
    // 2 创建一个代表shader的OpenGL对象, 指定vertex或fragment shader
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3 获取shader的source
    const char *shaderStringUTF8  = [shaderString UTF8String];
    GLint shaderStringLength      = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4 编译shader
    glCompileShader(shaderHandle);
    
    // 5 查询shader对象的信息
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE)
    {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"Error compile shader:%@", messageString);
        exit(1);
    }
    return shaderHandle;
}

+ (GLuint)compileShaderVertexName:(NSString *)vertexName fragmentName:(NSString *)fragmentName
{
    // 1 vertex和fragment两个shader都要编译
    GLuint vertexShader   = [ShaderOperations compileShaderFileName:vertexName   withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [ShaderOperations compileShaderFileName:fragmentName withType:GL_FRAGMENT_SHADER];
    
    // 2 连接vertex和fragment shader成一个完整的program
    GLuint glProgram = glCreateProgram();
    glAttachShader(glProgram, vertexShader);
    glAttachShader(glProgram, fragmentShader);
    
    // link program
    glLinkProgram(glProgram);
    
    // 3 check link status
    GLint linkSuccess;
    glGetProgramiv(glProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE)
    {
        GLchar messages[256];
        glGetProgramInfoLog(glProgram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"Error link program:%@", messageString);
        exit(1);
    }
    return glProgram;
}

@end
