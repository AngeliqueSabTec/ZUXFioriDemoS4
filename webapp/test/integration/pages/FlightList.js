sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'zflights4.flights4',
            componentId: 'FlightList',
            contextPath: '/Flight'
        },
        CustomPageDefinitions
    );
});