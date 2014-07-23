//
//  Go.Away.Period.Button Tweak
//
//  Messages Hook
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#ifdef DEBUG
	#define DebugLog(s, ...) NSLog(@"[Go.Away.Period.Button (SMS)] >> %@", [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
	#define DebugLog(s, ...)
#endif


#define PREFS_PLIST_PATH	@"/private/var/mobile/Library/Preferences/com.rcrepo.safaridefaultkeyboard.plist"

static NSString *keyboardSMS = nil;



//
// Load user preferences.
//
static void loadPreferences() {
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:PREFS_PLIST_PATH];
    DebugLog(@"loaded preferences, got this: %@", prefs);
	
	if (prefs && prefs[@"keyboardSMS"]) {
		DebugLog(@"found setting for keyboardSMS: %@", prefs[@"keyboardSMS"]);
		keyboardSMS = prefs[@"keyboardSMS"];
	} else {
		// use default setting
		keyboardSMS = @"default";
	}	
    DebugLog(@"using setting: keyboardSMS = %@", keyboardSMS);
}



//
// Handle notifications from Settings.
//
static void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name,
						 const void *object, CFDictionaryRef userInfo) {

	DebugLog(@"******** Settings Changed Notification ********");
	system("killall -HUP MobileSMS");
}



//
// Override the keyboard type.
// Possible return values are the following...
//
//		typedef enum : NSInteger {
//	   		UIKeyboardTypeDefault,							// 0
//	   		UIKeyboardTypeASCIICapable,								
//	   		UIKeyboardTypeNumbersAndPunctuation,					
//	   		UIKeyboardTypeURL,								// 3
//	   		UIKeyboardTypeNumberPad,								
//	   		UIKeyboardTypePhonePad,									
//	   		UIKeyboardTypeNamePhonePad,			
//	   		UIKeyboardTypeEmailAddress,
//	   		UIKeyboardTypeDecimalPad,
//	   		UIKeyboardTypeTwitter,
//	   		UIKeyboardTypeWebSearch,
//	   		UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable
//		} UIKeyboardType;
//
%hook UITextInputTraits
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
	return result;
}
%end


		
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
	}
}
