library ANCCohort

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.2-ballot'
include FHIRCommon version '3.0.0-ballot'

codesystem "ANCM Concept Codes": 'http://hl7.org/fhir/uv/cql/CodeSystem/example'

code "Pregnancy Confirmed": 'ANC.B4.DE1' from "ANCM Concept Codes" display 'Pregnancy Confirmed'

define "Is Antenatal Care Applicable":
  "Is Pregnancy Confirmed" is true


/* Copied from ANCMContactDataElements */
/*
  @dataElement: ANC.B4.DE1 Pregnancy Confirmed
  @activity: ANC.B4 Confirm pregnancy
  @description: Pregnancy has been confirmed
*/
define "Is Pregnancy Confirmed":
  ([Observation: "Pregnancy Confirmed"]).resulted().mostRecent().value as boolean
