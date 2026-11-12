*&---------------------------------------------------------------------*
*& Service   : ZUXFIORI_DEMO
*& Purpose   : OData service definition for Fiori demo
*& Exposes   : Three entities with navigation between them:
*&             ConnectionSet → FlightSet → BookingSet
*& Demo uses : OData $filter, $select, $expand, $orderby
*&---------------------------------------------------------------------*

@EndUserText.label: 'ZUXFIORI_DEMO – Flight Fiori Demo Service'

define service ZUXFIORI_DEMO {

  "── Connections / schedules (spfli) ──────────────────────────────────
  "   List of routes: LH Frankfurt→New York, AA New York→San Fran, etc.
  expose ZUX410_C_CONNECTIONUI00 as ConnectionSet;

  "── Individual flights (sflight) ─────────────────────────────────────
  "   Specific flight instances with date, price, seat occupancy
  expose ZUX410_C_FLIGHTUI00_14  as FlightSet;

  "── Bookings per flight (sbook) ──────────────────────────────────────
  "   Passenger bookings linked to a specific flight
  expose ZUX410_C_BOOKINGUI00    as BookingSet;

}

"══════════════════════════════════════════════════════════════════════
" USEFUL OData DEMO URLs  (to show during Session 3 / Session 4)
"
" After activating the service in /IWFND/MAINT_SERVICE:
"
" 1. Service document
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/
"
" 2. Metadata (EDMX — shows all entities, properties, associations)
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/$metadata
"
" 3. All connections (EntitySet read)
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/ConnectionSet
"
" 4. Filter: only Lufthansa connections
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/ConnectionSet?$filter=carrid eq 'LH'
"
" 5. Select specific columns only ($select)
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/FlightSet?$select=carrid,connid,fldate,price
"
" 6. Expand bookings inline ($expand — uses the _Bookings association)
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/FlightSet?$expand=_Bookings
"
" 7. Combined filter + expand + select
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/FlightSet
"       ?$filter=carrid eq 'LH'
"       &$select=carrid,connid,fldate,price,seatsocc
"       &$expand=_Bookings
"       &$orderby=fldate desc
"       &$top=10
"
" 8. Single entity by key
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/FlightSet(carrid='LH',connid='0400',fldate=datetime'2024-01-15T00:00:00')
"
" 9. Navigate to bookings from a flight (association navigation)
"    /sap/opu/odata/sap/ZUXFIORI_DEMO/FlightSet(carrid='LH',connid='0400',fldate=...)/BookingSet
"
"══════════════════════════════════════════════════════════════════════
