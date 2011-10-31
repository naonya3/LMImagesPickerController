//
//  LMImagesPickerController.m
//  LMImagesPickerController
//
// Copyright (c) 2011- Naoto Horiguchi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "LMImagesPickerController.h"
#import "LMAlbumSelectViewController.h"

@implementation LMImagesPickerController
@synthesize delegate = delegate_, maxNumber = maxNumber_;

#pragma mark - Private
- (void)selectedItems:(NSArray *)items
{
    if ([delegate_ respondsToSelector:@selector(lmImagesPickerController:didFinishPickingMediaWithAssets:)]) {
        
        [delegate_ lmImagesPickerController:self didFinishPickingMediaWithAssets:items];
    }
}

- (void)cancel
{
    if ([delegate_ respondsToSelector:@selector(lmImagesPickerControllerDidCancel:)]) {
        [delegate_ lmImagesPickerControllerDidCancel:self];
    }
}

#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
        LMAlbumSelectViewController *albumSelectViewController = [[LMAlbumSelectViewController alloc]initWithPicker:self];
        self.viewControllers = [NSArray arrayWithObject:albumSelectViewController];
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [albumSelectViewController release];
        
        self.maxNumber = 0;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}





@end
