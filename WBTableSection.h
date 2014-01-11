//
//  WBTableSection.h
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

#import <Foundation/Foundation.h>

@class WBSectionHeaderFooter;
@protocol WBTableViewCellHandler;

@interface WBTableSection : NSObject
{
	NSInteger					_tag;
	WBSectionHeaderFooter *		_header;
	WBSectionHeaderFooter *		_footer;
	NSArray *					_handlers;
	NSInteger					_rowCount;
}
@property(strong,readonly) WBSectionHeaderFooter *header;
@property(strong,readonly) WBSectionHeaderFooter *footer;
@property(nonatomic,assign) NSInteger rowCount;
@property(assign) NSInteger tag;
@property (strong,readonly) NSArray *tableViewCellHandlers;

- (id)initWithTableViewCellHandlers:(NSArray *)handlers;

- (void)addTableViewCellHandler:(id<WBTableViewCellHandler>)handler;
- (void)removeTableViewCellHandler:(id<WBTableViewCellHandler>)handler;

// provides index bounds checking
- (id<WBTableViewCellHandler>)tableViewCellHandlerAtIndex:(NSInteger)index;

#if NS_BLOCKS_AVAILABLE
- (void)enumerateTableViewCellHandlers:(void (^)(id<WBTableViewCellHandler> handler, NSInteger idx, BOOL *stop))block;
#endif
@end

