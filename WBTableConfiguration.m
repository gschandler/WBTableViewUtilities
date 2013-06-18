//
//  WBTableConfiguration.m
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

#import "WBTableConfiguration.h"
#import "WBTableViewCellHandler.h"

@implementation WBSectionHeaderFooter

@synthesize title=_title;
@synthesize view=_view;
@synthesize height=_height;

/*
 *
 *
 *
 */
- (void)dealloc
{
#if !__has_feature(objc_arc)
	[_title release];
	[_view release];
	[super dealloc];
#endif
}

@end

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
- (id<WBTableViewCellHandler>)firstTableViewCellHandler
{
	return [self.tableViewCellHandlers objectAtIndex:0];
}

/*
 *
 *
 *
 */
- (id<WBTableViewCellHandler>)lastTableViewCellHandler
{
	return [self.tableViewCellHandlers lastObject];
}

/*
 *
 *
 *
 */
- (NSInteger)indexOfTableViewCellHandler:(id<WBTableViewCellHandler>)handler
{
	NSParameterAssert(handler);
	return [self.tableViewCellHandlers indexOfObject:handler];
}

/*
 *
 *
 *
 */
- (NSEnumerator *)tableViewCellHandlerEnumerator
{
	return [self.tableViewCellHandlers objectEnumerator];
}

/*
 *
 *
 *
 */
- (void)makeTableViewCellHandlersPerformSelector:(SEL)selector
{
	[self.tableViewCellHandlers makeObjectsPerformSelector:selector];
}

/*
 *
 *
 *
 */
- (void)makeTableViewCellHandlersPerformSelector:(SEL)selector withObject:(id)object
{
	[self.tableViewCellHandlers makeObjectsPerformSelector:selector withObject:object];
}

/*
 *
 *
 *
 */
#if NS_BLOCKS_AVAILABLE
- (void)enumerateTableViewCellHandlers:(void (^)(id<WBTableViewCellHandler>, NSInteger, BOOL *))block
{
    [self.tableViewCellHandlers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id<WBTableViewCellHandler> controller = (id<WBTableViewCellHandler>)obj;
        block(controller,idx,stop);
    }];
}
#endif
@end

@implementation WBTableHeaderFooter

@synthesize view=_view;
@synthesize height=_height;

/*
 *
 *
 *
 */
- (void)dealloc
{
#if !__has_feature(objc_arc)
	[_view release];
	[super dealloc];
#endif
}

@end



@interface WBTableConfiguration()
@property (strong) NSArray *sections;
@end



@implementation WBTableConfiguration
@synthesize header = _header;
@synthesize sections = _sections;
@synthesize footer = _footer;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	NSParameterAssert(dictionary);
	if ( self = [super init], self != nil ) {
		
	}
	return self;
}

/*
 *
 *
 *
 */
- (id)init
{
	self = [self initWithTableSections:[NSArray array]];
	return self;
}

//- (id)initWithNumberOfSections:(NSInteger)count
//{
//	self = [super init];
//	if ( self ) {
//		_sections = [[NSMutableArray alloc] initWithCapacity:count];
//		_header = [WBTableHeaderFooter new];
//		_footer = [WBTableHeaderFooter new];
//	}
//	return self;
//}

/*
 *
 *
 *
 */
- (id)initWithTableSections:(NSArray *)sections
{
	NSParameterAssert(sections);
	
	self = [super init];
	if ( self ) {
		_sections = [[NSArray alloc] initWithArray:sections];
		_header = [WBTableHeaderFooter new];
		_footer = [WBTableHeaderFooter new];
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
	[_header release];
	[_sections release];
	[_footer release];
	[super dealloc];
#endif
}

/*
 *
 *
 *
 */
- (NSInteger)numberOfSections
{
	return [self.sections count];
}

/*
 *
 *
 *
 */
- (WBTableSection *)sectionAtIndex:(NSInteger)index
{
	WBTableSection *section = nil;
	if ( [self numberOfSections] > index ) {
		section = [self.sections objectAtIndex:index];
	}
	return section;
}

/*
 *
 *
 *
 */
- (WBTableSection *)sectionWithTag:(NSInteger)tag
{
	WBTableSection *section = nil;
	for ( WBTableSection *section in self.sections ) {
		if (section.tag == tag) break;
	}
	return section;
}


/*
 *
 *
 *
 */
- (WBTableSection *)lastSection
{
	return ([self numberOfSections]>0) ? [self.sections lastObject] : nil;
}

/*
 *
 *
 *
 */
- (WBTableSection *)firstSection
{
	return ([self numberOfSections]>0) ? [self.sections objectAtIndex:0] : nil;
}


/*
 *
 *
 *
 */
- (void)addSection:(WBTableSection *)section
{
	NSParameterAssert(section);
	if ( [self.sections containsObject:section] == NO ) {
		self.sections = [self.sections arrayByAddingObject:section];
	}
}

/*
 *
 *
 *
 */
- (void)insertSection:(WBTableSection *)section atIndex:(NSInteger)index
{
	NSParameterAssert(section);
	if ( [self numberOfSections] >= index ) {
		if ( [self.sections containsObject:section] == NO ) {
			NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.sections];
			[temp insertObject:section atIndex:index];
			self.sections = temp;
#if !__has_feature(objc_arc)
			[temp release];
#endif
		}
	}
}

