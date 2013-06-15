//  DatePicker.m
//  By Cristobal Dabed
//  Adapted from https://github.com/phonegap/phonegap-plugins/tree/master/iOS/DatePicker
//
//	Phonegap DatePicker Plugin
//	Copyright (c) Greg Allen 2011
//	MIT Licensed
//
//  Additional refactoring by Sam de Freyssinet
// TODO: Add prev/next buttons

#import "DatePicker.h"

@interface DatePicker (Private)

// Initialize the UIActionSheet with ID <UIActionSheetDelegate> delegate UIDatePicker datePicker (UISegmentedControl)closeButton
- (void)initActionSheet:(id <UIActionSheetDelegate>)delegateOrNil datePicker:(UIDatePicker *)datePicker closeButton:(UISegmentedControl *)closeButton;

// Creates the NSDateFormatter with NSString format and NSTimeZone timezone
- (NSDateFormatter *)createISODateFormatter:(NSString *)format timezone:(NSTimeZone *)timezone;

// Creates the UIDatePicker with NSMutableDictionary options
- (UIDatePicker *)createDatePicker:(CGRect)pickerFrame;

// Creates the UISegmentedControl with UIView parentView, NSString title, ID target and SEL action
- (UISegmentedControl *)createActionSheetCloseButton:(NSString *)title target:(id)target action:(SEL)action;

// Configures the UIDatePicker with the NSMutableDictionary options
- (void)configureDatePicker:(NSMutableDictionary *)optionsOrNil;

@end

@implementation DatePicker
{
    NSString *callbackId;
	BOOL delegateEventValueChanged;
}

@synthesize datePickerSheet  = _datePickerSheet;
@synthesize datePicker       = _datePicker;
@synthesize isoDateFormatter = _isoDateFormatter;

#pragma mark - Public Methods

- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView
{
	self = (DatePicker *)[super initWithWebView:theWebView];

	if (self) {
		UIDatePicker       *userDatePicker        = [self createDatePicker:CGRectMake(0, 40, 0, 0)];
		UISegmentedControl *datePickerCloseButton = [self createActionSheetCloseButton:@"Done" target:self action:@selector(dismissActionSheet:)];
		NSDateFormatter    *isoTimeFormatter      = [self createISODateFormatter:k_DATEPICKER_DATETIME_FORMAT timezone:[NSTimeZone defaultTimeZone]];

		self.datePicker       = userDatePicker;
		self.isoDateFormatter = isoTimeFormatter;


		[self initActionSheet:self datePicker:userDatePicker closeButton:datePickerCloseButton];
		[self.datePicker addTarget:self action:@selector(onDateValueChanged:) forControlEvents:UIControlEventValueChanged];
	}

	return self;
}

- (void)show:(CDVInvokedUrlCommand*)command
{
	if (isVisible) {
		return;        
	}

    NSMutableDictionary* options = [command.arguments objectAtIndex: 0];
	[self configureDatePicker:options];
	[self.datePickerSheet showInView:[[super webView] superview]];	
	[self.datePickerSheet setBounds:CGRectMake(0, 0, 320, 485)];

	if ([[options objectForKey:@"onChange"] intValue] == 1) {
		delegateEventValueChanged = YES;
	}
    callbackId = [command.callbackId copy];
	isVisible = YES;
}

- (void)hide:(CDVInvokedUrlCommand*)command
{
	NSLog(@"hide invoked");
	if (!isVisible) {
		return;
	}

	[self performSelector:@selector(dismissActionSheet:) withObject:self afterDelay:0.0];
}

- (void)dismissActionSheet:(id)sender {
	[self.datePickerSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)onMemoryWarning
{
	// It could be better to close the datepicker before the system
	// clears memory. But in reality, other non-visible plugins should
	// be tidying themselves at this point. This could cause a fatal
	// at runtime.
	if (isVisible) {
		return;
	}

	[self release];
}

- (void)dealloc
{
	[_datePicker release];
	[_datePickerSheet release];
	[_isoDateFormatter release];

	if (callbackId != nil) {
    	[callbackId release];
	}

    [super dealloc];
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self delegateDateValueToPlugin];
	[callbackId release];
	callbackId = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	isVisible = NO;
}

