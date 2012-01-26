//
//  LMAssetSelectViewController.m
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

#import "LMAssetsSelectViewController.h"
#import "LMAssetsViewCell.h"

@implementation LMAssetsSelectViewController

- (id)initWithAssetGroup:(ALAssetsGroup *)group assetsLibrary:(ALAssetsLibrary *)library picker:(LMImagesPickerController *)picker
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        picker_ = picker;
        assetsLibrary_ = library;
        
        assetsGroup_ = [group retain];
        assetsManager_ = [[LMAssetsManager alloc]initWithAssetsGroup:assetsGroup_];
        
        doneButton_ = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouch)];
        doneButton_.enabled = NO;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(lmAssetChangeEventHandler) name:@"LMAssetChangeEvent" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [assetsGroup_ release];
    [assetsManager_ release];
    [doneButton_ release];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select";
    self.navigationItem.rightBarButtonItem = doneButton_;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[assetsManager_ numberOfRow] inSection:0];  
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil((double)[assetsGroup_ numberOfAssets]/4);
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    LMAssetsViewCell *cell = (LMAssetsViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[LMAssetsViewCell alloc]init]autorelease];
    }
    
    [cell setAssets:[assetsManager_ getAssetsFromRow:indexPath.row]];

    return cell;
}

#pragma mark - Handler
- (void)lmAssetChangeEventHandler
{
    int count = [assetsManager_ numberOfSelected];
    
    if (count > 0) {
        if (picker_.maxNumber != 0) {
            self.navigationItem.title = [NSString stringWithFormat:@"%d/%d", count, picker_.maxNumber];  
            if ( picker_.maxNumber >= count ) {
                doneButton_.enabled = YES;
            } else {
                doneButton_.enabled = NO;
            }
        } else {
            if (count == 1) {
                self.navigationItem.title = [NSString stringWithFormat:@"%d Item", count];  
            }else{
                self.navigationItem.title = [NSString stringWithFormat:@"%d Items", count];
            }
            doneButton_.enabled = YES;
        }
    } else {
        self.navigationItem.title = @"Select Items";
        doneButton_.enabled = NO;
    }
}

- (void)doneTouch
{
    if ([picker_ respondsToSelector:@selector(selectedItems:)]) {
        NSDictionary *info = [NSDictionary dictionaryWithObjects:
                              [NSArray arrayWithObjects:
                                    [assetsManager_ getSelectedAssets]
                                    ,assetsLibrary_
                                    ,nil]
                                                forKeys:
                              [NSArray arrayWithObjects:
                                    LMImagesPickerControllerALAssets
                                    ,LMImagesPickerControllerAssetsLibrary
                               ,nil]];
        
        [picker_ performSelector:@selector(selectedItems:) withObject:info];
    }
}

@end