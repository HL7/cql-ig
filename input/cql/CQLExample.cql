library CQLExample

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.2-ballot'

codesystem LOINC: 'http://loinc.org'
code "Blood Glucose": '2339-0' from LOINC display 'Glucose Bld-mCnc'

parameter GlucoseThreshold Quantity

context Patient

define "Blood Glucose Observations":
  [Observation: "Blood Glucose"] BG
    where BG.value > GlucoseThreshold

define fluent function interpreterRequired(patient Patient):
  (singleton from (
    patient.extension E where E.url = 'http://hl7.org/fhir/StructureDefinition/patient-interpreterRequired'
  )).value as FHIR.boolean

define "Patient Interpreter Required (refined)":
  Patient P
    where P.interpreterRequired() is true