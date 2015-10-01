using Toybox.Application;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;

class TrailRaceApp extends Application.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new TrailRaceView() ];
    }

}

class TrailRaceView extends WatchUi.DataField {
	var elapsedTime = 0;  // millisec
	var altitude = 0.0f;  // meters
	var currentCadence = 0; 
	var currentSpeed = 0.0f;  // m/s
	var elapsedDistance = 0.0f; // meters

	// Parameter `v` represents meters/sec.
	function formatSpeed(v, unit) {
		var seconds = null;
		if (unit == System.UNIT_STATUTE) {
			seconds = 1609.344 / v;  // seconds / mile
		} else {
			seconds = 1000.0 / v;  // seconds / km.
		}
		seconds = seconds.toLong();
		var m = seconds / 60;
		seconds %= 60;
		return m.format("%d") + ":" + seconds.format("%02d");
	}
	
	function formatAltitude(v, unit) {
		if (unit == System.UNIT_STATUTE) {
			var feet = (v / 3.28084);
			return feet.format("%.0f") + "ft";
		} else {
			return v.format("%.0f") + "m";
		}
	}
	
	// Given an elapsed time in millisecs, return a human-readable string, such as
	// "2:30:45".
	function formatElapsedTime(t) {
		t = t / 1000;
		var h = t / 3600;
		t %= 3600;
		var m = t / 60;
		var s = t % 60;
		if (h >= 10) {
			return h.format("%d:") + ":" + m.format("%02d");
		} else if (h > 0) {
			return h.format("%d") + ":" + m.format("%02d") + ":" + s.format("%02d");
		} else {
			return m.format("%02d") + ":" + s.format("%02d");
		}
	}
	
    //! Foo Hah. he given info object contains all the current workout
    //! information. Calculate a value and return it in this method.
    function compute(info) {
    	elapsedTime = info.elapsedTime;
    	altitude = info.altitude;
    	currentCadence = info.currentCadence;
    	currentSpeed = info.currentSpeed;
    	elapsedDistance = info.elapsedDistance;
    	System.println("Cadence " + info.currentCadence + " elapsed: " + info.elapsedTime);
        return "Cad" + info.elapsedTime;
    }
    function onUpdate(dc) {
    	if (elapsedTime == null) {
    		return;
   		}
    	var settings = System.getDeviceSettings();
    	System.println("onUpdate: " + dc.getHeight() + ":" + dc.getWidth());
    	var xx = 10.0f;
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());    	

		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		var x = 10;
		var y = 30;
		dc.drawText(x, y, Graphics.FONT_TINY, "Timer", Graphics.TEXT_JUSTIFY_LEFT);
		y += 10;
   		dc.drawText(x, y, Graphics.FONT_NUMBER_MILD, formatElapsedTime(elapsedTime), Graphics.TEXT_JUSTIFY_LEFT);
		y += 20;
		dc.drawText(x, y, Graphics.FONT_NUMBER_MILD, formatAltitude(altitude, settings.elevationUnits), Graphics.TEXT_JUSTIFY_LEFT);    		
		y += 20;
		dc.drawText(x, y, Graphics.FONT_NUMBER_MILD, formatSpeed(currentSpeed, settings.distanceUnits), Graphics.TEXT_JUSTIFY_LEFT);    		
    }
	
}