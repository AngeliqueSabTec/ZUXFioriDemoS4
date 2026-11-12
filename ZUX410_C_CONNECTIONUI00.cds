*&---------------------------------------------------------------------*
*& CDS View  : ZUX410_C_CONNECTIONUI00  (New — Session 3 Demo)
*& Purpose   : Fiori Elements entity — Flight Connections/Schedules
*& Table     : SPFLI  (Flight Schedule master — no fldate key)
*& Covers    : Association navigation, @UI annotations, OData $expand
*&             Demo: shows how one service can expose multiple entities
*&             that navigate to each other (Connection → Flights)
*&---------------------------------------------------------------------*

@AbapCatalog.sqlViewName:            'ZUX410CONN00'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck:   #CHECK
@EndUserText.label:                  'UX410 Connections – Demo'

@OData.publish:          true
@OData.entitySet.name:  'ConnectionSet'
@OData.entityType.name: 'Connection'

"──────────────────────────────────────────────────────────────────────
" HEADER INFO
"──────────────────────────────────────────────────────────────────────
@UI.headerInfo.typeName:          'Connection'
@UI.headerInfo.typeNamePlural:    'Connections'
@UI.headerInfo.title.value:       'connid'
@UI.headerInfo.description.value: 'carrname'

@Search.searchable: true

define view ZUX410_C_CONNECTIONUI00 as select from spfli as sp

  "── Carrier master ──────────────────────────────────────────────────
  association to scarr as sc
    on sp.carrid = sc.carrid

  "── Flights on this connection (1:N) ────────────────────────────────
  "   Demo point: navigation from Connection list → individual flights
  "   OData: /ConnectionSet('LH0400')/Flights
  association [*] to ZUX410_C_FLIGHTUI00_14 as _Flights
    on  $projection.carrid = _Flights.carrid
    and $projection.connid = _Flights.connid

