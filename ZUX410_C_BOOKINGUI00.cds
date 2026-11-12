*&---------------------------------------------------------------------*
*& CDS View  : ZUX410_C_BOOKINGUI00  (Enhanced for Demo — Session 3)
*& Purpose   : Fiori Elements sub-entity — Bookings per flight
*& Covers    : @UI.headerInfo, @UI.lineItem, @UI.identification,
*&             @UI.selectionField, @UI.fieldGroup, @UI.facet,
*&             criticality, @Common.label
*&---------------------------------------------------------------------*

@AbapCatalog.sqlViewName:            'ZUX410BOOKING00'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck:   #CHECK
@EndUserText.label:                  'UX410 Bookings – Enhanced'

"──────────────────────────────────────────────────────────────────────
" HEADER INFO — drives the Booking Object Page title
"──────────────────────────────────────────────────────────────────────
@UI.headerInfo.typeName:          'Booking'
@UI.headerInfo.typeNamePlural:    'Bookings'
@UI.headerInfo.title.value:       'bookid'
@UI.headerInfo.description.value: 'passname'

@Search.searchable: true

define view ZUX410_C_BOOKINGUI00 as select from sbook {

  "══════════════════════════════════════════════════════════════════════
  " FACET STRUCTURE
  " Object Page body for a Booking record
  " ├── HEADER FieldGroup : booking summary (id, passenger, status)
  " ├── Body Section 1 'Passenger Details' (Collection)
  " │   └── Passenger FieldGroup
  " ├── Body Section 2 'Flight Details'   (Collection)
  " │   └── Flight Reference FieldGroup
  " └── Body Section 3 'Payment'          (Collection)
  "     └── Payment FieldGroup
  "══════════════════════════════════════════════════════════════════════
  @UI.facet: [
    "── Header ─────────────────────────────────────────────────────────
    { purpose: #HEADER, type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'BookingSummary', position: 10,
      label: 'Booking Summary' },

    "── Body sections ───────────────────────────────────────────────────
    { id: 'PassengerSection', purpose: #STANDARD, type: #COLLECTION,
      label: 'Passenger Details', position: 10 },
    { id: 'FlightRefSection', purpose: #STANDARD, type: #COLLECTION,
      label: 'Flight Reference',  position: 20 },
    { id: 'PaymentSection',   purpose: #STANDARD, type: #COLLECTION,
      label: 'Payment',           position: 30 },

    "── Children of PassengerSection ────────────────────────────────────
    { id: 'PassengerFacet', parentId: 'PassengerSection',
      purpose: #STANDARD, type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'PassengerData', position: 10,
      label: 'Passenger' },

    "── Children of FlightRefSection ────────────────────────────────────
    { id: 'FlightRefFacet', parentId: 'FlightRefSection',
      purpose: #STANDARD, type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'FlightRefData', position: 10,
      label: 'Flight Reference' },

    "── Children of PaymentSection ──────────────────────────────────────
    { id: 'PaymentFacet', parentId: 'PaymentSection',
      purpose: #STANDARD, type: #FIELDGROUP_REFERENCE,
      targetQualifier: 'PaymentData', position: 10,
      label: 'Payment Details' }
  ]

  "══════════════════════════════════════════════════════════════════════
  " KEY FIELDS  (composite key: flight + booking ID)
  "══════════════════════════════════════════════════════════════════════

  "── Suppress client in UI ─────────────────────────────────────────────
  @UI.hidden: true
  key mandt,

  @Common.label:  'Airline'
  @UI.hidden:     true
  key carrid,

  @Common.label:  'Flight No.'
  @UI.hidden:     true
  key connid,

  @Common.label:      'Flight Date'
  @UI.lineItem:       [{ position: 20, label: 'Flight Date' }]
  @UI.identification: [{ position: 30 }]
  @UI.selectionField: [{ position: 30 }]
  @UI.fieldGroup:     [{ qualifier: 'FlightRefData', position: 20 }]
  key fldate,

  @Common.label:      'Booking ID'
  @UI.lineItem:       [{ position: 10, label: 'Booking No.' }]
  @UI.identification: [{ position: 10 }]
  @UI.fieldGroup:     [{ qualifier: 'BookingSummary', position: 10 }]
  key bookid,

  "══════════════════════════════════════════════════════════════════════
  " PASSENGER DETAILS
  "══════════════════════════════════════════════════════════════════════

  @Common.label:      'Passenger Name'
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold:   0.7
  @UI.lineItem:       [{ position: 10, label: 'Passenger', importance: #HIGH }]
  @UI.identification: [{ position: 20 }]
  @UI.selectionField: [{ position: 10 }]
  @UI.fieldGroup:     [{ qualifier: 'PassengerData',  position: 10 },
                       { qualifier: 'BookingSummary', position: 20 }]
  passname,

  @Common.label:  'Title'
  @UI.fieldGroup: [{ qualifier: 'PassengerData', position: 20 }]
  passform,

  @Common.label:  'Date of Birth'
  @UI.fieldGroup: [{ qualifier: 'PassengerData', position: 30 }]
  passbirth,

  @Common.label:      'Customer ID'
  @UI.lineItem:       [{ position: 30, label: 'Customer ID', importance: #LOW }]
  @UI.identification: [{ position: 40 }]
  @UI.fieldGroup:     [{ qualifier: 'PassengerData', position: 40 }]
  customid,

  @Common.label:  'Customer Type'
  @UI.fieldGroup: [{ qualifier: 'PassengerData', position: 50 }]
  custtype,

  "══════════════════════════════════════════════════════════════════════
  " BOOKING ATTRIBUTES
  "══════════════════════════════════════════════════════════════════════

  "── Travel class — criticality shows class tier ───────────────────────
  "   Demo point: criticality colouring in a list column
  @Common.label:      'Class'
  @UI.lineItem:       [{ position: 50, label: 'Class',
                         criticality: 'ClassCriticality',
                         criticalityRepresentation: #WITH_ICON }]
  @UI.selectionField: [{ position: 20 }]
  @UI.identification: [{ position: 50 }]
  @UI.fieldGroup:     [{ qualifier: 'BookingSummary', position: 30 }]
  class,

  @Common.label:      'Booking Date'
  @UI.lineItem:       [{ position: 40, label: 'Order Date', importance: #MEDIUM }]
  @UI.identification: [{ position: 60 }]
  @UI.fieldGroup:     [{ qualifier: 'FlightRefData', position: 30 }]
  order_date,

  @Common.label:  'Smoker'
  @UI.fieldGroup: [{ qualifier: 'PassengerData', position: 60 }]
  smoker,

  @Common.label:  'Luggage Weight'
  @UI.lineItem:   [{ position: 60, label: 'Luggage (kg)', importance: #LOW }]
  @UI.fieldGroup: [{ qualifier: 'PassengerData', position: 70 }]
  luggweight,

  @Common.label:  'Weight Unit'
  @UI.hidden:     true
  wunit,

  @Common.label:  'Invoice'
  @UI.fieldGroup: [{ qualifier: 'PaymentData', position: 40 }]
  invoice,

  "══════════════════════════════════════════════════════════════════════
  " FLIGHT REFERENCE
  "══════════════════════════════════════════════════════════════════════

  @Common.label:  'Counter ID'
  @UI.fieldGroup: [{ qualifier: 'FlightRefData', position: 40 }]
  counter,

  @Common.label:  'Agency Number'
  @UI.fieldGroup: [{ qualifier: 'FlightRefData', position: 50 }]
  agencynum,

  @Common.label:  'Cancelled'
  @UI.lineItem:   [{ position: 70, label: 'Cancelled',
                     criticality: 'CancelledCriticality',
                     criticalityRepresentation: #WITH_ICON }]
  @UI.fieldGroup: [{ qualifier: 'BookingSummary', position: 40 }]
  cancelled,

  @Common.label:  'Reserved'
  @UI.fieldGroup: [{ qualifier: 'FlightRefData', position: 60 }]
  reserved,

  "══════════════════════════════════════════════════════════════════════
  " PAYMENT
  "══════════════════════════════════════════════════════════════════════

  @Common.label:      'Local Amount'
  @Semantics.amount.currencyCode: 'loccurkey'
  @UI.lineItem:       [{ position: 30, label: 'Amount', importance: #MEDIUM }]
  @UI.identification: [{ position: 70 }]
  @UI.fieldGroup:     [{ qualifier: 'PaymentData', position: 10 }]
  loccuram,

  @Common.label:  'Local Currency'
  @Semantics.currencyCode: true
  @UI.hidden:     true
  loccurkey,

  @Common.label:  'Foreign Amount'
  @Semantics.amount.currencyCode: 'forcurkey'
  @UI.fieldGroup: [{ qualifier: 'PaymentData', position: 20 }]
  forcuram,

  @Common.label:  'Foreign Currency'
  @Semantics.currencyCode: true
  @UI.hidden:     true
  forcurkey,

  "══════════════════════════════════════════════════════════════════════
  " COMPUTED / HELPER FIELDS
  " Demo point: hidden computed fields driving criticality and icons
  "══════════════════════════════════════════════════════════════════════

  "── Class criticality: 3=First (green)  2=Business (amber)  1=Economy ─
  @UI.hidden: true
  case class
    when 'F' then 3   "-- Positive (green)  First Class
    when 'C' then 2   "-- Critical (amber)  Business Class
    else          1   "-- Negative (red)    Economy
  end as ClassCriticality,

  "── Cancelled criticality: red if cancelled, green if active ──────────
  @UI.hidden: true
  case cancelled
    when 'X' then 1   "-- Negative (red)    Booking cancelled
    else          3   "-- Positive (green)  Active booking
  end as CancelledCriticality

}
