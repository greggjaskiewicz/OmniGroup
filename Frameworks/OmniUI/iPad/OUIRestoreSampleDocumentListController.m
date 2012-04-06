// Copyright 2010-2011 The Omni Group. All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.

#import "OUIRestoreSampleDocumentListController.h"

#import <OmniFileStore/OFSDocumentStore.h>
#import <OmniUI/OUISingleDocumentAppController.h>
#import <OmniUI/OUIDocumentPicker.h>
#import <OmniUI/OUIBarButtonItem.h>

#import <OmniFileStore/OFSFileManager.h>
#import <OmniFileStore/OFSFileInfo.h>

RCS_ID("$Id$");

@implementation OUIRestoreSampleDocumentListController

- (void)cancel:(id)sender;
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (NSString *)localizedNameForFileName:(NSString *)fileName;
{
    return [[OUISingleDocumentAppController controller] localizedNameForSampleDocumentNamed:fileName];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.navigationItem.title = [[OUISingleDocumentAppController controller] sampleDocumentsDirectoryTitle];
    
    UIBarButtonItem *cancel = [[OUIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;
    [cancel release];
    
    // Load sample documents.
    NSURL *sampleDocumentsURL = [[OUISingleDocumentAppController controller] sampleDocumentsDirectoryURL];
    
    NSError *error = nil;
    OFSFileManager *fileManager = [[[OFSFileManager alloc] initWithBaseURL:sampleDocumentsURL error:&error] autorelease];
    if (error) {
        OUI_PRESENT_ERROR(error);
        return;
    }
    
    NSArray *sampleFiles = [fileManager directoryContentsAtURL:sampleDocumentsURL havingExtension:nil error:&error];
    if (error) {
        OUI_PRESENT_ERROR(error);
        return;
    }
    
    sampleFiles = [sampleFiles sortedArrayUsingComparator:^(OFSFileInfo *fileInfo1, OFSFileInfo *fileInfo2) {
        NSString *fileInfo1LocalizedName = [self localizedNameForFileName:[[fileInfo1 name] stringByDeletingPathExtension]];
        if (!fileInfo1LocalizedName)
            fileInfo1LocalizedName = [[fileInfo1 name] stringByDeletingPathExtension];
        
        NSString *fileInfo2LocalizedName = [self localizedNameForFileName:[[fileInfo2 name] stringByDeletingPathExtension]];
        if (!fileInfo2LocalizedName)
            fileInfo2LocalizedName = [[fileInfo2 name] stringByDeletingPathExtension];
        
        return [fileInfo1LocalizedName compare:fileInfo2LocalizedName];
    }];
    
    self.files = sampleFiles;
}

#pragma mark -
#pragma mark UITableViewDeletage
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Get fileInfo
    OFSFileInfo *fileInfo = [self.files objectAtIndex:indexPath.row];
    
    [[[OUISingleDocumentAppController controller] documentPicker] addSampleDocumentFromURL:[fileInfo originalURL]];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
