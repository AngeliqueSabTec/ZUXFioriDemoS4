sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"zflights4/flights4/test/integration/pages/FlightList",
	"zflights4/flights4/test/integration/pages/FlightObjectPage"
], function (JourneyRunner, FlightList, FlightObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('zflights4/flights4') + '/test/flp.html#app-preview',
        pages: {
			onTheFlightList: FlightList,
			onTheFlightObjectPage: FlightObjectPage
        },
        async: true
    });

    return runner;
});

