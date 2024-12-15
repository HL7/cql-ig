library CQLExample

using FHIR version '4.0.1'

include FHIRHelpers version '2.0.0-ballot'

codesystem LOINC: 'http://loinc.org'
code "Blood Glucose": '2339-0' from LOINC display 'Glucose Bld-mCnc'

parameter GlucoseThreshold Quantity

context Patient

define "Blood Glucose Observations":
  [Observation: "Blood Glucose"] BG
    where BG.value > GlucoseThreshold

define fluent function birthsex(patient Patient):
  (singleton from (
    patient.extension E where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'
  )).value as FHIR.code

define "Patient Birth Sex Is Male (refined)":
  Patient P
    where P.birthsex() = 'M'