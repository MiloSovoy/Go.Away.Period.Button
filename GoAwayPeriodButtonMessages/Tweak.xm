//
<<<<<<< HEAD
// Go.Away.Period.Button
//
// Safari Hook
=======
//  Go.Away.Period.Button Tweak
//
//  Messages Hook
>>>>>>> FETCH_HEAD
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


<<<<<<< HEAD
#define PREFS_PLIST_PATH	@"/private/var/mobile/Library/Preferences/com.rcrepo.safaridefaultkeyboard.plist"
// should be using [NSHomeDirectory() stringByAppendingPathComponent:] here, but it isn't working ??
=======
#ifdef DEBUG
	#define DebugLog(s, ...) NSLog(@"[Go.Away.Period.Button (SMS)] >> %@", [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
	#define DebugLog(s, ...)
#endif


#define PREFS_PLIST_PATH	@"/private/var/mobile/Library/Preferences/com.rcrepo.safaridefaultkeyboard.plist"
>>>>>>> FETCH_HEAD

static NSString *keyboardSMS = nil;



//
// Load user preferences.
//
static void loadPreferences() {
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:PREFS_PLIST_PATH];
<<<<<<< HEAD
		// NSLog(@"[Go.Away.Period.Button] loaded preferences, got this: %@", prefs);

	if (prefs && prefs[@"keyboardSMS"]) {
				// NSLog(@"[Go.Away.Period.Button] found setting for keyboardSMS: %@", prefs[@"keyboardSMS"]);
			keyboardSMS = prefs[@"keyboardSMS"];
	} else {
		// use default setting
		keyboardSMS = @"default";
	}

		// NSLog(@"[Go.Away.Period.Button] using setting: keyboardSMS = %@", keyboardSMS);
=======
    DebugLog(@"loaded preferences, got this: %@", prefs);
	
	if (prefs && prefs[@"keyboardSMS"]) {
		DebugLog(@"found setting for keyboardSMS: %@", prefs[@"keyboardSMS"]);
		keyboardSMS = prefs[@"keyboardSMS"];
	} else {
		// use default setting
		keyboardSMS = @"default";
	}	
    DebugLog(@"using setting: keyboardSMS = %@", keyboardSMS);
>>>>>>> FETCH_HEAD
}



//
<<<<<<< HEAD
// Apply settings again when returning from background.
//
%hook Application
- (void)applicationWillEnterForeground:(UIApplication *)application {
	%orig;
	loadPreferences();
}
%end
=======
// Handle notifications from Settings.
//
static void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name,
						 const void *object, CFDictionaryRef userInfo) {

	DebugLog(@"******** Settings Changed Notification ********");
	system("killall -HUP MobileSMS");
}
>>>>>>> FETCH_HEAD



//
// Override the keyboard type.
// Possible return values are the following...
//
//		typedef enum : NSInteger {
//	   		UIKeyboardTypeDefault,							// 0
<<<<<<< HEAD
//	   		UIKeyboardTypeASCIICapable,
//	   		UIKeyboardTypeNumbersAndPunctuation,
//	   		UIKeyboardTypeURL,								// 3
//	   		UIKeyboardTypeNumberPad,
//	   		UIKeyboardTypePhonePad,
//	   		UIKeyboardTypeNamePhonePad,
=======
//	   		UIKeyboardTypeASCIICapable,								
//	   		UIKeyboardTypeNumbersAndPunctuation,					
//	   		UIKeyboardTypeURL,								// 3
//	   		UIKeyboardTypeNumberPad,								
//	   		UIKeyboardTypePhonePad,									
//	   		UIKeyboardTypeNamePhonePad,			
>>>>>>> FETCH_HEAD
//	   		UIKeyboardTypeEmailAddress,
//	   		UIKeyboardTypeDecimalPad,
//	   		UIKeyboardTypeTwitter,
//	   		UIKeyboardTypeWebSearch,
//	   		UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable
//		} UIKeyboardType;
//
%hook UITextInputTraits
<<<<<<< HEAD
- (int)keyboardType {
	int result = %orig;

	if (keyboardSMS) {

		if ([keyboardSMS isEqualToString:@"default"]) {
			result = 0;
				// NSLog(@"[Go.Away.Period.Button] keyboardType >> forcing value:%d", result);

		} else if ([keyboardSMS isEqualToString:@"address"]) {
			result = 3;
				// NSLog(@"[Go.Away.Period.Button] keyboardType >> forcing value:%d", result);
		}
	}

=======
- (int) keyboardType {
	int result = %orig;	
	
	if (keyboardSMS) {		
		if ([keyboardSMS isEqualToString:@"default"]) {
			result = UIKeyboardTypeDefault;
		    DebugLog(@"keyboardType >> forcing value:%d", result);
		} else if ([keyboardSMS isEqualToString:@"address"]) {
			result = UIKeyboardTypeURL;
		    DebugLog(@"keyboardType >> forcing value:%d", result);
		}
	}
>>>>>>> FETCH_HEAD
	return result;
}
%end

<<<<<<< HEAD


// Initialization stuff
%ctor {
	@autoreleasepool {
			NSLog(@" [Go.Away.Period.Button] init.");
		loadPreferences();
=======

		
// Initialization stuff
%ctor {	
	@autoreleasepool {
	    NSLog(@" Go.Away.Period.Button (SMS) loaded.");
		loadPreferences();
		
		//start listening for notifications from Settings
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
										NULL,
										(CFNotificationCallback)prefsChanged,
										CFSTR("com.rcrepo.safaridefaultkeyboard/prefschanged-SMS"),
										NULL,
										CFNotificationSuspensionBehaviorDeliverImmediately
		);
		
		%init;
>>>>>>> FETCH_HEAD
	}
}
