//
//  WBTableViewCellHandler.h
//
//	The MIT License (MIT)
//
//	Copyright (c) 2013 Wooly Beast Software
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@protocol WBTableViewCellHandlerDelegate;

@protocol WBTableViewCellHandler<NSObject>
@required
@property (weak) id<WBTableViewCellHandlerDelegate> delegate;
@property (assign) NSInteger tag;

// configure a cell's content. called once upon creation of the cell.
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

// update a cell's content. can be called many times during lifetime of object.
- (void)updateCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

// obtains existing cell if already exists, or calls createCellForRowAtIndexPath:inTableView:
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

@optional

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

- (void)willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

- (NSIndexPath *)willSelectRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

- (NSIndexPath *)willDeselectRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (void)didDeselectRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

- (void)accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (BOOL)shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (BOOL)canEditRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

@end


@protocol WBTableViewCellHandlerDelegate<NSObject>
@optional
- (void)tableViewCellHandler:(id<WBTableViewCellHandler>)controller presentViewController:(UIViewController *)viewController;
- (void)tableViewCellHandler:(id<WBTableViewCellHandler>)controller dismissViewController:(UIViewController *)viewController;
@end

extern NSString *WBTableViewCellHandlerDidChangeNotification;

typedef NS_ENUM(NSUInteger,WBTableViewCellEvents) {
	WBTableViewCellEventWillSelect = 1,
	WBTableViewCellEventDidSelect,
	WBTableViewCellEventWillDeselect,
	WBTableViewCellEventDidDeselect,
	WBTableViewCellEventAccessory
};

@interface WBTableViewCellHandler : UIResponder<WBTableViewCellHandler>
{
	UIEdgeInsets						_contentInsets;
	NSString *							_title;
	UIImage *							_image;
	NSString *							_details;
	NSMutableDictionary *				_targetActions;
	id<WBTableViewCellHandlerDelegate>	__weak _delegate;
	NSInteger							_tag;
}

- (void)addTarget:(id)target action:(SEL)action forTableViewCellEvent:(WBTableViewCellEvents)event;
- (void)removeTarget:(id)target action:(SEL)action forTableViewCellEvent:(WBTableViewCellEvents)event;

@property (nonatomic,assign) UIEdgeInsets contentInsets;
@property (strong) NSString *tableViewCellTitle;
@property (strong) NSString *tableViewCellDetails;
@property (strong) UIImage *tableViewCellImage;
@property (nonatomic,strong,readonly) NSString *tableViewCellReuseIdentifier;
@property (nonatomic,readonly) Class tableViewCellClass;
@property (nonatomic,readonly) UITableViewCellStyle tableViewCellStyle;

- (CGRect)contentBoundsFromCell:(UITableViewCell *)cell;

- (UITableViewCell *)createCellForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

- (void)presentViewController:(UIViewController *)viewControllerToPresent;
- (void)dismissViewController:(UIViewController *)viewControllerToDismiss;
@end

