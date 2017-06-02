//
//  TestRuntime1ViewController.m
//  LearnTest
//
//  Created by syq on 14/12/17.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestRuntime1ViewController.h"
#include <objc/runtime.h>

/**
 ===============================================
 */

@interface TestRuntime : NSObject
{
    NSString *name;
    TestRuntime *runtime;
    double time;
    long isToday;
}
@property (nonatomic) int count;
@property (nonatomic, strong) NSString *password;

@end

@implementation TestRuntime

- (void)test1
{
    NSLog(@"%@执行test1", [self class]);
}

@end

/**
 ===============================================
 */

@interface TestRun : NSObject

@end

@implementation TestRun

- (void)test1
{
    NSLog(@"%@执行test1", [self class]);
}

@end

/**
 ===============================================
 */

@implementation TestRuntime1ViewController

/**
 Objective-C runtime是一个实现Objective-C语言的C库;
 
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    u_int count;
    Method *method = class_copyMethodList([TestRuntime1ViewController class], &count);
    for (int i = 0 ; i < count; i++) {
        SEL name = method_getName(method[i]);
        NSString *str = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
//        NSLog(@"方法名称为：%@", str);
        if ([str hasPrefix:@"test"]) {
            NSLog(@"方法%@执行结果为：", str);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:name];
#pragma clang diagnostic pop
            NSLog(@"\n\n");
        }
    }
}

+ (void)load{
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(viewWillAppear:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(swiz_viewWillAppear:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}
- (void)swiz_viewWillAppear:(BOOL)animated{
    //这时候调用自己，看起来像是死循环
    //但是其实自己的实现已经被替换了
    [self swiz_viewWillAppear:animated];
    NSLog(@"swizzle");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)test1
{
//    TestRuntime *run = [[TestRuntime alloc] init];
//    // object_copy 函数实现了对象的拷贝。
//    id copyRun = object_copy(run, sizeof(run)); //OBJC_ARC_UNAVAILABLE
//    [copyRun test1];
}

- (void)test2
{
//    TestRuntime *run = [[TestRuntime alloc] init];
//    // 对象释放 id object_dispose(id obj)
//    object_dispose(run); //OBJC_ARC_UNAVAILABLE
}

- (void)test3
{
    TestRuntime *runtime = [[TestRuntime alloc] init];
    [runtime test1];
    
    Class aclass = object_setClass(runtime, [TestRun class]);
    //obj 对象的类被更改了    swap the isa to an isa
    NSLog(@"改变之前为:%@", NSStringFromClass(aclass));
    NSLog(@"改变之后为:%@", NSStringFromClass([runtime class]));
    [runtime test1];
}

- (void)test4
{
    TestRuntime *runtime = [[TestRuntime alloc] init];
    Class class = object_getClass(runtime);
    NSLog(@"一方式获得类名为：%@", NSStringFromClass(class));
    NSString *className = [NSString stringWithCString:object_getClassName(runtime) encoding:NSUTF8StringEncoding];
    NSLog(@"二方式获得类名为：%@", className);
}

- (void)test5
{
    /**
     其中types参数为"i@:@“，按顺序分别表示：
     i：返回值类型int，若是v则表示void
     @：参数id(self)
     :：SEL(_cmd)
     @：id(str)
     */
//    TestRuntime *runtime = [[TestRuntime alloc] init];
//    class_addMethod([TestRuntime class], @selector(ocMethod:), (IMP)c1funtion, "i@:@");
//    if ([runtime respondsToSelector:@selector(ocMethod:)]) {
//       int a = [runtime performSelector:@selector(ocMethod:) withObject:@"哈哈"];
//        NSLog(@"a:%d", a);
//    }
//    class_addMethod([TestRuntime class], @selector(ocMethod::), (IMP)c2funtion, "i@:@");
//    if ([runtime respondsToSelector:@selector(ocMethod::)]) {
//        int a = [runtime performSelector:@selector(ocMethod::) withObject:@"哈哈" withObject:@"呵呵"];
//        NSLog(@"a:%d", a);
//    }
}

int c1funtion(id self, SEL _cmd, NSString *str)
{
    NSLog(@"%@", str);
    return 3;
}

int c2funtion(id self, SEL _cmd, NSString *str1, NSString *str2)
{
    NSLog(@"%@_%@", str1, str2);
    return 6;
}

- (void)test6
{
    u_int count;
    Method *method = class_copyMethodList([TestRuntime class], &count);
    for (int i = 0 ; i < count; i++) {
        SEL name = method_getName(method[i]);
        NSString *str = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        NSLog(@"方法名称为：%@", str);
    }
}

