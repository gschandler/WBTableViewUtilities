//
//  WBTableViewCellHandler.m
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

#import "WBTableViewCellHandler.h"

NSString *WBTableViewCellHandlerDidChangeNotification = @"WBTableViewCellHandlerDidChangeNotification";


@interface WBTableViewCellHandler()
@property (nonatomic,retain,readonly) NSMutableDictionary *targetActions;

- (void)performTargetActionsForTableViewCellEvent:(WBTableViewCellEvents)event;

@end

@implementation WBTableViewCellHandler
@synthesize contentInsets=_contentInsets;
@synthesize delegate=_delegate;
@synthesize tag=_tag;
@synthesize tableViewCellTitle=_title;
@synthesize tableViewCellImage=_image;
@synthesize tableViewCellDetails=_details;

#define HORIZONTAL_INSET	(10.0)
#define VERTICAL_INSET		(5.0)

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (id)init
{
	self = [super init];
	if ( self ) {
		self.contentInsets = UIEdgeInsetsZero;
	}
	return self;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
-(void)dealloc
{
#if !__has_feature(objc_arc)
	[_title release];
	[_image release];
	[_details release];
	[super dealloc];
#endif
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (NSString *)tableViewCellReuseIdentifier
{
	return nil;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (Class)tableViewCellClass
{
	return [UITableViewCell class];
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (UITableViewCellStyle)tableViewCellStyle
{
	return UITableViewCellStyleDefault;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (UITableViewCellAccessoryType)tableViewCellAccessortType
{
	return UITableViewCellAccessoryNone;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (UITableViewCellAccessoryType)tableViewCellEditingAccessoryType
{
	return UITableViewCellAccessoryNone;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSParameterAssert(cell);
	NSParameterAssert(indexPath);
	NSParameterAssert(tableView);
	
	
	[cell layoutIfNeeded];
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (void)updateCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSParameterAssert(cell);
	NSParameterAssert(indexPath);
	NSParameterAssert(tableView);
	
	cell.textLabel.text = self.tableViewCellTitle;
	if ( cell.detailTextLabel ) {
		cell.detailTextLabel.text = self.tableViewCellDetails;
	}
	cell.imageView.image = self.tableViewCellImage;

	// subclassers do their magic
	[cell setNeedsDisplay];
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSParameterAssert(indexPath);
	NSParameterAssert(tableView);

	UITableViewCell * cell = nil;
	
	NSString *reuseIdentifier = [self tableViewCellReuseIdentifier];
	if ( reuseIdentifier ) {
		cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	}
	
	if (cell == nil) {
		cell = [self createCellForRowAtIndexPath:indexPath inTableView:tableView];
		[self configureCell:cell forRowAtIndexPath:indexPath inTableView:tableView];
	}
	
	[self updateCell:cell forRowAtIndexPath:indexPath inTableView:tableView];
	
	return cell;
}

#pragma mark Optional
//
//	Method:
//		
//
//	Synopsis:
//		
//
- (UITableViewCell *)createCellForRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSParameterAssert(indexPath);
	NSParameterAssert(tableView);
	
	NSString *reuseIdentifier = [self tableViewCellReuseIdentifier];	
	Class TableViewCellClass = [self tableViewCellClass];
	UITableViewCellStyle style = [self tableViewCellStyle];
	UITableViewCell *cell = [[TableViewCellClass alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
#if !__has_feature(objc_arc)
	[cell autorelease];
#endif
	return cell;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (CGRect)contentBoundsFromCell:(UITableViewCell *)cell
{
	CGRect contentBounds = UIEdgeInsetsInsetRect(cell.contentView.bounds, self.contentInsets);
	return contentBounds;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (NSIndexPath *)willSelectRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	[self performTargetActionsForTableViewCellEvent:WBTableViewCellEventWillSelect];
	return indexPath;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	[self performTargetActionsForTableViewCellEvent:WBTableViewCellEventDidSelect];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ( cell ) {
		[self updateCell:cell forRowAtIndexPath:indexPath inTableView:tableView];
	}
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (NSIndexPath *)willDeselectRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	[self performTargetActionsForTableViewCellEvent:WBTableViewCellEventWillDeselect];
	return indexPath;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (void)didDeselectRowAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	[self performTargetActionsForTableViewCellEvent:WBTableViewCellEventDidDeselect];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[self updateCell:cell forRowAtIndexPath:indexPath inTableView:tableView];
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (void)accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	[self performTargetActionsForTableViewCellEvent:WBTableViewCellEventAccessory];
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (NSMutableDictionary *)targetActions
{
	if ( _targetActions == nil ) {
		_targetActions = [NSMutableDictionary new];
	}
	return _targetActions;
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (void)addTarget:(id)target action:(SEL)action forTableViewCellEvent:(WBTableViewCellEvents)event
{
	id key = [NSNumber numberWithUnsignedInteger:event];
	NSArray *invocations = [self.targetActions objectForKey:key];
	if ( !invocations ) {
		invocations = [NSArray array];
	}
	
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:action]];
	[invocation setSelector:action];
	[invocation setTarget:target];
	
	if ( [invocations containsObject:invocation] == NO ) {
		invocations = [invocations arrayByAddingObject:invocation];
	}
	[self.targetActions setObject:invocations forKey:key];
	
}

//
//	Method:
//		
//
//	Synopsis:
//		
//
- (void)removeTarget:(id)target action:(SEL)action forTableViewCellEvent:(WBTableViewCellEvents)event
{
	id key = [NSNumber numberWithUnsignedInteger:event];
	NSArray *invocations = [self.targetActions objectForKey:key];
	if ( invocations ) {
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:action]];
		[invocation setSelector:action];
		[invocation setTarget:target];
		if ( [invocations containsObject:invocation] ) {
			NSMutableArray *newInvocations = [[NSMutableArray alloc] initWithArray:invocations];
			[newInvocations removeObject:invocation];
			[self.targetActions setObject:[NSArray arrayWithArray:newInvocations]  forKey:key];
#if !__has_feature(objc_arc)
			[newInvocations release];
#endif
		}
	}
	
}

//
//	Method:
//		
//
//	Synopsis:
//
//
- (void)performTargetActionsForTableViewCellEvent:(WBTableViewCellEvents)event
{
	id key = [NSNumber numberWithUnsignedInteger:event];
	NSArray *invocations = [self.targetActions objectForKey:key];
	[invocations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSMethodSignature *methodSignature = [obj methodSignature];
		NSInvocation *callingInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
		[callingInvocation setSelector:[obj selector]];
		NSUInteger argumentCount = methodSignature.numberOfArguments;
		
		if ( argumentCount > 2 ) {
			id object = self;
			[callingInvocation setArgument:&object atIndex:2];
		}
		
		[callingInvocation retainArguments];
		[callingInvocation invokeWithTarget:[obj target]];
	}];
}

//
//	Method:
//
//
//	Synopsis:
//
//
- (void)presentViewController:(UIViewController *)viewControllerToPresent
{
	if ( viewControllerToPresent && self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellHandler:presentViewController:)]) {
		[self.delegate tableViewCellHandler:self presentViewController:viewControllerToPresent];
	}
}

//
//	Method:
//
//
//	Synopsis:
//
//
- (void)dismissViewController:(UIViewController *)viewControllerToDismiss
{
	if ( viewControllerToDismiss && self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellHandler:dismissViewController:)]) {
		[self.delegate tableViewCellHandler:self dismissViewController:viewControllerToDismiss];
	}
}

@end
