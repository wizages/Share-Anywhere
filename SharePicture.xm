#import <libactivator/libactivator.h>
#import "LetsTakePicturesViewController.h"

@interface ShareAnywherePicture : NSObject <LAListener>
@end

@implementation ShareAnywherePicture

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    //Shiiit

	UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// It goes over everything, even alert dialogs (and up to the 2 alert dialogs on top of that same dialog)
	alertWindow.windowLevel = UIWindowLevelAlert + 2;

    LetsTakePicturesViewController *controller = [[LetsTakePicturesViewController alloc] init];

    controller.windowRef = alertWindow;

	[alertWindow setBackgroundColor:[UIColor clearColor]];

	alertWindow.rootViewController = [UIViewController new];

    [alertWindow makeKeyAndVisible];

    [alertWindow.rootViewController presentViewController:controller animated:YES completion:nil];
    
    [event setHandled:YES]; // To prevent the default OS implementation
}


+ (void)load {
    if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"])
        [[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.wizages.ShareAnywhere.Pic"];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"ShareAnywhere Take a picture";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Take a picture and immediatly share it.";
}


@end