- (void)test7
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList([TestRuntime class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *str = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        NSLog(@"属性名称为：%@", str);
    }
}

- (void)test8
{
//    NSString *name = @"嘻嘻";
//    object_setInstanceVariable(<#id obj#>, <#const char *name#>, <#void *value#>) // OBJC_ARC_UNAVAILABLE
//    object_getInstanceVariable //OBJC_ARC_UNAVAILABLE
}

// 判断类的某个属性的类型
- (void)test9
{
    TestRuntime *runtime = [[TestRuntime alloc] init];
    
    Ivar var = class_getInstanceVariable(object_getClass(runtime), "isToday"); //name
    const char *typeEncoding = ivar_getTypeEncoding(var);
    NSString *typeString = [NSString stringWithCString:typeEncoding encoding:NSUTF8StringEncoding];
    if ([typeString hasPrefix:@"@"]) {
        NSLog(@"以@开头");
    } else if ([typeString hasPrefix:@"i"]) {
        NSLog(@"以i开头");
    } else if ([typeString hasPrefix:@"f"]) {
        NSLog(@"以f开头");
    } else {
        NSLog(@"其他:%@", typeString);
    }
}

// 通过属性的值来获取其属性的名字（反射机制)
- (void)test10
{
    TestRuntime *runtime = [[TestRuntime alloc] init];
    runtime.count = 10;
    runtime.password = @"wenzhang";
    
    unsigned int numIvars = 0;
    NSString *key = nil;
    Ivar *ivars = class_copyIvarList([TestRuntime class], &numIvars);
    for (int i = 0; i < numIvars; i ++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {  //不是class就跳过
            continue;
        }
        // object_getIvar这个方法中，当遇到非objective-c对象时，就会直接crash
        if (object_getIvar(runtime, thisIvar) == runtime.password) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            NSLog(@"找到了，属性名称为：%@", key);
        }
    }
    free(ivars);
}

// 系统类的方法实现部分替换
- (void)test11
{
    Method m1 = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method m2 = class_getInstanceMethod([NSString class], @selector(uppercaseString));
    
    method_exchangeImplementations(m1, m2);
    
    NSLog(@"%@", [@"sssAAAAss" lowercaseString]);
    NSLog(@"%@", [@"sssAAAAss" uppercaseString]);
}

// 自定义类的方法实现部分替换

- (void)test12
{
    Method m1 = class_getInstanceMethod([TestRuntime1ViewController class], @selector(test11));
    IMP oimp = method_getImplementation(m1);
    Method m2 = class_getInstanceMethod([TestRuntime1ViewController class], @selector(test1));
    method_setImplementation(m2, oimp);
    [self test1];
}

- (void)test13
{
    NSString *test = @"test";
    NSLog(@"%@", [@"test" class]);
    
    class_replaceMethod([NSString class],@selector(uppercaseString), (IMP)CustomUppercaseString,"@@:");
    class_replaceMethod([NSString class],@selector(componentsSeparatedByString:), (IMP)CustomComponentsSeparatedByString,"@@:@");
    class_replaceMethod([NSString class],@selector(isEqualToString:), (IMP)CustomEqualString,"B@:@");
    
    [test uppercaseString];
    [test componentsSeparatedByString:@","];
    [test isEqualToString:@"12"];
}

NSString* CustomUppercaseString(id self,SEL _cmd)
{
    printf("真正起作用的是本函数CustomUppercaseString\r\n");
    return @"1";
}
NSArray* CustomComponentsSeparatedByString(id self,SEL _cmd,NSString *str)
{
    printf("真正起作用的是本函数CustomComponentsSeparatedByString\r\n");
    return [[NSArray alloc] initWithObjects:@"2", nil];
}
//不起作用，求解释 原因：@"test"是__NSCFConstantString类型；__NSCFConstantString继承__NSCFString继承NSMutableString继承NSString; 而__NSCFString重写了isEqualToString:
/**
 u_int count1;//
 Class class = NSClassFromString(@"__NSCFConstantString");
 Class class1 = [class superclass];
 Method *method1 = class_copyMethodList(class1, &count1);
 NSLog(@"==%@", NSStringFromClass(class1));
 NSLog(@"==%@", NSStringFromClass([class1 superclass]));
 for (int i = 0 ; i < count1; i++) {
 SEL name = method_getName(method1[i]);
 NSString *str = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
 NSLog(@"==方法名称为：%@", str);
 }
 */
bool CustomEqualString(id self,SEL _cmd,NSString *str)
{
    printf("真正起作用的是本函数CustomEqualString\r\n");
    return YES;
}


@end
