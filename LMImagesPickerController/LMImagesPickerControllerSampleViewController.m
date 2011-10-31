//
//  LMImagesPickerControllerSampleViewController.m
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

#import "LMImagesPickerControllerSampleViewController.h"
#import "LMImagesPickerController.h"

@implementation LMImagesPickerControllerSampleViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = @"LMIPC Sample";
    }
    return self;
}

- (void)dealloc
{
    [headerView_ release];
    [super dealloc];
}

#pragma mark - sample code hear!!
- (void)selectImages
{
    LMImagesPickerController *picker = [[LMImagesPickerController alloc]init];
    picker.delegate = self;
    picker.maxNumber = 0;
    
    [self.navigationController presentModalViewController:picker animated:YES];
    
    [picker release];
}

#pragma mark - LMImagesPickerControllerDelegate
- (void)lmImagesPickerController:(LMImagesPickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)assets
{
    [selectedItems_ release];
    selectedItems_ = nil;
    selectedItems_ = [assets retain];
    [self dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)lmImagesPickerControllerDidCancel:(LMImagesPickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerView_ = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headerView_.frame = CGRectMake(0, 0, 320, 44);
    [headerView_ setTitle:@"Select Images" forState:UIControlStateNormal];
    [headerView_ addTarget:self action:@selector(selectImages) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = headerView_;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [headerView_ release];
    headerView_ = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [selectedItems_ count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    ALAsset *asset = [selectedItems_ objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
    [cell.imageView setImage:image];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    cell.textLabel.text = [formatter stringFromDate:(NSDate *)[asset valueForProperty:ALAssetPropertyDate]];
    
    return cell;
}

@end