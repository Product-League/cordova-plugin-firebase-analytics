#import "FirebaseAnalyticsPlugin.h"

@import Firebase;
@import AppTrackingTransparency;

@implementation FirebaseAnalyticsPlugin

- (void)pluginInitialize {
    NSLog(@"Starting Firebase Analytics plugin");

    if(![FIRApp defaultApp]) {
        [FIRApp configure];
    }
}

- (void)logEvent:(CDVInvokedUrlCommand *)command {
    NSString* name = [command.arguments objectAtIndex:0];
    NSDictionary* parameters = [command.arguments objectAtIndex:1];

    [FIRAnalytics logEventWithName:name parameters:parameters];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setUserId:(CDVInvokedUrlCommand *)command {
    NSString* id = [command.arguments objectAtIndex:0];

    [FIRAnalytics setUserID:id];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setUserProperty:(CDVInvokedUrlCommand *)command {
    NSString* name = [command.arguments objectAtIndex:0];
    NSString* value = [command.arguments objectAtIndex:1];

    [FIRAnalytics setUserPropertyString:value forName:name];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setEnabled:(CDVInvokedUrlCommand *)command {
    bool enabled = [[command.arguments objectAtIndex:0] boolValue];

    [FIRAnalytics setAnalyticsCollectionEnabled:enabled];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setCurrentScreen:(CDVInvokedUrlCommand *)command {
    NSString* screenName = [command.arguments objectAtIndex:0];

    [FIRAnalytics logEventWithName:kFIREventScreenView parameters:@{
        kFIRParameterScreenName: screenName
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)resetAnalyticsData:(CDVInvokedUrlCommand *)command {
    [FIRAnalytics resetAnalyticsData];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setDefaultEventParameters:(CDVInvokedUrlCommand *)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];

    [FIRAnalytics setDefaultEventParameters:params];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)requestTrackingAuthorization {
    
    if (@available(iOS 14, *)) {
        
        if(ATTrackingManager.trackingAuthorizationStatus == ATTrackingManagerAuthorizationStatusNotDetermined) {
            
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                switch(status) {
                    case ATTrackingManagerAuthorizationStatusAuthorized:
                        break;
                        
                    default:
                        break;
                }
            }];
            
        }
        
    }
    else {
        // Fallback on earlier versions
    }
}

typedef void (^showPermissionInformationPopupHandler)(UIAlertAction*);
- (void)showPermissionInformationPopup:(showPermissionInformationPopupHandler)confirmationHandler {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Title"
                                message:@"text mssg"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:confirmationHandler];
    
    [alert addAction:okAction];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}



@end
