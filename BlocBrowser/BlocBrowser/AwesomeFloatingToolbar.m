//
//  AwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by McCay Barnes on 6/28/15.
//  Copyright (c) 2015 Change5. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;


@end

@implementation AwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 labels
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *label = [[UIButton alloc] init];
            label.userInteractionEnabled = YES;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.titleLabel.font = [UIFont systemFontOfSize:10];
            [label setTitle:titleForThisLabel forState:UIControlStateNormal];
            label.backgroundColor = colorForThisLabel;
            label.titleLabel.textColor = [UIColor whiteColor];
            [label addTarget:self action:@selector(tapFired:) forControlEvents:UIControlEventTouchUpInside];
            
            [labelsArray addObject:label];
        }
        
        self.labels = labelsArray;
                
        for (UIButton *thisLabel in self.labels) {
            [self addSubview:thisLabel];
        }
        //self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        //[self addGestureRecognizer:self.tapGesture];
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    return self;
}

-(void) longPressFired:(UILongPressGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        
        self.colors = @[self.colors[1], self.colors[2], self.colors[3], self.colors[0]];
        
        for (int i = 0; i < self.colors.count; i++) {
            UIColor *color = self.colors[i];
            UIButton *currentLabel = self.labels[i];
            currentLabel.backgroundColor = color;
        }
        
    }
}


- (void) tapFired:(UIButton *) button {
    if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
        [self.delegate floatingToolbar:self didSelectButtonWithTitle:button.titleLabel.text];
    }
}

-(void) pinchFired:(UIPinchGestureRecognizer *) recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGFloat scale = [recognizer scale];
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPinchwithScale:)]) {
            [self.delegate floatingToolbar:self didTryToPinchwithScale:scale];
        }
        [recognizer setScale:scale];
    }
}

- (void) panFired:(UIPanGestureRecognizer *) recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

-(void) layoutSubviews {
    
    for (UIButton *thisLabel in self.labels) {
        
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        if (currentLabelIndex < 2) {
            labelY = 0;
        } else { labelY = CGRectGetHeight(self.bounds) / 2; }
        if (currentLabelIndex % 2 == 0) {
            labelX = 0;
        } else { labelX = CGRectGetWidth(self.bounds) / 2;}
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
}

# pragma mark - Button Handling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UIButton *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
}




















@end
