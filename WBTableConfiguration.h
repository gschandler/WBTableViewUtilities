//
//  WBTableConfiguration.h
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

#import "WBTableViewCellHandler.h"

/*
 *
 *	WBSectionHeaderFooter
 *
 */
@interface WBSectionHeaderFooter : NSObject
{
	NSString *_title;
	UIView *_view;
	CGFloat _height;
}
@property(copy) NSString *title;
@property(strong) UIView *view;
@property(assign) CGFloat height;

@end


/*
 *
 *	WBTableSection
 *
 */
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
- (id<WBTableViewCellHandler>)tableViewCellHandlerAtIndex:(NSInteger)index;
- (id<WBTableViewCellHandler>)firstTableViewCellHandler;
- (id<WBTableViewCellHandler>)lastTableViewCellHandler;

- (NSEnumerator *)tableViewCellHandlerEnumerator;

- (NSInteger)indexOfTableViewCellHandler:(id<WBTableViewCellHandler>)controller;

- (void)makeTableViewCellHandlersPerformSelector:(SEL)selector;
- (void)makeTableViewCellHandlersPerformSelector:(SEL)selector withObject:(id)object;

#if NS_BLOCKS_AVAILABLE
- (void)enumerateTableViewCellHandlers:(void (^)(id<WBTableViewCellHandler> handler, NSInteger idx, BOOL *stop))block;
#endif
@end


/*
 *
 *	WBTableHeaderFooter
 *
 */
@interface WBTableHeaderFooter : NSObject
{
	UIView *_view;
	CGFloat _height;
}

@property(strong) UIView *view;
@property(assign) CGFloat height;

@end



/*
 *
 *	WBTableConfiguration
 *
 */
@interface WBTableConfiguration : NSObject
{
	WBTableHeaderFooter *	_header;
	WBTableHeaderFooter *	_footer;
	NSArray *				_sections;
}
@property(strong,readonly) WBTableHeaderFooter *header;
@property(strong,readonly) WBTableHeaderFooter *footer;
@property (strong,readonly) NSArray *sections;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithTableSections:(NSArray *)sections;

- (NSInteger)numberOfSections;
- (WBTableSection *)sectionAtIndex:(NSInteger)index;
- (WBTableSection *)sectionWithTag:(NSInteger)tag;
- (WBTableSection *)lastSection;
- (WBTableSection *)firstSection;
- (void)addSection:(WBTableSection *)section;
- (void)insertSection:(WBTableSection *)section atIndex:(NSInteger)index;
- (void)removeSection:(WBTableSection *)section;
- (void)removeSectionAtIndex:(NSInteger)index;

- (NSEnumerator *)sectionEnumerator;

- (NSInteger)indexOfSection:(WBTableSection *)section;

- (id<WBTableViewCellHandler>)tableViewCellHandlerForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathOfTableViewCellHandler:(id<WBTableViewCellHandler>)controller;

- (void)makeTableViewCellHandlersPerformSelector:(SEL)selector;
- (void)makeTableViewCellHandlersPerformSelector:(SEL)selector withObject:(id)object;

#if NS_BLOCKS_AVAILABLE
- (void)enumerateTableViewCellHandlers:(void (^)(id<WBTableViewCellHandler> handler, NSIndexPath *indexPath, BOOL *stop))block;
#endif
@end
