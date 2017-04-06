//
//  LetsTakePicturesViewController.m
//  StorysEverwhere
//
//  Created by wizage on 4/3/17.
//  Copyright © 2017 wizages. All rights reserved.
//

#import "LetsTakePicturesViewController.h"
#import "LLSimpleCamera/LLSimpleCamera.h"

#define kBundlePath @"/Library/Application Support/ShareAnywhereBundle.bundle"

@interface LetsTakePicturesViewController ()

@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) LLSimpleCamera *camera;

@end

@implementation LetsTakePicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSBundle *bundle = [[[NSBundle alloc] initWithPath:kBundlePath] autorelease];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:NO];
    // attach to the view
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.frame.size.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.flashButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    self.flashButton.tintColor = [UIColor whiteColor];
    [self.flashButton setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"camera-flash" ofType:@"png"]] forState:UIControlStateNormal];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    if([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable]) {
        // button to toggle camera positions
        self.switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.switchButton.frame = CGRectMake(0, 0, 29.0f + 20.0f, 22.0f + 20.0f);
        self.switchButton.tintColor = [UIColor whiteColor];
        [self.switchButton setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"camera-switch" ofType:@"png"]] forState:UIControlStateNormal];
        self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.switchButton];
    }
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = CGRectMake(0, 0, 29.0f + 20.0f, 29.0f + 20.0f);
    self.cancelButton.tintColor = [UIColor whiteColor];
    [self.cancelButton setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"cancel" ofType:@"png"]] forState:UIControlStateNormal];
    self.cancelButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.camera start];
   
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    self.windowRef.hidden = true;
}

- (void)switchButtonPressed:(UIButton *)button
{
    [self.camera togglePosition];
}

-(void)cancelButtonPressed:(UIButton *)button{
    [self.camera stop];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)flashButtonPressed:(UIButton *)button
{
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}

- (void)snapButtonPressed:(UIButton *)button
{
    
    // capture
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            [self.camera stop];
            NSString *shareText = @"Stories are boring so why not add them everywhere! #wizage";
            
            NSArray *array_Object = @[shareText, image];
            
            
            UIActivityViewController *obj_activity = [[UIActivityViewController alloc] initWithActivityItems:array_Object applicationActivities:nil];
            #pragma GCC diagnostic push
            #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            [obj_activity setCompletionHandler:^(NSString *activityType, BOOL completed){
                [self dismissViewControllerAnimated:true completion:nil];
                [image release];
            }];
            #pragma GCC diagnostic pop
            
            [self presentViewController:obj_activity animated:YES completion:nil];
            
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/* other lifecycle methods */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.frame;
    
    self.snapButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height-50.0f);
    
    self.flashButton.center = CGPointMake(self.view.center.x, 30.0f);
    
    self.switchButton.center = CGPointMake(30.0f, 30.0f);
    
    self.cancelButton.center = CGPointMake(self.view.frame.size.width-30.0f, 30.0f);
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
