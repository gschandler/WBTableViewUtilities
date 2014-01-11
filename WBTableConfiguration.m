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
#import "WBTableHeaderFooter.h"
#import "WBTableSection.h"


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
		// not yet implemented
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
	self = [self initWithTableSections:@[]];
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
		_sections = [NSArray arrayWithArray:sections];
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
- (WBTableSection *)addSection
{
	WBTableSection *section = [WBTableSection new];
	[self addSection:section];
	return section;
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
			NSMutableArray *temp = [NSMutableArray arrayWithArray:self.sections];
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
		NSMutableArray *temp = [NSMutableArray arrayWithArray:self.sections];
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
- (void)removeSectionWithTag:(NSInteger)tag
{
	NSMutableArray *temp = [NSMutableArray arrayWithArray:self.sections];
	
	[temp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ( [(WBTableSection *)obj tag] == tag ) {
			*stop = YES;
			[temp removeObjectAtIndex:idx];
		}
	}];
	
	self.sections = temp;
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
