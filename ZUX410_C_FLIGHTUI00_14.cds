*&---------------------------------------------------------------------*
*& CDS View  : ZUX410_C_FLIGHTUI00_14  (Enhanced for Demo — Session 3)
*& Purpose   : Fiori Elements demo — Flights entity
*& Covers    : @UI.headerInfo, @UI.lineItem, @UI.identification,
*&             @UI.selectionField, @UI.fieldGroup, @UI.facet (nested),
*&             @UI.dataPoint, criticality, @Common.label,
*&             @Search.searchable, OData association navigation
*&---------------------------------------------------------------------*

@AbapCatalog.sqlViewName:            'ZUX410FLIGTUI004'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck:   #CHECK
@EndUserText.label:                  'UX410 Flight UI – Enhanced'

@OData.publish:           true
@OData.entitySet.name:   'FlightSet'
@OData.entityType.name:  'Flight'

"──────────────────────────────────────────────────────────────────────
" HEADER INFO — drives the Object Page title bar
" Demo point: @UI.headerInfo.typeName / typeNamePlural shown in slides
"──────────────────────────────────────────────────────────────────────
@UI.headerInfo.typeName:              'Flight'
@UI.headerInfo.typeNamePlural:        'Flights'
@UI.headerInfo.title.value:           'carrid'
@UI.headerInfo.description.value:     'carrname'

"──────────────────────────────────────────────────────────────────────
" SEARCH — enables the search box and fuzzy matching
"──────────────────────────────────────────────────────────────────────
@Search.searchable: true

define view ZUX410_C_FLIGHTUI00_14 as select from sflight as sf

  "── Carrier master data (1:1) ────────────────────────────────────────
  association to scarr as sc
    on sf.carrid = sc.carrid

  "── Connection schedule (1:1) — corrected from sflights to spfli ─────
  "   spfli holds cityfrom/cityto/airpfrom/airpto — no fldate needed
  association to spfli as sp
    on  sf.carrid = sp.carrid
    and sf.connid = sp.connid

  "── Bookings for this flight (1:N) ───────────────────────────────────
  association [*] to ZUX410_C_BOOKINGUI00 as _Bookings
    on  $projection.carrid = _Bookings.carrid
    and $projection.connid  = _Bookings.connid
    and $projection.fldate  = _Bookings.fldate

