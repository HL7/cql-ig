library CQLExample

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

codesystem LOINC: 'http://loinc.org'
code "Blood Glucose": '2339-0' from LOINC display 'Glucose Bld-mCnc'

parameter GlucoseThreshold Quantity

context Patient

define "Blood Glucose Observations":
  [Observation: "Blood Glucose"] BG
    where BG.value > GlucoseThreshold
