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

- (NSString *)buildThumbnailImage:(CGPDFDocumentRef)pdfDocument pageNum:(int *)pageNum
{

    BOOL hasRetinaDisplay = FALSE;  // by default
    CGFloat pixelsPerPoint = 1.0;  // by default (pixelsPerPoint is just the "scale" property of the screen)

    if ([UIScreen instancesRespondToSelector:@selector(scale)])  // the "scale" property is only present in iOS 4.0 and later
    {
        // we are running iOS 4.0 or later, so we may be on a Retina display;  we need to check further...
        if ((pixelsPerPoint = [[UIScreen mainScreen] scale]) == 1.0)
            hasRetinaDisplay = FALSE;
        else
            hasRetinaDisplay = TRUE;
    }
    else
    {
        // we are NOT running iOS 4.0 or later, so we can be sure that we are NOT on a Retina display
        pixelsPerPoint = 1.0;
        hasRetinaDisplay = FALSE;
    }

    size_t imageWidth = 1152;  // width of thumbnail in points
    size_t imageHeight = 1536;  // height of thumbnail in points

    if (hasRetinaDisplay)
    {
        imageWidth *= pixelsPerPoint;
        imageHeight *= pixelsPerPoint;
    }

    size_t bytesPerPixel = 4;  // RGBA
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = bytesPerPixel * imageWidth;

    void *bitmapData = malloc(imageWidth * imageHeight * bytesPerPixel);

    // in the event that we were unable to mallocate the heap memory for the bitmap,
    // we just abort and preemptively return nil:
    if (bitmapData == NULL)
        return nil;

    // remember to zero the buffer before handing it off to the bitmap context:
    bzero(bitmapData, imageWidth * imageHeight * bytesPerPixel);

    CGContextRef theContext = CGBitmapContextCreate(bitmapData, imageWidth, imageHeight, bitsPerComponent, bytesPerRow,
                                                    CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);

    //CGPDFDocumentRef pdfDocument = MyGetPDFDocumentRef();  // NOTE: you will need to modify this line to supply the CGPDFDocumentRef for your file here...
    // NSLog(@"Pdf2page # <%@>", pageNum);    
    CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDocument, pageNum);  // get the first page for your thumbnail

    CGAffineTransform shrinkingTransform =
    CGPDFPageGetDrawingTransform(pdfPage, kCGPDFMediaBox, CGRectMake(0, 0, imageWidth, imageHeight), 0, YES);

    CGContextConcatCTM(theContext, shrinkingTransform);

    CGContextDrawPDFPage(theContext, pdfPage);  // draw the pdfPage into the bitmap context
    CGPDFDocumentRelease(pdfDocument);

    //
    // create the CGImageRef (and thence the UIImage) from the context (with its bitmap of the pdf page):
    //
    CGImageRef theCGImageRef = CGBitmapContextCreateImage(theContext);
    free(CGBitmapContextGetData(theContext));  // this frees the bitmapData we malloc'ed earlier
    CGContextRelease(theContext);

    UIImage *theUIImage;

    // CAUTION: the method imageWithCGImage:scale:orientation: only exists on iOS 4.0 or later!!!
    if ([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)])
    {
        theUIImage = [UIImage imageWithCGImage:theCGImageRef scale:pixelsPerPoint orientation:UIImageOrientationUp];
    }
    else
    {
        theUIImage = [UIImage imageWithCGImage:theCGImageRef];
    }

    // NSData* imageDataObject = nil;
    // if([format isEqualToString:@"png"]==YES) {
    //     imageDataObject = UIImagePNGRepresentation(theUIImage);
    // } else {
    //     imageDataObject = UIImageJPEGRepresentation(theUIImage, (quality/100));
    // }    

    NSString *encodedString = [UIImagePNGRepresentation(theUIImage) base64Encoding];

    CFRelease(theCGImageRef);
    return encodedString;
}



CGPDFDocumentRef MyGetPDFDocumentRef(NSString *inputPDFFileURL)
{
    NSString *inputPDFFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:inputPDFFileURL];

    // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
    //                                                       NSUserDomainMask, YES);
    // NSString *localDocumentsDirectory = [paths objectAtIndex:0];
    // NSString *pdfFileName = @"example.pdf";
    // NSString *localDocumentsDirectoryPdfFilePath = [localDocumentsDirectory  
    //                                  stringByAppendingPathComponent:pdfFileName];
    // pdfUrl = [NSURL fileURLWithPath:localDocumentsDirectoryPdfFilePath];

    const char *inputPDFFileAsCString = [inputPDFFile cStringUsingEncoding:NSASCIIStringEncoding];
    //NSLog(@"expecting pdf file to exist at this pathname: \"%s\"", inputPDFFileAsCString);

    CFStringRef path = CFStringCreateWithCString(NULL, inputPDFFileAsCString, kCFStringEncodingUTF8);

    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease (path);

    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);

    if (CGPDFDocumentGetNumberOfPages(document) == 0)
    {
        printf("Warning: No pages in pdf file \"%s\" or pdf file does not exist at this path \"%s\" \n", inputPDFFileAsCString, path);
        return NULL;
    }

    return document;
}

- (void)getPage:(CDVInvokedUrlCommand*)command {
    NSLog(@"Pdf2png, command");
    id pdfFile = [command.arguments objectAtIndex:0];
    id pageNumObj = [command.arguments objectAtIndex:1];
    int pageNum = [pageNumObj intValue];
    // NSLog(@"Pdf2png, load file <%@> page # <%@>", pdfFile, pageNum);

    //To be called in the cellForItemAtIndexPath method or a similar method where you want to create a thumbnail for the image:
    // NSString *pdfName = [NSString stringWithFormat:@"%@.pdf", fileNameWithoutExtension];
    NSString *pdfPageBase64png = [self buildThumbnailImage:MyGetPDFDocumentRef(pdfFile) pageNum:pageNum];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pdfPageBase64png];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getPageInBackground:(CDVInvokedUrlCommand*)command {
    NSLog(@"Pdf2png, backgroundJobTest");
    [self.commandDelegate runInBackground:^{
        id pdfFile = [command.arguments objectAtIndex:0];
        id pageNumObj = [command.arguments objectAtIndex:1];
        int pageNum = [pageNumObj intValue];
        // NSLog(@"Pdf2png, load file <%@> page # <%@>", pdfFile, pageNum);

        //To be called in the cellForItemAtIndexPath method or a similar method where you want to create a thumbnail for the image:
        // NSString *pdfName = [NSString stringWithFormat:@"%@.pdf", fileNameWithoutExtension];
        NSString *pdfPageBase64png = [self buildThumbnailImage:MyGetPDFDocumentRef(pdfFile) pageNum:pageNum];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pdfPageBase64png];

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