{
  "══════════════════════════════════════════════════════════════════════
  " FACET STRUCTURE
  " Demo point: how @UI.facet builds the Object Page layout
  " ├── HEADER: two FieldGroup KPI boxes at top
  " ├── Body Section 1 'Flight Details' (Collection)
  " │   ├── General Data (FieldGroup)
  " │   └── Route Data   (FieldGroup)
  " ├── Body Section 2 'Seat Availability' (Collection)
  " │   ├── Economy Class (FieldGroup)
  " │   ├── Business Class (FieldGroup)
  " │   └── First Class    (FieldGroup)
  " └── Body Section 3 'Bookings' (LineItem — sub-table navigation)
  "══════════════════════════════════════════════════════════════════════
  @UI.facet: [

    "── HEADER facets (shown as info boxes above the body) ─────────────
    { purpose: #HEADER, type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'FlightInfo', position: 10, label: 'Flight Info' },
    { purpose: #HEADER, type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'SeatSummary', position: 20, label: 'Seat Summary' },

    "── Body: top-level collection sections ────────────────────────────
    { id: 'FlightSection', purpose: #STANDARD, type: #COLLECTION,
      label: 'Flight Details', position: 10 },
    { id: 'SeatSection',   purpose: #STANDARD, type: #COLLECTION,
      label: 'Seat Availability', position: 20 },
    { id: 'BookingSection', purpose: #STANDARD, type: #LINEITEM_REFERENCE,
      label: 'Bookings', targetElement: '_Bookings', position: 30 },

    "── Children of FlightSection (parentId links them) ────────────────
    "   Demo point: parentId creates the nested tab structure
    { id: 'GeneralFacet', parentId: 'FlightSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'GeneralData',
      label: 'General Data', position: 10 },
    { id: 'RouteFacet',   parentId: 'FlightSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'RouteData',
      label: 'Route', position: 20 },

    "── Children of SeatSection ────────────────────────────────────────
    { id: 'EconomyFacet',  parentId: 'SeatSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'EconomySeats',
      label: 'Economy Class', position: 10 },
    { id: 'BusinessFacet', parentId: 'SeatSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'BusinessSeats',
      label: 'Business Class', position: 20 },
    { id: 'FirstFacet',    parentId: 'SeatSection', purpose: #STANDARD,
      type: #FIELDGROUP_REFERENCE, targetQualifier: 'FirstClassSeats',
      label: 'First Class', position: 30 }
  ]

  "══════════════════════════════════════════════════════════════════════
  " KEY FIELDS
  "══════════════════════════════════════════════════════════════════════

  "── Airline code ─────────────────────────────────────────────────────
  @Common.label:      'Airline'
  @UI.lineItem:       [{ position: 10, label: 'Airline' }]
  @UI.selectionField: [{ position: 10 }]
  key sf.carrid,

  "── Connection number ────────────────────────────────────────────────
  @Common.label:      'Flight No.'
  @UI.lineItem:       [{ position: 20, label: 'Flight No.' }]
  @UI.selectionField: [{ position: 20 }]
  key sf.connid,

  "── Flight date ──────────────────────────────────────────────────────
  @Common.label:      'Flight Date'
  @UI.lineItem:       [{ position: 30, label: 'Date' }]
  @UI.identification: [{ position: 10 }]
  @UI.selectionField: [{ position: 30 }]
  key sf.fldate,

  "══════════════════════════════════════════════════════════════════════
  " CARRIER INFORMATION
  "══════════════════════════════════════════════════════════════════════

  "── Carrier name (from SCARR association) ────────────────────────────
  "   Demo point: @Search.defaultSearchElement marks this as primary search field
  @Common.label:                   'Airline Name'
  @Search.defaultSearchElement:    true
  @Search.fuzzinessThreshold:      0.7
  @UI.lineItem:       [{ position: 40, label: 'Airline Name',
                         importance: #HIGH }]
  @UI.identification: [{ position: 20 }]
  @UI.selectionField: [{ position: 40 }]
  @UI.fieldGroup:     [{ qualifier: 'FlightInfo',  position: 10 },
                       { qualifier: 'GeneralData', position: 10 }]
  sc.carrname,

  "── Carrier website URL ──────────────────────────────────────────────
  @Common.label:  'Carrier URL'
  @UI.fieldGroup: [{ qualifier: 'FlightInfo', position: 20 }]
  sc.url,

  "══════════════════════════════════════════════════════════════════════
  " ROUTE INFORMATION  (from SPFLI association)
  " Demo point: association navigation — sc.carrname, sp.cityfrom etc.
  "══════════════════════════════════════════════════════════════════════

  @Common.label:  'Departure City'
  @UI.lineItem:   [{ position: 50, label: 'From' }]
  @UI.fieldGroup: [{ qualifier: 'RouteData', position: 10 }]
  sp.cityfrom,

  @Common.label:  'Arrival City'
  @UI.lineItem:   [{ position: 60, label: 'To' }]
  @UI.fieldGroup: [{ qualifier: 'RouteData', position: 20 }]
  sp.cityto,

  @Common.label:  'Departure Airport'
  @UI.fieldGroup: [{ qualifier: 'RouteData', position: 30 }]
  sp.airpfrom,

  @Common.label:  'Arrival Airport'
  @UI.fieldGroup: [{ qualifier: 'RouteData', position: 40 }]
  sp.airpto,

  @Common.label:  'Distance (km)'
  @UI.fieldGroup: [{ qualifier: 'RouteData', position: 50 }]
  sp.distance,

  "══════════════════════════════════════════════════════════════════════
  " AIRCRAFT
  "══════════════════════════════════════════════════════════════════════

  @Common.label:      'Plane Type'
  @UI.lineItem:       [{ position: 70, label: 'Aircraft', importance: #HIGH }]
  @UI.identification: [{ position: 30 }]
  @UI.fieldGroup:     [{ qualifier: 'GeneralData', position: 20 }]
  sf.planetype,

  "══════════════════════════════════════════════════════════════════════
  " PRICING
  " Demo point: criticality colouring on price column
  "   3 = Positive (green)  — affordable
  "   2 = Critical  (amber) — mid-range
  "   1 = Negative  (red)   — expensive
  "══════════════════════════════════════════════════════════════════════

  @Common.label:      'Base Price'
  @Semantics.amount.currencyCode: 'currency'
  @UI.lineItem:       [{ position: 80,  label: 'Price',
                         importance: #MEDIUM,
                         criticality: 'PriceCriticality',
                         criticalityRepresentation: #WITH_ICON }]
  @UI.identification: [{ position: 40 }]
  @UI.fieldGroup:     [{ qualifier: 'GeneralData', position: 30 }]
  sf.price,

  "── Currency code (hidden — used as semantic reference only) ──────────
  @Semantics.currencyCode: true
  @UI.hidden: true
  sf.currency,

  "── Total revenue = price × occupied seats ───────────────────────────
  "   Demo point: computed field in CDS projection
  @Common.label:      'Total Revenue'
  @Semantics.amount.currencyCode: 'currency'
  @UI.lineItem:       [{ position: 90, label: 'Total Revenue',
                         importance: #LOW }]
  @UI.identification: [{ position: 50 }]
  @UI.fieldGroup:     [{ qualifier: 'GeneralData', position: 40 }]
  sf.price * sf.seatsocc as TotalRevenue,

  sf.paymentsum,

  "══════════════════════════════════════════════════════════════════════
  " ECONOMY CLASS SEATS
  "══════════════════════════════════════════════════════════════════════

  "── Seat summary for Object Page header ──────────────────────────────
  @Common.label:  'Max Economy Seats'
  @UI.fieldGroup: [{ qualifier: 'SeatSummary',  position: 10 },
                   { qualifier: 'EconomySeats', position: 10 }]
  sf.seatsmax,

  @Common.label:  'Economy Occupied'
  @UI.lineItem:   [{ position: 100, label: 'Eco. Occ.',
                     importance: #LOW }]
  @UI.fieldGroup: [{ qualifier: 'SeatSummary',  position: 20 },
                   { qualifier: 'EconomySeats', position: 20 }]
  sf.seatsocc,

  "══════════════════════════════════════════════════════════════════════
  " BUSINESS CLASS SEATS
  "══════════════════════════════════════════════════════════════════════

  @Common.label:  'Business Max'
  @UI.fieldGroup: [{ qualifier: 'BusinessSeats', position: 10 }]
  sf.seatsmax_b,

  @Common.label:  'Business Occupied'
  @UI.fieldGroup: [{ qualifier: 'BusinessSeats', position: 20 }]
  sf.seatsocc_b,

  "══════════════════════════════════════════════════════════════════════
  " FIRST CLASS SEATS
  "══════════════════════════════════════════════════════════════════════

  @Common.label:  'First Class Max'
  @UI.fieldGroup: [{ qualifier: 'FirstClassSeats', position: 10 }]
  sf.seatsmax_f,

  @Common.label:  'First Class Occupied'
  @UI.fieldGroup: [{ qualifier: 'FirstClassSeats', position: 20 }]
  sf.seatsocc_f,

  "══════════════════════════════════════════════════════════════════════
  " COMPUTED / HELPER FIELDS
  " These are hidden from the UI but referenced by annotations above
  "══════════════════════════════════════════════════════════════════════

  "── Price criticality (referenced by @UI.lineItem.criticality above) ─
  "   Demo point: CASE expression driving column colour in the list
  @UI.hidden: true
  case
    when sf.price <= 500  then 3   "-- Positive  (green)  affordable
    when sf.price <= 1000 then 2   "-- Critical  (amber)  mid-range
    else                       1   "-- Negative  (red)    expensive
  end as PriceCriticality,

  "── Occupancy percentage (used by @UI.dataPoint below) ───────────────
  @UI.hidden: true
  division( sf.seatsocc * 100, sf.seatsmax, 0 ) as OccupancyPct,

  "── Occupancy criticality ─────────────────────────────────────────────
  "   Demo point: business rule expressed in CDS drives header KPI colour
  @UI.hidden: true
  case
    when sf.seatsmax = 0                              then 0   "-- Neutral
    when sf.seatsocc * 100 / sf.seatsmax >= 80        then 3   "-- Positive (green) well-booked
    when sf.seatsocc * 100 / sf.seatsmax >= 50        then 2   "-- Critical (amber) filling
    else                                                   1   "-- Negative (red)   underbooked
  end as OccupancyCriticality,

  "══════════════════════════════════════════════════════════════════════
  " DATA POINTS  (referenced in header facets via #DATAPOINT_REFERENCE)
  " Demo point: @UI.dataPoint.visualization = #PROGRESS shows a
  "             progress bar KPI in the Object Page header area
  "══════════════════════════════════════════════════════════════════════

  "── Seat occupancy progress bar ───────────────────────────────────────
  @UI.dataPoint #OccupancyDP: {
    value:         'OccupancyPct',
    title:         'Seat Occupancy %',
    targetValue:    100,
    visualization: #PROGRESS,
    criticality:   'OccupancyCriticality'
  }
  @UI.hidden: true
  division( sf.seatsocc * 100, sf.seatsmax, 0 ) as OccupancyPctDP,

  "══════════════════════════════════════════════════════════════════════
  " ASSOCIATION EXPOSURE
  " Demo point: exposing _Bookings allows $expand in OData calls
  "   e.g. /FlightSet?$expand=_Bookings
  "══════════════════════════════════════════════════════════════════════
  _Bookings
}
