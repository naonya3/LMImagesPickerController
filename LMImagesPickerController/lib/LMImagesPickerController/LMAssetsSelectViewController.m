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

- (id)initWithAssetGroup:(ALAssetsGroup *)group picker:(LMImagesPickerController *)picker
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        picker_ = picker;
        
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
    [self.navigationItem.leftBarButtonItem setTitle:@"back"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        [picker_ performSelector:@selector(selectedItems:) withObject:[assetsManager_ getSelectedAssets]];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}



@end