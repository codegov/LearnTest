

#import "GKBlueViewController.h"
#import "SVProgressHUD.h"

@interface GKBlueViewController ()
{
    GKPeerPickerController *pickerController;
    GKSession *currentSession;
}
@end

@implementation GKBlueViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"连接" style:UIBarButtonItemStyleDone target:self action:@selector(blueToothClient)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self addGestRecognizer];
}

#pragma mark - click

// 1.蓝牙连接
- (void)blueToothClient
{
    pickerController = [[GKPeerPickerController alloc] init];
    pickerController.delegate = self;
    //网络连接或蓝牙都可以
    pickerController.connectionTypesMask = GKPeerPickerConnectionTypeNearby;//GKPeerPickerConnectionTypeOnline|
    [pickerController show];
}

// 2.发送数据
- (IBAction)sendMsg:(id)sender
{
    if(currentSession)
    {
        NSString *card = cardTextField.text;
        NSString *money = moneyTextField.text;
        NSString *msg = [NSString stringWithFormat:@"卡号：%@,金额：%@",card,money];
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        [currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
    }
}

// 取消连接
- (IBAction)closeSession:(id)sender
{
    [currentSession disconnectFromAllPeers];
    currentSession = nil;
    pickerController.delegate = nil;
}

#pragma mark - 空白处收起键盘

- (void)addGestRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    tap.numberOfTouchesRequired =1;
    tap.numberOfTapsRequired =1;
    tap.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:tap];
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

#pragma mark - GKPeerPickerControllerDelegate

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    currentSession = [[GKSession alloc] initWithSessionID:@"sunnada_CoreBlueToothDemo" displayName:nil sessionMode:GKSessionModePeer];
    currentSession.delegate = self;
	
    return currentSession;
}
/* Notifies delegate that the user cancelled the picker.
 * 如果用户取消了蓝牙选择器
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    [SVProgressHUD showErrorWithStatus:@"蓝牙连接取消"];
    picker.delegate = nil;
    currentSession = nil;
}

//连接后
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    
    picker.delegate = nil;
    [picker dismiss];
}

#pragma mark - GKSessionDelegate

//设备断开或连接时
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state)
    {
        case GKPeerStateConnected:
            [SVProgressHUD showSuccessWithStatus:@"蓝牙已连接"];
            break;
        case GKPeerStateDisconnected:
            [SVProgressHUD showSuccessWithStatus:@"蓝牙已断开"];
            pickerController.delegate = nil;
            currentSession = nil;
            break;
        default:
            break;
    }
}

//方法功能：接受数据
- (void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)session context:(void*)context
{
    NSString* msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [SVProgressHUD showSuccessWithStatus:@"数据接收成功"];
    resultTextField.text = msg;
}

@end
