/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },

    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },

    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        console.log('Received Event: ' + id);
        document.getElementById('datepicker-form').setAttribute("style", "display: block;");
    },

    //--------------------------------------------------------------------------
    //
    //  Date Picker test
    //
    //-------------------------------------------------------------------------
    showDatePicker: function () {
        try {
        var datePicker = cordova.require("cordova/plugin/datepicker");
        var options = {
            date: new Date(),
            mode: 'date'
        };

        if (document.getElementById("options-change").checked) {
            options.onChange = this.onDatePickerChange;
        }
        if (document.getElementById("options-prev").checked) {
            options.onPrev = this.onDatePickerPrev;
        }
        if (document.getElementById("options-next").checked) {
            options.onNext = this.onDatePickerNext;
        }

        options.visibility = document.getElementById("options-visibility").value;
        options.onDismiss  = this.onDatePickerDismiss;
        datePicker.show(options);
        }
        catch(error) {
            console.log(error);
        }
    },


    onDatePickerChange: function (date) {
        console.log("onChange:", date);
        document.getElementById("datepicker-value").value = date.toString();
    },

    onDatePickerDismiss: function (date) {
        console.log("onDismiss:", date);
        document.getElementById("datepicker-value").value = date.toString();
    },

    onDatePickerPrev: function () {
        alert("Dismiss and prev");
    },

    onDatePickerNext: function () {
        alert("Dismiss and next");
    }
};
