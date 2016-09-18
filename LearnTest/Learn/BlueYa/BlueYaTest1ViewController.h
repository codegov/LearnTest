//
//  BlueYaTest1ViewController.h
//  LearnTest
//
//  Created by syq on 15/5/11.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "LearnTableViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueYaTest1ViewController : LearnTableViewController<CBCentralManagerDelegate,CBPeripheralDelegate>

@end
