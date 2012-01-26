//
//  LMAssetView.m
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

#import "LMAssetView.h"

@implementation LMAssetView

#pragma mark - Private
- (void)setupLayer
{
    imageLayer_ = [[UIImageView alloc]initWithFrame:self.bounds];
    imageLayer_.frame = self.bounds;
    [self addSubview:imageLayer_];
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        if (selectedCover_ == nil) {
            selectedCover_ = [[LMAssetViewCellSelectedCover alloc]initWithFrame:self.bounds];
            selectedCover_.backgroundColor = [UIColor clearColor];
        }
        [self addSubview:selectedCover_];
    } else {
        [selectedCover_ removeFromSuperview];
    }
}

#pragma mark -Init
- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 75, 75)];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)dealloc
{
    [asset_ release];
    [selectedCover_ release];
    [super dealloc];
}

- (void)setAsset:(LMAsset *)asset
{
    [asset_ release];
    asset_ = [asset retain];
    [imageLayer_ setImage:[UIImage imageWithCGImage:[asset.asset thumbnail]]];
    [self setSelected:asset_.selected];
}

- (void)clear
{
    [imageLayer_ removeFromSuperview];
    [imageLayer_ release];
    imageLayer_ = nil;
    [self setupLayer];
}

#pragma mark - user interaction Event
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    asset_.selected = !asset_.selected;
    [self setSelected:asset_.selected];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotification *notification = [NSNotification notificationWithName:@"LMAssetChangeEvent" object:self];
    [center postNotification:notification];
}

@end

@implementation LMAssetViewCellSelectedCover

- (void)drawRect:(CGRect)rect
{
    [[UIColor colorWithWhite:1.0f alpha:0.6]setFill];
    UIRectFill(self.bounds);

    UIImage *image = [UIImage imageNamed:@"LMImagesPickerCheckedImage"];
    [image drawAtPoint:CGPointMake(44, 44)];
}

@end