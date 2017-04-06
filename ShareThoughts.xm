#import <libactivator/libactivator.h>
#import "LetsTakePicturesViewController.h"

@interface ShareAnywhereText : NSObject <LAListener>
@end

@implementation ShareAnywhereText

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    //Shiiit

	UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// It goes over everything, even alert dialogs (and up to the 2 alert dialogs on top of that same dialog)
	alertWindow.windowLevel = UIWindowLevelAlert + 2;

	[alertWindow setBackgroundColor:[UIColor clearColor]];

	alertWindow.rootViewController = [UIViewController new];

    [alertWindow makeKeyAndVisible];

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
    
    [event setHandled:YES]; // To prevent the default OS implementation
}


+ (void)load {
    if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"])
        [[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.wizages.ShareAnywhere.Txt"];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"ShareAnywhere Share some text";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Share your thoughs via text";
}


@end