"use strict"

var timerInterval;
var timerObject;

function initializeControlAddIn(id) {
    var controlAddIn = document.getElementById(id);

    controlAddIn.innerHTML =
		'<div id="ping-pong">' +
		'</div>';
    pageLoaded();

	Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlAddInReady', null);
}

function pageLoaded() {
}

function SetTimerInterval(milliSeconds) {
    timerInterval = milliSeconds;
}

function StartTimer() {
    if (timerInterval == 0 || timerInterval == null) {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('PingPongError', ['No timer interval was set.']);
        return;
    }

    timerObject = window.setInterval(ExecuteTimer, timerInterval);
}

function StopTimer() {
    clearInterval(timerObject);
}

function ExecuteTimer() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('TimerElapsed', null);
}