//
//  WOAFileSelectorView.m
//  WOAMobile
//
//  Created by steven.zhuang on 9/18/14.
//  Copyright (c) 2014 steven.zhuang. All rights reserved.
//

#import "WOAFileSelectorView.h"
#import "WOAInputTitleViewController.h"
#import "WOALabelButtonTableViewCell.h"
#import "WOALayout.h"
#import "UIColor+AppTheme.h"
#import "NSFileManager+AppFolder.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface WOAFileSelectorView () <UITableViewDataSource, UITableViewDelegate,
                                    UINavigationControllerDelegate, UIImagePickerControllerDelegate,
                                    WOAInputTitleViewControllerDelegate,
                                    WOALabelButtonTableViewCellDelegate>

@property (nonatomic, copy) WOASelectFileCompletion completionBlock;

@property (nonatomic, assign) NSUInteger displayLineCount;
@property (nonatomic, assign) NSUInteger limitMaxCount;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UITableView *fileList;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation WOAFileSelectorView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.ignoreTitle = NO;
    }
    return self;
}

- (instancetype) initWithFrame: (CGRect)frame
                      delegate: (id<WOAFileSelectorViewDelegate>)delegate
                 limitMaxCount: (NSUInteger)limitMaxCount
              displayLineCount: (NSUInteger)displayLineCount
{
    if (self = [self initWithFrame: frame])
    {
        self.delegate = delegate;
        self.limitMaxCount = limitMaxCount;
        self.displayLineCount = displayLineCount;
        
        UIFont *itemFont = [UIFont systemFontOfSize: kWOALayout_DetailItemFontSize];
        CGSize testSize = [WOALayout sizeForText: @"T" width: 20 font: itemFont];
        self.itemHeight = ceilf(testSize.height);
        self.cellHeight = _itemHeight + 4;
        
        NSString *addButtonTitle = @"添加附件";
        NSDictionary *attribute = @{NSFontAttributeName: itemFont,
                                    NSForegroundColorAttributeName: [UIColor orangeColor]};
        NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString: addButtonTitle attributes: attribute];
        
        self.addButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_addButton setAttributedTitle: titleAttributedString forState: UIControlStateNormal];
        [_addButton setAttributedTitle: titleAttributedString forState: UIControlStateHighlighted];
        [_addButton addTarget: self action: @selector(onAddButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview: _addButton];
        
        self.fileList = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        _fileList.dataSource = self;
        _fileList.delegate = self;
        _fileList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //[_fileList setEditing: YES];
        [self addSubview: _fileList];
        
        NSUInteger cellCount;
        if (self.limitMaxCount > 0)
        {
            cellCount = MIN(self.displayLineCount, self.limitMaxCount);
        }
        else
        {
            cellCount = self.displayLineCount;
        }
        CGFloat addButtonHeight = _itemHeight;
        CGFloat seperatorHeight = 1;
        CGFloat fileListHeight = _cellHeight  * (cellCount + 0.5); //half list for prompt that there're more items.
        
        CGRect buttonRect = CGRectMake(0, 0, 80, addButtonHeight);
        CGRect fileListRect = CGRectMake(0, addButtonHeight + seperatorHeight, frame.size.width, fileListHeight);
        CGRect selfRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, addButtonHeight + seperatorHeight + fileListHeight);
        
        [_addButton setFrame: buttonRect];
        [_fileList setFrame: fileListRect];
        [self setFrame: selfRect];
    }
    
    return self;
}

- (void) fileInfoUpdated
{
    [_fileList reloadData];
    
    [_fileList flashScrollIndicators];
}

- (void) selectFileWithCompletion: (void(^)(NSString *filePath, NSString* title))completionBlock
{
    self.completionBlock = completionBlock;
    
    [self presentImagePickVC];
}

#pragma mark -
- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section;
{
    return (section == 0) ? [[self.delegate fileInfoArray] count] : 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *itemTitle = [[self.delegate fileInfoArray] objectAtIndex: indexPath.row];
    WOALabelButtonTableViewCell *cell = [[WOALabelButtonTableViewCell alloc] initWithDelegate: self
                                                                                      section: indexPath.section
                                                                                          row: indexPath.row
                                                                                theLabelTitle: itemTitle
                                                                               theButtonTitle: @"删除"];
    
    return cell;
}

#pragma mark - table view delegate

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath
{
    return _cellHeight;
}

//- (UITableViewCellEditingStyle) tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void) tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        NSInteger row = indexPath.row;
//        
//        if (self.delegate && [self.delegate respondsToSelector: @selector(fileSelectorView:addFilePath:withTitle:)])
//        {
//            [self.delegate fileSelectorView: self
//                                deleteAtRow: row];
//            
//            [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath]
//                             withRowAnimation: UITableViewRowAnimationAutomatic];
//        }
//    }
//}

- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}

- (void) onAddButtonClick: (id)sender
{
    NSInteger existItemCount = [[self.delegate fileInfoArray] count];
    if (self.limitMaxCount > 0 && existItemCount >= self.limitMaxCount)
    {
        UINavigationController *hostNavC = self.navC ? self.navC : [self.delegate hostNavigation];
        UIViewController *rootVC = [hostNavC parentViewController];
        NSString *alertMessage = [NSString stringWithFormat: @"最多只能 %ld 个附件.", (unsigned long)self.limitMaxCount];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @""
                                                                                 message: alertMessage
                                                                          preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle: @"确定"
                                                                style: UIAlertActionStyleDefault
                                                              handler: nil];
        [alertController addAction: confirmAction];
        
        [rootVC presentViewController: alertController animated: YES completion: nil];
        
        return;
    }
    
    [self presentImagePickVC];
}

- (void) presentImagePickVC
{
    UIImagePickerControllerSourceType sourceType;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    else
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.allowsEditing = NO;
    imagePickerVC.sourceType = sourceType;
    //imagePickerVC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: sourceType];
    imagePickerVC.mediaTypes = @[@"public.image"];
    imagePickerVC.delegate = self;
    
    UINavigationController *hostNavC = self.navC ? self.navC : [self.delegate hostNavigation];
    [hostNavC presentViewController: imagePickerVC animated: YES completion: nil];
}

- (void) onSelectFinish: (NSString*)filePath title: (NSString*)title
{
    UINavigationController *hostNavC = self.navC ? self.navC : [self.delegate hostNavigation];
    [hostNavC popViewControllerAnimated: YES];
    
    if (self.completionBlock)
    {
        self.completionBlock(filePath, title);
        
        self.completionBlock = nil;
    }
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(fileSelectorView:addFilePath:withTitle:)])
    {
        [self.delegate fileSelectorView: self
                            addFilePath: filePath
                              withTitle: title];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController: (UIImagePickerController *)picker
 didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    NSURL *imageURL = [info valueForKey: UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *targetAsset)
    {
        ALAssetRepresentation *defaultRepresentation = [targetAsset defaultRepresentation];
        NSString *imageFileName = [defaultRepresentation filename];
        long long imageFileSize = [defaultRepresentation size];
        
        NSString *tempPath = [NSFileManager currentAccountTempPath];
        NSString *imageFullFileName = [NSString stringWithFormat: @"%@/%@", tempPath, imageFileName];
        
        [NSFileManager createDirectoryIfNotExists: tempPath];
        
        Byte *buffer = (Byte*)malloc((unsigned long) imageFileSize);
        NSUInteger length = [defaultRepresentation getBytes: buffer fromOffset: 0.0 length: (NSUInteger)imageFileSize error: nil];
        NSData *data = [[NSData alloc] initWithBytesNoCopy: buffer length: length freeWhenDone: YES];
        if (![data writeToFile: imageFullFileName atomically: YES])
        {
            NSLog(@"Dump image failed.");
        }
        
        [picker dismissViewControllerAnimated: YES completion: ^()
        {
            if (self.ignoreTitle)
            {
                [self onSelectFinish: imageFullFileName title: nil];
            }
            else
            {
                WOAInputTitleViewController *attachmentTitleVC = [[WOAInputTitleViewController alloc] initWithFilePath: imageFullFileName delegate: self];
                UINavigationController *hostNavC = self.navC ? self.navC : [self.delegate hostNavigation];
                [hostNavC pushViewController: attachmentTitleVC animated: NO];
            }
        }];
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        NSLog(@"image picker error: %@", error);
        
        self.completionBlock = nil;
        
        [picker dismissViewControllerAnimated: YES completion: nil];
    };
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL: imageURL
                   resultBlock: resultBlock
                  failureBlock: failureBlock];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated: YES completion: nil];
    
    self.completionBlock = nil;
}

- (void) inputTitleViewController: (WOAInputTitleViewController*)inputTitleViewController commitedWithTitle: (NSString*)title filePath: (NSString*)filePath
{
    [self onSelectFinish: filePath
                   title: title];
}

- (void) inputTitleViewControllerCancelled: (WOAInputTitleViewController*)inputTitleViewController
{
    UINavigationController *hostNavC = self.navC ? self.navC : [self.delegate hostNavigation];
    [hostNavC popViewControllerAnimated: YES];
}

- (void) labelButtuonTableViewCell: (WOALabelButtonTableViewCell *)cell buttonClick:(NSInteger)tag
{
    NSInteger row = cell.row;
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(fileSelectorView:deleteAtRow:)])
    {
        [self.delegate fileSelectorView: self
                            deleteAtRow: row];
    }
}

@end