#pragma mark - Private Methods

- (void)delegateDateValueToPlugin
{
	[self delegateDateValueToPlugin:NO];
}
- (void)delegateDateValueToPlugin:(BOOL *)asDateValueChanged
{
	// Send dictionary with date valued and wether it's an changed valued operation otherwise interpreted as dismiss
	NSDictionary * options = @{
		@"date":    [NSNumber numberWithDouble:[self.datePicker.date timeIntervalSince1970]],
		@"changed": [NSNumber numberWithBool: asDateValueChanged]
	};

	// create the plugin result and make sure to set it to be keeped
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: options];
	pluginResult.keepCallback     = [NSNumber numberWithBool:YES];

	// send the result back
	[self.commandDelegate sendPluginResult:pluginResult callbackId: callbackId];
}

- (void)initActionSheet:(id <UIActionSheetDelegate>)delegateOrNil datePicker:(UIDatePicker *)datePicker closeButton:(UISegmentedControl *)closeButton
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:delegateOrNil 
													cancelButtonTitle:nil 
											   destructiveButtonTitle:nil 
													otherButtonTitles:nil];

	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];

	[actionSheet addSubview:datePicker];
	[actionSheet addSubview:closeButton];

	self.datePickerSheet = actionSheet;

	[actionSheet release];
}

- (void)onDateValueChanged:(id)sender
{
	if (delegateEventValueChanged) {
		NSLog(@"delegated…");
		[self delegateDateValueToPlugin:YES];
	}
}

- (UIDatePicker *)createDatePicker:(CGRect)pickerFrame
{
	UIDatePicker *datePickerControl = [[UIDatePicker alloc] initWithFrame:pickerFrame];
	return [datePickerControl autorelease];
}

- (NSDateFormatter *)createISODateFormatter:(NSString *)format timezone:(NSTimeZone *)timezone;
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:timezone];
	[dateFormatter setDateFormat:format];

	return [dateFormatter autorelease];
}

- (UISegmentedControl *)createActionSheetCloseButton:(NSString *)title target:(id)target action:(SEL)action
{
	UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:title]];

	closeButton.momentary = YES;
	closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
	closeButton.tintColor = [UIColor blackColor];

	[closeButton addTarget:target action:action forControlEvents:UIControlEventValueChanged];

	return [closeButton autorelease];
}

- (void)configureDatePicker:(NSMutableDictionary *)optionsOrNil;
{
 	NSString *mode       = [optionsOrNil objectForKey:@"mode"];
	NSString *dateString = [optionsOrNil objectForKey:@"date"];

	BOOL allowOldDates    = NO;
	BOOL allowFutureDates = YES;

	if ([[optionsOrNil objectForKey:@"allowOldDates"] intValue] == 1) {
		allowOldDates = YES;
	}

	if ( ! allowOldDates) {
		self.datePicker.minimumDate = [NSDate date];
	}
	
	if ([[optionsOrNil objectForKey:@"allowFutureDates"] intValue] == 0) {
		allowFutureDates = NO;
	}

	if ( ! allowFutureDates) {
		self.datePicker.maximumDate = [NSDate date];
	}
    
	if ([dateString length] == 0) {
		self.datePicker.date = [NSDate date];
	}
	else {
		self.datePicker.date = [self.isoDateFormatter dateFromString:dateString];
	}

	if ([mode isEqualToString:@"date"]) {
		self.datePicker.datePickerMode = UIDatePickerModeDate;
	}
	else if ([mode isEqualToString:@"time"]) {
		self.datePicker.datePickerMode = UIDatePickerModeTime;
	}
	else {
		self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
	}
}

@end
