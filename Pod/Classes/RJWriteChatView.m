//
//  RJWriteChatView.m
//  Pods
//
//  Created by Rahul Jaswa on 6/11/15.
//
//

#import "RJWriteChatView.h"

static const CGFloat kSpacing = 5.0f;


@interface RJWriteChatView () <UITextViewDelegate>

@property (nonatomic, assign, getter=hasSetupStaticConstraints) BOOL setupStaticConstraints;

@end



@implementation RJWriteChatView

#pragma mark - Private Protocols - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.sendButton.enabled = ([textView.text length] > 0);
    [self sizeTextView:textView];
}

#pragma mark - Private Instance Methods

- (void)sizeTextView:(UITextView *)textView {
    CGFloat commentViewWidth = textView.frame.size.width;
    CGFloat newHeight = [textView sizeThatFits:CGSizeMake(commentViewWidth, CGFLOAT_MAX)].height;
    if (newHeight != CGRectGetHeight(textView.bounds)) {
        [self.delegate writeChatView:self wantsHeight:(newHeight + 2*kSpacing)];
    }
}

#pragma mark - Public Instance Methods

- (BOOL)becomeFirstResponder {
    return [self.commentView becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return [self.commentView canBecomeFirstResponder];
}

- (BOOL)canResignFirstResponder {
    return [self.commentView canResignFirstResponder];
}

- (BOOL)isFirstResponder {
    return [self.commentView isFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.commentView resignFirstResponder];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
        
        _commentView = [[UITextView alloc] initWithFrame:CGRectZero];
        _commentView.scrollEnabled = NO;
        _commentView.delegate = self;
        _commentView.layer.cornerRadius = 4.0f;
        _commentView.layer.borderWidth = 0.5f;
        _commentView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        [self addSubview:_commentView];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.enabled = NO;
        [_sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self addSubview:_sendButton];
    }
    return self;
}

- (void)reset {
    self.commentView.text = @"";
    self.sendButton.enabled = NO;
    [self sizeTextView:self.commentView];
}

- (void)updateConstraints {
    if (!self.hasSetupStaticConstraints) {
        UIView *commentView = self.commentView;
        commentView.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *sendButton = self.sendButton;
        sendButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(commentView, sendButton);
        NSDictionary *metrics = @{ @"spacing" : @(kSpacing) };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-spacing-[commentView]-spacing-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sendButton]-spacing-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-spacing-[commentView]-spacing-[sendButton(==35)]-spacing-|" options:0 metrics:metrics views:views]];
        
        self.setupStaticConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Public Class Methods

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end
