//
//  WBTableViewController.m
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

#import "WBTableViewController.h"
#import "WBTableViewCellHandler.h"
#import "WBTableConfiguration.h"
#import "WBTableViewCellHandler.h"
#import "WBTableConfiguration.h"

@interface WBTableViewController()
//- (void)validateTableConfiguration;
@end

@implementation WBTableViewController

@synthesize tableView=_tableView;
@synthesize tableDefinition=_tableDefinition;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
#if !__has_feature(objc_arc)
	[_tableView release];
	[_tableDefinition release];
	
    [super dealloc];
#endif
}

//
//
//
/*
- (void)loadView
{
	[super loadView];

	if ( self.tableView == nil ) {
		CGRect frame = [[UIScreen mainScreen] applicationFrame];
		self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
		
		frame = CGRectOffset(frame, -CGRectGetMinX(frame), -CGRectGetMinY(frame));
		self.tableView = [[[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped] autorelease];
		
		[self.view addSubview:self.tableView];
		
		self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
	}
}
*/

//
//
//
-(void)viewDidLoad
{
	[super viewDidLoad];
	if ( self.view != self.tableView ) {
		self.view.autoresizingMask |= UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	}
}
//
//	viewWillAppear:
//
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self configureTableDefinition];
	[self.tableView reloadData];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

//
//	viewDidAppear:
//
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tableView flashScrollIndicators];
}


- (void)reloadTable
{
	[self configureTableDefinition];
	[self.tableView reloadData];
}

#pragma mark UITableViewDelegate Methods
//
//	Display
//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	id<WBTableViewCellHandler> controller = [self.tableDefinition tableViewCellHandlerForRowAtIndexPath:indexPath];
	if ( [controller respondsToSelector:@selector(willDisplayCell:forRowAtIndexPath:inTableView:) ] ) {
		[controller willDisplayCell:cell forRowAtIndexPath:indexPath inTableView:tableView];
	}
}

//
//	Selection
//
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<WBTableViewCellHandler> controller = [self.tableDefinition tableViewCellHandlerForRowAtIndexPath:indexPath];
	
	if ( [controller respondsToSelector:@selector(willSelectRowAtIndexPath:inTableView:) ] ) {
		indexPath = [controller willSelectRowAtIndexPath:indexPath inTableView:tableView];
	}
	
	return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	id<WBTableViewCellHandler> controller = [self.tableDefinition tableViewCellHandlerForRowAtIndexPath:indexPath];
	if ( [controller respondsToSelector:@selector(didSelectRowAtIndexPath:inTableView:) ] ) {
		[controller didSelectRowAtIndexPath:indexPath inTableView:tableView];
	}
}
#pragma mark UITableViewDataSource Required Methods

//
//	Rows
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	WBTableSection *tableSection = [self.tableDefinition sectionAtIndex:section];
	NSInteger rows = [tableSection rowCount];
	return rows;
}

//
//	Cells
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = nil;
	
	id<WBTableViewCellHandler> controller = [self.tableDefinition tableViewCellHandlerForRowAtIndexPath:indexPath];
	if ( controller ) {
		cell = [controller cellForRowAtIndexPath:indexPath inTableView:tableView];
	}
	
	return cell;
}

#pragma mark UITableViewDataSource optional methods

//
//	Sections
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger sections = [self.tableDefinition numberOfSections];
	if ( sections == 0 ) sections = 1;	// always have to have at least 1!
	return sections;
}

//
//	Header & Footer
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	WBTableSection *tableSection = [self.tableDefinition sectionAtIndex:section];
	WBSectionHeaderFooter *header = tableSection.header;
	NSString *title = header.title;
	return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	WBTableSection *tableSection = [self.tableDefinition sectionAtIndex:section];
	NSString *title = tableSection.footer.title;
	return title;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	WBTableSection *tableSection = [self.tableDefinition sectionAtIndex:section];
	UIView *view = tableSection.header.view;
	return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	WBTableSection *tableSection = [self.tableDefinition sectionAtIndex:section];
	UIView *view = tableSection.footer.view;
	return view;
}

#pragma mark UIViewController Methods
//
//	Editing
//
//	Do we need to turn on the table's editting? Not sure.
//
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:animated];
}

@end
