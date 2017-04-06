extern "C" UIImage* _UICreateScreenUIImage();

%hook SBScreenshotManager


- (void)saveScreenshots {

	UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// It goes over everything, even alert dialogs (and up to the 2 alert dialogs on top of that same dialog)
	alertWindow.windowLevel = UIWindowLevelAlert + 2;

	UIImage *screenshot = _UICreateScreenUIImage();

	[alertWindow setBackgroundColor:[UIColor clearColor]];


	alertWindow.rootViewController = [UIViewController new];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Screenshot"
            message:@"What would you like to do?" 
            preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Save"
            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            	[screenshot release];
            	alertWindow.hidden = YES;
                //NSLog(@"You pressed button two");
                %orig;
            }];

    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Share"
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
    [alert addAction:cancelAction];

    [alertWindow makeKeyAndVisible];

    [alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];

}


%end