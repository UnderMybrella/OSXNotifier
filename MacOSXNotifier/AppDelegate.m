//
//  AppDelegate.m
//  MacOSXNotifier
//
//  Created by Isaac H. on 3/04/2016.
//  Copyright © 2016 Isaac H. All rights reserved.
//

#import "AppDelegate.h"

#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    // Create server
    GCDWebServer* webServer = [[GCDWebServer alloc] init];
    
    // Add a handler to respond to GET requests on any URL
    [webServer addHandlerForMethod:@"GET"
                             pathRegex:@"/notification"
                             requestClass:[GCDWebServerRequest class]
                             processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                 
                                 
                                 NSString* url = [request.URL absoluteString];
                                 NSLog(@"Path: %@", url);
                                 
                                 NSArray* components = [[url stringByReplacingOccurrencesOfString:@"http://localhost:11038/notification?" withString:@""] componentsSeparatedByString:@"&"];
                                 NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                                 
                                 NSUserNotification *notification = [[NSUserNotification alloc] init];
                                 for(NSString* s in components){
                                     NSArray* parts = [s componentsSeparatedByString:@"="];
                                     NSLog(@"%@", parts);
                                     if([parts count] == 1)
                                         continue;
                                     NSString* object = [[parts objectAtIndex:0] URLDecode];
                                     NSString* value = [[parts objectAtIndex:1] URLDecode];
                                     if([object isEqual:@"name"]){
                                         notification.title = value;
                                     }
                                     if([object isEqual:@"location"]){
                                         notification.subtitle = value;
                                     }
                                     if([object isEqual:@"desc"]){
                                         notification.informativeText = value;
                                     }
                                     if([object isEqual:@"url"]){
                                         [dict setObject:value forKey:@"url"];
                                     }
                                     if([object isEqualToString:@"iconurl"]){
                                        [notification setValue:[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:value]] forKey:@"_identityImage"];
                                     }
                                     
                                 }
                                 notification.userInfo = dict;
                                 notification.soundName = NSUserNotificationDefaultSoundName;
                                 
                                 [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
                                 
                                 return [GCDWebServerResponse response];
                             }];
    
    // Use convenience method that runs server on port 8080
    // until SIGINT (Ctrl-C in Terminal) or SIGTERM is received
    [webServer startWithPort:11038 bonjourName:nil];
    NSLog(@"Visit %@ in your web browser", webServer.serverURL);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification{
    NSURL *url = [NSURL URLWithString:[notification.userInfo objectForKey:@"url"]];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void) awakeFromNib {

    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.image = [NSImage imageNamed:@"ToolbarIcon"];
    
    self.statusBar.menu = self.menulet;
    self.statusBar.highlightMode = YES;
}

@end
