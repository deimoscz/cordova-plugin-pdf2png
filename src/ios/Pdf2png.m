/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "Pdf2png.h"
/* #import "CDV.h"
*/
@implementation Pdf2png

- (void)pluginInitialize {
    [super pluginInitialize];
    NSLog(@"Hello World Pdf2png, init");
}

- (void)echoTest:(CDVInvokedUrlCommand*)command {
    NSLog(@"Pdf2png, command");
    id message = [command.arguments objectAtIndex:0];
    NSLog(@"Pdf2png, parameter <%@>", message);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)backgroundJobTest:(CDVInvokedUrlCommand*)command {
    NSLog(@"Pdf2png, backgroundJobTest");
    [self.commandDelegate runInBackground:^{
	NSString* payload = nil;
	
	// Some blocking logic...
	NSLog(@"Pdf2png, sleep for 5s");
	[NSThread sleepForTimeInterval:5.0];
	NSLog(@"Pdf2png, sleep done");
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:payload];
	// The sendPluginResult method is thread-safe.
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    NSLog(@"return from backgroundJobTest");
}

- (void)onAppTerminate {
    NSLog(@"Pdf2png, onAppTerminate");

}

- (void)onMemoryWarning {
    NSLog(@"Pdf2png, onMemoryWarning");

}

- (void)onReset {
    NSLog(@"Pdf2png, onReset");
}

- (void)dispose {
    NSLog(@"Pdf2png, dispose");
}

@end