{
  "══════════════════════════════════════════════════════════════════════
  " FACET STRUCTURE
  "══════════════════════════════════════════════════════════════════════
  @UI.facet: [
    "── Header KPI boxes ────────────────────────────────────────────────
    { purpose: #HEADER, type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'RouteHeader', position: 10, label: 'Route' },
    { purpose: #HEADER, type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'ScheduleHeader', position: 20, label: 'Schedule' },

    "── Body: Route Details section ─────────────────────────────────────
    { id: 'RouteSection', purpose: #STANDARD, type: #COLLECTION,
      label: 'Route Details', position: 10 },
    { id: 'ScheduleSection', purpose: #STANDARD, type: #COLLECTION,
      label: 'Schedule',      position: 20 },
    { id: 'FlightsSection',  purpose: #STANDARD, type: #LINEITEM_REFERENCE,
      label: 'Scheduled Flights', targetElement: '_Flights', position: 30 },

    "── Route section children ──────────────────────────────────────────
    { id: 'DepartureFacet', parentId: 'RouteSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'DepartureData',
      label: 'Departure', position: 10 },
    { id: 'ArrivalFacet',   parentId: 'RouteSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'ArrivalData',
      label: 'Arrival',   position: 20 },

    "── Schedule section children ────────────────────────────────────────
    { id: 'TimingFacet',   parentId: 'ScheduleSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'TimingData',
      label: 'Timings',   position: 10 },
    { id: 'DistanceFacet', parentId: 'ScheduleSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'DistanceData',
      label: 'Distance',  position: 20 }
  ]

  "══════════════════════════════════════════════════════════════════════
  " KEY FIELDS
  "══════════════════════════════════════════════════════════════════════

  @Common.label:      'Airline'
  @UI.lineItem:       [{ position: 10, label: 'Airline' }]
  @UI.selectionField: [{ position: 10 }]
  @UI.fieldGroup:     [{ qualifier: 'RouteHeader', position: 10 }]
  key sp.carrid,

  @Common.label:      'Connection No.'
  @UI.lineItem:       [{ position: 20, label: 'Conn. No.' }]
  @UI.identification: [{ position: 10 }]
  key sp.connid,

  "══════════════════════════════════════════════════════════════════════
  " CARRIER INFO  (from SCARR)
  "══════════════════════════════════════════════════════════════════════

  @Common.label:                'Airline Name'
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold:   0.7
  @UI.lineItem:       [{ position: 30, label: 'Airline Name', importance: #HIGH }]
  @UI.selectionField: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
  @UI.fieldGroup:     [{ qualifier: 'RouteHeader', position: 20 }]
  sc.carrname,

  "══════════════════════════════════════════════════════════════════════
  " DEPARTURE
  "══════════════════════════════════════════════════════════════════════

  @Common.label:      'From Country'
  @UI.fieldGroup:     [{ qualifier: 'DepartureData', position: 10 }]
  sp.countryfr,

  @Common.label:      'Departure City'
  @UI.lineItem:       [{ position: 40, label: 'From', importance: #HIGH }]
  @UI.identification: [{ position: 30 }]
  @UI.selectionField: [{ position: 30 }]
  @UI.fieldGroup:     [{ qualifier: 'DepartureData', position: 20 },
                       { qualifier: 'RouteHeader',    position: 30 }]
  sp.cityfrom,

  @Common.label:  'Departure Airport'
  @UI.lineItem:   [{ position: 50, label: 'Dep. Airport', importance: #MEDIUM }]
  @UI.fieldGroup: [{ qualifier: 'DepartureData', position: 30 }]
  sp.airpfrom,

  @Common.label:  'Departure Time'
  @UI.lineItem:   [{ position: 70, label: 'Dep. Time', importance: #MEDIUM }]
  @UI.fieldGroup: [{ qualifier: 'TimingData', position: 10 },
                   { qualifier: 'ScheduleHeader', position: 10 }]
  sp.deptime,

  "══════════════════════════════════════════════════════════════════════
  " ARRIVAL
  "══════════════════════════════════════════════════════════════════════

  @Common.label:      'To Country'
  @UI.fieldGroup:     [{ qualifier: 'ArrivalData', position: 10 }]
  sp.countryto,

  @Common.label:      'Arrival City'
  @UI.lineItem:       [{ position: 60, label: 'To', importance: #HIGH }]
  @UI.identification: [{ position: 40 }]
  @UI.selectionField: [{ position: 40 }]
  @UI.fieldGroup:     [{ qualifier: 'ArrivalData', position: 20 },
                       { qualifier: 'RouteHeader',  position: 40 }]
  sp.cityto,

  @Common.label:  'Arrival Airport'
  @UI.lineItem:   [{ position: 80, label: 'Arr. Airport', importance: #MEDIUM }]
  @UI.fieldGroup: [{ qualifier: 'ArrivalData', position: 30 }]
  sp.airpto,

  @Common.label:  'Arrival Time'
  @UI.lineItem:   [{ position: 90, label: 'Arr. Time', importance: #MEDIUM }]
  @UI.fieldGroup: [{ qualifier: 'TimingData', position: 20 },
                   { qualifier: 'ScheduleHeader', position: 20 }]
  sp.arrtime,

  "══════════════════════════════════════════════════════════════════════
  " SCHEDULE DETAILS
  "══════════════════════════════════════════════════════════════════════

  @Common.label:      'Flight Duration (min)'
  @UI.lineItem:       [{ position: 100, label: 'Duration', importance: #LOW }]
  @UI.identification: [{ position: 50 }]
  @UI.fieldGroup:     [{ qualifier: 'TimingData', position: 30 }]
  sp.fltime,

  @Common.label:  'Flight Type'
  @UI.fieldGroup: [{ qualifier: 'TimingData', position: 40 }]
  sp.fltype,

  @Common.label:  'Period'
  @UI.fieldGroup: [{ qualifier: 'TimingData', position: 50 }]
  sp.period,

  "══════════════════════════════════════════════════════════════════════
  " DISTANCE
  "══════════════════════════════════════════════════════════════════════

  @Common.label:  'Distance'
  @UI.lineItem:   [{ position: 110, label: 'Distance', importance: #LOW }]
  @UI.fieldGroup: [{ qualifier: 'DistanceData', position: 10 }]
  sp.distance,

  @Common.label:  'Distance Unit'
  @UI.fieldGroup: [{ qualifier: 'DistanceData', position: 20 }]
  sp.distid,

  "══════════════════════════════════════════════════════════════════════
  " ASSOCIATION — exposes navigation to scheduled flights
  " OData URL: /ConnectionSet(carrid='LH',connid='0400')/_Flights
  "            or use $expand=_Flights in the query
  "══════════════════════════════════════════════════════════════════════
  _Flights
}
