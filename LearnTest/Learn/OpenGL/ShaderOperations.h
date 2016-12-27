//
//  ShaderOperations.h
//  LearnTest
//
//  Created by javalong on 2016/12/19.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface ShaderOperations : NSObject

+ (GLuint)compileShaderFileName:(NSString *)fileName withType:(GLenum)shaderType;
+ (GLuint)compileShaderVertexName:(NSString *)vertexName fragmentName:(NSString *)fragmentName;

@end
