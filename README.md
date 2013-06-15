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
			onChange: function (date) {
				// on value change
			},
			onDismiss: function (date) {
				// on datepicker dismiss
			}
		};
		datePicker.show(options);  


The options are:

1. `date:` The default _'date'_ to display if none provided it will automatically use _'now'_.
2. `mode:` The granularity mode either _'date'_ or _'datetime'_, datetime has extended granularity for hours, time and seconds, default _'date'_.
3. `allowOldValues:` Wether to allow older values than the date provided, default true.
4. `allowFutureValues:` Wether to allow future values than the date provided, default true.
5. `onChange:` optional callback for when the datepicker changes its value, the selected date value will be provided back as an native js date value.
6. `onDismiss:` required callback for when the datepicker has been dismissed, the selected date value will be provided back as an native js date value.


All options besides the required onDismiss callback are optional.
