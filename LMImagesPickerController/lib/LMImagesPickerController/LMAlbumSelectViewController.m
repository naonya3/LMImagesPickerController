//
//  LMAlbumSelectViewController.m
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
#import "LMAlbumSelectViewController.h"
#import "LMAssetsSelectViewController.h"

@implementation LMAlbumSelectViewController

#pragma mark - Private

- (void)loadAlbum
{
    
    __block typeof(self) this = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        void (^usingBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
        {
            if (group == nil) 
            {
                return;
            }
            
            [assetGroups_ addObject:group];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [this.tableView reloadData];
            });
        };
        
        void (^failureBlock)(NSError *) = ^(NSError *error) {
            
        };

        [assetsLibrary_ enumerateGroupsWithTypes:ALAssetsGroupAlbum | ALAssetsGroupSavedPhotos
                                      usingBlock:usingBlock
                                    failureBlock:failureBlock];
        
        [pool release];
    });
}

#pragma mark - Init
- (id)initWithPicker:(LMImagesPickerController *)picker
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        picker_ = picker;
        
        cancelButton_ = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
        
    }
    return self;
}

- (void)dealloc
{
    [cancelButton_ release];
    [assetGroups_ release];
    [assetsLibrary_ release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // navigation setting
    self.navigationItem.title = @"Select Album";
    self.navigationItem.rightBarButtonItem = cancelButton_;
    
    // load Album
    assetsLibrary_ = [[ALAssetsLibrary alloc]init];
    assetGroups_ = [[NSMutableArray alloc]init];
    
    [self loadAlbum];
}    

- (void)viewDidUnload
{
    [super viewDidUnload];
    [assetGroups_ release];
    [assetsLibrary_ release];
    assetsLibrary_ = nil;
    assetGroups_ = nil;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [assetGroups_ count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"default_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ALAssetsGroup *assetsGroup = (ALAssetsGroup*)[assetGroups_ objectAtIndex:indexPath.row];
    [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger assetsGroupCount = [assetsGroup numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[assetsGroup valueForProperty:ALAssetsGroupPropertyName], assetsGroupCount];
    
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups_ objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMAssetsSelectViewController *lmAssetsSelectViewController = [[LMAssetsSelectViewController alloc]initWithAssetGroup:[assetGroups_ objectAtIndex:indexPath.row] picker:picker_];
    
    [self.navigationController pushViewController:lmAssetsSelectViewController animated:YES];
    [lmAssetsSelectViewController release];
}

#pragma mark - handler
- (void)cancelTouch
{
    if ([picker_ respondsToSelector:@selector(cancel)]) {
        [picker_ performSelector:@selector(cancel) withObject:nil];
    }
}

@end