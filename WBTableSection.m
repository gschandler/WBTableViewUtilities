//
//  WBTableSection.m
//  WBTableViewUtilities
//
//  Created by Scott Chandler on 1/9/14.
//  Copyright (c) 2014 Scott Chandler. All rights reserved.
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

#import "WBTableSection.h"
#import "WBSectionHeaderFooter.h"
#import "WBTableViewCellHandler.h"


@interface WBTableSection()
@property(strong) NSArray *tableViewCellHandlers;
@end

@implementation WBTableSection
@synthesize header=_header;
@synthesize footer=_footer;
@synthesize tableViewCellHandlers=_handlers;
@synthesize rowCount=_rowCount;
@synthesize tag=_tag;

/*
 *
 *
 *
 */
-(id)init
{
	return [self initWithTableViewCellHandlers:@[]];
}

/*
 *
 *
 *
 */
- (id)initWithTableViewCellHandlers:(NSArray *)handlers
{
	if ( self = [super init], self != nil ) {
		_tag = 0;
		_handlers = handlers;
#if !__has_feature(objc_arc)
		[handlers retain];
#endif
		_rowCount = 0;
		_header = [WBSectionHeaderFooter new];
		_footer = [WBSectionHeaderFooter new];
	}
	return self;
	
}

/*
 *
 *
 *
 */
- (void)dealloc
{
#if !__has_feature(objc_arc)
	[_handlers release];
	[_header release];
	[_footer release];
	[super dealloc];
#endif
}

/*
 *
 *
 *
 */
- (NSInteger)rowCount
{
	return (_rowCount>0) ? _rowCount : self.tableViewCellHandlers.count;
}

/*
 *
 *
 *
 */
- (void)addTableViewCellHandler:(id<WBTableViewCellHandler>)handler
{
	NSParameterAssert(handler);
	
	if ( [self.tableViewCellHandlers containsObject:handler] == NO ) {
		self.tableViewCellHandlers = [self.tableViewCellHandlers arrayByAddingObject:handler];
	}
}

/*
 *
 *
 *
 */
- (void)removeTableViewCellHandler:(id<WBTableViewCellHandler>)handler
{
	NSInteger index = [self.tableViewCellHandlers indexOfObject:handler];
	if ( index != NSNotFound ) {
		NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.tableViewCellHandlers];
		[temp removeObjectAtIndex:index];
		self.tableViewCellHandlers = [NSArray arrayWithArray:temp];
#if !__has_feature(objc_arc)
		[temp release];
#endif
	}
}

/*
 *
 *
 *
 */
- (id<WBTableViewCellHandler>)tableViewCellHandlerAtIndex:(NSInteger)index
{
	id<WBTableViewCellHandler> controller = nil;
	if ( [self.tableViewCellHandlers count] > index ) {
		controller = [self.tableViewCellHandlers objectAtIndex:index];
	}
	else if ([self.tableViewCellHandlers count] > 0 ) {
		controller = [self.tableViewCellHandlers lastObject];
	}
	return controller;
}

/*
 *
 *
 *
 */
#if NS_BLOCKS_AVAILABLE
- (void)enumerateTableViewCellHandlers:(void (^)(id<WBTableViewCellHandler>, NSInteger, BOOL *))block
{
	if ( !block ) return;
	
    [self.tableViewCellHandlers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id<WBTableViewCellHandler> controller = (id<WBTableViewCellHandler>)obj;
        block(controller,idx,stop);
    }];
}
#endif
@end
