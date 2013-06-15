/**
 * Cordova DatePicker plugin.js
 *
 * @author Cristobal Dabed
 */
cordova.define("cordova/plugin/datepicker", function(require, exports, module) {
  var exec = require('cordova/exec');


	var pad       = function (val) { return (String(val).length == 1 ? "0" : "") + String(val); };
	var parseDate = function (val) { return new Date(parseFloat(val) * 1000); };

	/**
	 * Datepicker
	 */
	function DatePicker() {
		var self = this;

		this.options   = null;
		this.callbacks =  {
			onSuccess: function (options) {
				if (options.changed !== false) {
					self.onChange(options.date);
				}
				else {
					self.onDismiss(options.date);
				}
			},
			onError: function () {
				self.onError();
			}
		};
	}

	/**
	 * Show
	 *
	 * @param options
	 */
	DatePicker.prototype.show = function (options) {
		var date = options.date ? options.date : '';
		if (date) {
			options.date = [
				date.getFullYear(), '-', pad(date.getMonth() + 1), '-', pad(date.getDate()), 
				"T", pad(date.getHours()), ":", pad(date.getMinutes()), ":00Z"
			].join("");
		}

		var defaults = {
			mode: 'datetime',
			date: '',
			allowOldDates:    true,
			allowFutureDates: true
		};

		for (var key in defaults) {
			if (key in options) {
				defaults[key] = options[key];
			}
		}

		defaults.onChange = ("onChange" in options);

		this.options = options;
		exec(this.callbacks.onSuccess, this.callbacks.onError, "DatePicker", "show", [defaults]);
	};

	/**
	 * Hide
	 */
	DatePicker.prototype.hide = function () {
		exec(null, null, "DatePicker", "hide", []);
	};

	/**
	 * Dismiss
	 *
	 * @param val
	 */
	DatePicker.prototype.onDismiss = function (val) {
		if (this.options.onDismiss) {
			this.options.onDismiss(parseDate(val));
		}
	};

	/**
	 * On error
	 *
	 * @param val
	 */
	DatePicker.prototype.onError = function (val) {
		if (this.options.onError) {
			this.options.onError(val);
		}
	};

	/**
   	 * On change
   	 *
   	 * @param val
	 */
	DatePicker.prototype.onChange = function (val) {
		if (this.options.onChange) {
			this.options.onChange(parseDate(val));
		}
	};

	var datePicker = new DatePicker();
	module.exports = datePicker;
});
