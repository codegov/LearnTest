//
//  BlueYaTest1ViewController.m
//  LearnTest
//
//  Created by syq on 15/5/11.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "BlueYaTest1ViewController.h"


@interface BlueYaTest1ViewController ()
{
    CBCentralManager *manager;
    
    NSMutableArray *blueArray;
    
    NSMutableArray *serviceArray;
    
    NSIndexPath *_indexPath;
}
@end

@implementation BlueYaTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    blueArray = [[NSMutableArray alloc] init];
    serviceArray = [[NSMutableArray alloc] init];
    
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"扫描" style:UIBarButtonItemStyleDone target:self action:@selector(doAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)doAction
{
    NSLog(@"doaction");
    [blueArray removeAllObjects];
    [serviceArray removeAllObjects];
    [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

//manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];代码这里我们创建了一个CBCentralManager,用来发现外设，当创建成功，CBCentralManager会回调代理说创建成功了
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString * state = nil;
    
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            state = @"work";
            break;
        case CBCentralManagerStateUnknown:
        default:
            ;
    }
    
    NSLog(@"Central manager state: %@", state);
}


- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
    
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    
}

//发现一个蓝牙设备,也就是收到了一个周围的蓝牙发来的广告信息，会通知此代理来处理
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    NSString *str = [NSString stringWithFormat:@"Did discover peripheral. peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.UUID, advertisementData];
//    NSLog(@"%@",str);
//    
//    [manager stopScan];
//    BOOL replace = NO;
//    // Match if we have this device from before
//    for (int i=0; i < blueArray.count; i++) {
//        CBPeripheral *p = [blueArray objectAtIndex:i];
//        if ([p isEqual:peripheral]) {
//            [blueArray replaceObjectAtIndex:i withObject:peripheral];
//            replace = YES;
//        }
//    }
//    if (!replace) {
//        [blueArray addObject:peripheral];
//        [self.tableView reloadData];
//    }
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

//连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}




- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",peripheral,pow(10,ci)];
    NSLog(@"距离：%@",length);
}

//已发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices ===%@", peripheral.services.firstObject);
    for (CBService *s in peripheral.services) {
        [serviceArray addObject:s];
    }
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

//已搜索到Characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{

    for (CBCharacteristic *c in service.characteristics)
    {
        NSLog(@"didDiscoverCharacteristicsForService ===%@", c.UUID);
//        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A06"]]) {
//            _writeCharacteristic = c;
//        }
//        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
//            [_peripheral readValueForCharacteristic:c];
//        }
//        
//        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
//            [_peripheral readRSSI];
//        }
//        [_nCharacteristics addObject:c];
    }
}


//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // BOOL isSaveSuccess;
    NSLog(@"didUpdateValueForCharacteristic == %@", characteristic.UUID);
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
//        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
//        _batteryValue = [value floatValue];
//        NSLog(@"电量%f",_batteryValue);
//    }
//    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
//        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
//        //_batteryValue = [value floatValue];
//        NSLog(@"信号%@",value);
//    }
//    
//    else
//        NSLog(@"didUpdateValueForCharacteristic%@",[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
}




#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return blueArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    
    CBPeripheral *p = [blueArray objectAtIndex:indexPath.row];
    cell.textLabel.text = p.name;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CBPeripheral *p = [blueArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_indexPath == nil || [_indexPath compare:indexPath] == NSOrderedSame) {
        [manager connectPeripheral:p options:nil];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ 已连接", p.name];
        _indexPath = indexPath;
    } else {
        [manager cancelPeripheralConnection:p];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ 已断开", p.name];
        _indexPath = indexPath;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
