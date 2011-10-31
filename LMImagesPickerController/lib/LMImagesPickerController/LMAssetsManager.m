//
//  LMAssetsManager.m
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

#import "LMAssetsManager.h"

@implementation LMAssetsManager

- (id)initWithAssetsGroup:(ALAssetsGroup *)group
{
    self = [self init];
    if (self) {
        assets_ = [[NSMutableArray alloc]init];
        selectedIndexList_ = [[NSMutableDictionary alloc]init];
        rows_ = [[NSMutableArray alloc]init];
        __block typeof(self) this = self;
        __block int row = 0;
        __block int indexAtRow = 0;
        __block typeof(rows_)bRows = rows_;
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result) {
                
                NSMutableArray *rowArray = nil;
                LMAsset *asset = [[LMAsset alloc]init];
                asset.index = index;
                asset.selected = NO;
                asset.asset = result;
                
                if ([bRows count] > row) {
                    rowArray = [rows_ objectAtIndex:row];
                    [bRows removeObjectAtIndex:row];
                    [rowArray addObject:asset];
                    [bRows insertObject:rowArray atIndex:row];
                } else {
                    rowArray = [[[NSMutableArray alloc]init]autorelease];
                    [rowArray addObject:asset];
                    [bRows addObject:rowArray];
                }
                
                [this addAsset:asset];
                [asset release];
            }
            indexAtRow++;
            if (indexAtRow == 4) {
                indexAtRow = 0;
                row++;
            }
        }];
    }
    return self;
}

- (NSArray *)getAssetsFromRow:(int)row
{
    return [rows_ objectAtIndex:row];
}

- (void)dealloc
{
    [assets_ release];
    [rows_ release];
    [selectedIndexList_ release];
    [super dealloc];
}

- (void)addAsset:(LMAsset *)asset
{
    [assets_ addObject:asset];
}

- (ALAsset *)assetAtIndex:(NSInteger)index
{
    return [assets_ objectAtIndex:index];
}

- (NSArray *)getSelectedAssets
{
    NSMutableArray *selected = [[[NSMutableArray alloc]init]autorelease];
    for (LMAsset *asset in assets_) {
        if (asset.selected) {
            [selected addObject:asset.asset];
        }
    }
    return selected;
}

- (int)numberOfSelected
{
    int count = 0;
    for (LMAsset *asset in assets_) {
        if (asset.selected) {
            count++;
        }
    }
    return count;
}

- (void)clearALLSelected
{
    
}

@end