init();
var controlAddin = document.getElementById('controlAddIn');
controlAddin.innerHTML = 'This is our D365BC control addin';
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ControlReady", []);
