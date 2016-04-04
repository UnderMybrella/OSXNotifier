//
//  AppDelegate.h
//  MacOSXNotifier
//
//  Created by Isaac H. on 3/04/2016.
//  Copyright © 2016 Isaac H. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSString+URLDecode.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

@property (strong) IBOutlet NSMenu *menulet;
@property (strong, nonatomic) NSStatusItem *statusBar;

@end

