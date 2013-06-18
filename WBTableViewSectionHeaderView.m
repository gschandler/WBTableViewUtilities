//
//  WBTableViewSectionHeaderView.m
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

#import "WBTableViewSectionHeaderView.h"


@implementation WBTableViewSectionHeaderView
@synthesize gradientColors=_gradientColors;
@synthesize topEdgeColor=_topEdgeColor;
@synthesize bottomEdgeColor=_bottomEdgeColor;
@synthesize textLabel=_textLabel;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame], self != nil) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
	if ( _gradient )
		CGGradientRelease(_gradient);
#if !__has_feature(objc_arc)
	[_gradientColors release];
	[_topEdgeColor release];
	[_bottomEdgeColor release];
	[_textLabel release];
	[super dealloc];
#endif
}

- (UILabel *)textLabel
{
	if ( _textLabel == nil ) {
		UIFont *font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
		CGRect rect = CGRectInset(self.bounds, 10.0, 0.0);
		rect.size.height = [font lineHeight];
		
		_textLabel = [[UILabel alloc] initWithFrame:rect];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.font = font;
		_textLabel.shadowOffset = (CGSize){0.0,1.0};
		_textLabel.shadowColor = [UIColor darkGrayColor];
		_textLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
		_textLabel.center = (CGPoint){CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds)};
		[self addSubview:_textLabel];
	}
	return _textLabel;
}

- (void)setGradientColors:(NSArray *)colors
{
	if ( colors != _gradientColors) {
#if !__has_feature(objc_arc)
		[_gradientColors release];
		[colors retain];
#endif
		_gradientColors = colors;
		if ( _gradient ) {
			CGGradientRelease(_gradient);
			_gradient = NULL;
		}
		[self setNeedsDisplay];
	}
}

- (void)setTopEdgeColor:(UIColor *)color
{
	if ( _topEdgeColor != color ) {
#if !__has_feature(objc_arc)
		[_topEdgeColor release];
		[color retain];
#endif
		_topEdgeColor = color;
		[self setNeedsDisplay];
	}
}

- (void)setBottomEdgeColor:(UIColor *)color
{
	if ( _bottomEdgeColor != color ) {
#if !__has_feature(objc_arc)
		[_bottomEdgeColor release];
		[color retain];
#endif
		_bottomEdgeColor = color;
		[self setNeedsDisplay];
	}
}

-(void)drawRect:(CGRect)rect 
{
	if ( _gradient == NULL && self.gradientColors.count > 0) {
		NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:self.gradientColors.count];
		[self.gradientColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[colors addObject:(id)[obj CGColor]];
		}];
		_gradient = CGGradientCreateWithColors( NULL, (__bridge CFArrayRef)colors, NULL);
#if !__has_feature(objc_arc)
		[colors release];
#endif
	}
	
	CGPoint startPoint = rect.origin;
	CGPoint endPoint = rect.origin;
	endPoint.y += rect.size.height;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if ( _gradient ) {
		CGContextSaveGState(context);
		CGContextClipToRect(context, rect);
		CGContextDrawLinearGradient(context, _gradient, startPoint, endPoint, 0);
		CGContextRestoreGState(context);
	}
	
	if ( _topEdgeColor ) {
		[_topEdgeColor setStroke];
		UIBezierPath *path = [UIBezierPath bezierPath];
		[path moveToPoint:startPoint];
		[path addLineToPoint:(CGPoint){startPoint.x+CGRectGetWidth(rect),startPoint.y}];
		[path stroke];
	}
	
	if ( _bottomEdgeColor ) {
		[_bottomEdgeColor setStroke];
		UIBezierPath *path = [UIBezierPath bezierPath];
		[path moveToPoint:endPoint];
		[path addLineToPoint:(CGPoint){endPoint.x+CGRectGetWidth(rect),endPoint.y}];
		[path stroke];
	}
}

@end
