#import <libactivator/libactivator.h>
#import "LetsTakePicturesViewController.h"

extern "C" UIImage* _UICreateScreenUIImage();

@interface ShareAnywhere : NSObject <LAListener>
@end

@implementation ShareAnywhere

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    //Shiiit

	UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// It goes over everything, even alert dialogs (and up to the 2 alert dialogs on top of that same dialog)
	alertWindow.windowLevel = UIWindowLevelAlert + 2;

	UIImage *screenshot = _UICreateScreenUIImage();

	[alertWindow setBackgroundColor:[UIColor clearColor]];


	alertWindow.rootViewController = [UIViewController new];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Would you like to share?"
            message:@"" 
            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Share picture"
            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            	[screenshot release];
            	//Do picture shit.
                //NSLog(@"You pressed button one");

                LetsTakePicturesViewController *controller = [[LetsTakePicturesViewController alloc] init];

                controller.windowRef = alertWindow;

                [alertWindow.rootViewController presentViewController:controller animated:YES completion:nil];

            }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Share text"
            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            	[screenshot release];
                //NSLog(@"You pressed button two");
                NSString *shareText = @"";
                
                NSArray *array_Object = @[shareText];
                
                
                UIActivityViewController *obj_activity = [[UIActivityViewController alloc] initWithActivityItems:array_Object applicationActivities:nil];
                #pragma GCC diagnostic push
                #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                [obj_activity setCompletionHandler:^(NSString *activityType, BOOL completed){

                    alertWindow.hidden = YES;
                }];
                #pragma GCC diagnostic pop
                
                [alertWindow.rootViewController presentViewController:obj_activity animated:YES completion:nil];
            }];

    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Share screenshot"
            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            	//Do screenshot stuff

            	NSArray *array_Object = @[screenshot];
                
                
                UIActivityViewController *obj_activity = [[UIActivityViewController alloc] initWithActivityItems:array_Object applicationActivities:nil];
                #pragma GCC diagnostic push
                #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                [obj_activity setCompletionHandler:^(NSString *activityType, BOOL completed){
                	[screenshot release];
                    alertWindow.hidden = YES;
                }];
                #pragma GCC diagnostic pop
                
                [alertWindow.rootViewController presentViewController:obj_activity animated:YES completion:nil];
            }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
    		style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    			alertWindow.hidden = YES;
    			[screenshot release];
    		}];

    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    [alert addAction:cancelAction];

    [alertWindow makeKeyAndVisible];

    [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
    [event setHandled:YES]; // To prevent the default OS implementation
}


+ (void)load {
    if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"])
        [[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.wizages.ShareAnywhere.All"];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"ShareAnywhere Selector";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Shows options to share: A just taken screenshot, take a picture and share it, or text that you want to write.";
}


@end