/*
 *
 *
 *
 */
- (void)removeSection:(WBTableSection *)section
{
	NSParameterAssert(section);
	NSInteger index = [self.sections indexOfObject:section];
	if ( index != NSNotFound ) {
		[self removeSectionAtIndex:index];
	}
}

/*
 *
 *
 *
 */
- (void)removeSectionAtIndex:(NSInteger)index
{
	if ( [self numberOfSections] > index ) {
		NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.sections];
		[temp removeObjectAtIndex:index];
		self.sections = temp;
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
- (NSEnumerator *)sectionEnumerator
{
	return [self.sections objectEnumerator];
}


/*
 *
 *
 *
 */
- (NSInteger)indexOfSection:(WBTableSection *)section
{
	NSParameterAssert(section);
	return [self.sections indexOfObject:section];
}

/*
 *
 *
 *
 */
- (id<WBTableViewCellHandler>)tableViewCellHandlerForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSParameterAssert(indexPath);
	NSAssert1(indexPath.section<self.sections.count,@"Invalid section index (%d)",indexPath.section);
	
	WBTableSection *section = [self.sections objectAtIndex:indexPath.section];
	id<WBTableViewCellHandler> controller = [section tableViewCellHandlerAtIndex:indexPath.row];
	return controller;
}

/*
 *
 *
 *
 */
- (NSIndexPath *)indexPathOfTableViewCellHandler:(id<WBTableViewCellHandler>)handler
{
	NSIndexPath *indexPath = nil;
	NSArray * result = [self.sections filteredArrayUsingPredicate:
						[NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:NSStringFromSelector(@selector(tableViewCellHandlers))]
														   rightExpression:[NSExpression expressionForConstantValue:handler]
															customSelector:@selector(containsObject:)]];
	
	WBTableSection *tableSection = [result lastObject];
	if ( tableSection ) {
		NSInteger section = [self indexOfSection:tableSection];
		NSInteger row = [tableSection indexOfTableViewCellHandler:handler];
		indexPath = [NSIndexPath indexPathForRow:row inSection:section];
	}
	return indexPath;
}

/*
 *
 *
 *
 */
- (void)makeTableViewCellHandlersPerformSelector:(SEL)selector
{
	for ( WBTableSection *section in self.sections ) {
		[section makeTableViewCellHandlersPerformSelector:selector];
	}
}

/*
 *
 *
 *
 */
- (void)makeTableViewCellHandlersPerformSelector:(SEL)selector withObject:(id)object
{
	for ( WBTableSection *section in self.sections ) {
		[section makeTableViewCellHandlersPerformSelector:selector withObject:object];
	}
}

/*
 *
 *
 *
 */
#if NS_BLOCKS_AVAILABLE
- (void)enumerateTableViewCellHandlers:(void (^)(id<WBTableViewCellHandler>, NSIndexPath *, BOOL *))block
{
    NSParameterAssert(block);
    [self.sections enumerateObjectsUsingBlock:^(id sectionObj, NSUInteger sectionIndex, BOOL *stopOuter) {
        WBTableSection *section = (WBTableSection *)sectionObj;
        [section enumerateTableViewCellHandlers:^(id<WBTableViewCellHandler> controller, NSInteger rowIndex, BOOL *stopInner) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            block(controller,indexPath,stopInner);
            *stopOuter = *stopInner;
        }];
    }];

}
#endif
@end
