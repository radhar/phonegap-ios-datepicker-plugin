PhoneGap iOS DatePicker Plugin
==============================

Custom Fork of the iOS Datepicker From [Phonegap Plugins](https://github.com/phonegap/phonegap-plugins)

Essential changes are:

1. Javascript part of the datePicker plugin has been defined as an cordova module
2. DatePicker was added support for value change event callback .
3. DatePicker was added hide method.


Usage:

		var datePicker = cordova.require("cordova/plugin/datepicker");
		var options =  {
			date: new Date(),
			mode: 'date',
			allowOldValues:    true,
			allowFutureValues: true,
			visibility: "auto",
			onChange: function (date) {
				// on datepicker value change
			},
			onDismiss: function (date) {
				// on datepicker dismiss
			},
			onPrev: function () {
				// on datepicker action sheet previous button clicked
			},
			onNext: function () {
				// on datepicker action sheet next button clicked
			}
		};
		datePicker.show(options);  


The options are:

1. `date:` The default _'date'_ to display if none provided it will automatically use _'now'_.
2. `mode:` The granularity mode either _'date'_ or _'datetime'_, datetime has extended granularity for hours, time and seconds, default _'date'_.
3. `allowOldValues:` Wether to allow older values than the date provided, default true.
4. `allowFutureValues:` Wether to allow future values than the date provided, default true.
5. `visibility:` Howto to display prev/next buttons, auto | visible | hidden
	1. If visibility state set to `auto`, only display _prev / next_ buttons if one of the _`onPrev` / `onNext`_ functions set, otherwise display none 
	2. If visibility state set to `visible` set, both _prev / next_ buttons will be display always, still the enabled state of the buttons will only be display if a correspondent _' onPrev' / 'onNext'_ state function has been provided.
	3. If visibility state set to `hidden`, both _prev / next_ buttons will not be visible regardless wether the _`onPrev` / `onNext`_ functions have beeen provided or not.
	
6. `onChange:` optional callback for when the datepicker changes its value, the selected date value will be provided back as an native js date value.
7. `onDismiss:` required callback for when the datepicker has been dismissed, the selected date value will be provided back as an native js date value.
8. `onPrev:` optional callback to enable the ui controled segmented _'prev'_ button, and to be called when it has been clicked.
9. `onNext:` optional callback to enable the ui controled segmented _'next'_ button, and to be called when it has been clicked


All options besides the required onDismiss callback are optional.
