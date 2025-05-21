/*
@description: An example library illustrating the FHIR Type mapping for CQL
*/
library TypeMappingExample

using FHIR version '4.0.1'

include FHIRHelpers version '2.0.0-ballot'

codesystem ExampleCodeSystem: 'http://hl7.org/fhir/uv/cql/CodeSystem/example'
codesystem LOINC: 'http://loinc.org'
valueset ExampleValueSet: 'http://hl7.org/fhir/uv/cql/ValueSet/shareable-example'
code ExampleCode: 'example-code' from ExampleCodeSystem
code BloodGlucose: '2339-0' from LOINC display 'Glucose Bld-mCnc'
concept ExampleConcept: { ExampleCode }

parameter ExampleVocabulary Vocabulary

context Patient

// Example values as output

// CQL Values
// Boolean
define CQLBooleanExample: true
// Code
define CQLCodeExample: ExampleCode
// CodeSystem
define CQLCodeSystemExample: ExampleCodeSystem
// Concept
define CQLConceptExample: ExampleConcept
// Date
define CQLDateExample: @2024-01-01
// DateTime
define CQLDateTimeExample: @2024-01-01T10:30:00Z
// Decimal
define CQLDecimalExample: 10.0
// Long
define CQLLongExample: 10L
// Integer
define CQLIntegerExample: 10
// Quantity
define CQLQuantityExample: 10 'mg'
// Ratio
define CQLRatioExample: 5 'mg' : 10 'mg'
// String
define CQLStringExample: 'John'
// Time
define CQLTimeExample: @T10:30:00
// ValueSet
define CQLValueSetExample: ExampleValueSet
// Vocabulary
define CQLVocabularyExample: ExampleVocabulary
// Interval<Date>
define CQLDateIntervalExample: Interval[@2024-01-01, @2024-01-31]
// Interval<DateTime>
define CQLDateTimeIntervalExample: Interval[@2024-01-01T10:30:00Z, @2024-01-31T10:30:00Z]
// Interval<Time>
define CQLTimeIntervalExample: Interval[@T10:30:00, @T11:30:00]
// Interval<Integer>
define CQLIntegerIntervalExample: Interval[5, 10]
// Interval<Quantity>
define CQLQuantityIntervalExample: Interval[5 'mg', 10 'mg']
// List
define CQLListExample: { 1, 2, 3, 4, 5 }
// Tuple
define CQLTupleExample: { X: 1, Y: 1 }
// ChoiceList
define CQLChoiceListExample: List<Choice<Integer, Decimal>> { 1, 1.0 }
// TupleList
define CQLTupleListExample: { { X: 1, Y: 1 }, { X: 1, Y: 2 }, { X: 1, Y: 3 } }
// ComplexTuple
define CQLComplexTupleExample: { id: 1, name: 'Patrick', address: { { street: '123 Spinning Ave', city: 'Dayton', state: 'OH' } } }
// ComplexTupleList
define CQLComplexTupleListExample: { CQLComplexTupleExample }
// EmptyList
define CQLEmptyListExample: CQLComplexTupleListExample E where false
// ListList
define CQLListListExample: { CQLListExample, CQLListExample }
// EmptyTuple
define CQLEmptyTupleExample: { : }

// FHIR Values
define private FHIRObservations: [Observation]
define private FHIRBloodGlucoseObservation: (FHIRObservations O where O.code ~ BloodGlucose).single()

// boolean
define FHIRBooleanExample: Patient.active
// string
define FHIRStringExample: Patient.name.first().family
// Quantity
define FHIRQuantityExample: FHIRBloodGlucoseObservation.value as FHIR.Quantity
// Period
define FHIRPeriodExample: Patient.address.first().period
// Range
define FHIRRangeExample: FHIRBloodGlucoseObservation O return FHIR.Range { low: O.referenceRange.first().low, high: O.referenceRange.first().high }
// Observation
define FHIRObservationExample: FHIRBloodGlucoseObservation
// List<Observation>
define FHIRObservationListExample: FHIRObservations
// EmptyList<Observation>
define FHIREmptyObservationListExample: FHIRObservations O where false