//
//  Test3TouchView.h
//  OpenGLDemo
//
//  Created by Chris Hu on 15/8/25.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Test3TouchViewDelegate <NSObject>

@optional
- (void)test3TouchViewWithPoints:(NSArray *)points rect:(CGRect)rect;

@end

@interface Test3TouchView : UIView

@property (nonatomic, weak) id<Test3TouchViewDelegate> delegate;

@end
