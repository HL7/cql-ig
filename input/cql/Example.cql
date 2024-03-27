library Example

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

codesystem LOINC: 'http://loinc.org'
codesystem "CDC Race and Ethnicity Codes": 'urn:oid:2.16.840.1.113883.6.238'

valueset "Antithrombotic Therapy": 'http://example.org/fhir/ValueSet/antithrombotic-therapy-example'
valueset "Medical Reason": 'http://example.org/fhir/ValueSet/medical-reason-example'

code "Blood Pressure": '85354-9' from LOINC
code "Diastolic blood pressure": '8462-4' from "LOINC" display 'Diastolic blood pressure'
code "Systolic blood pressure": '8480-6' from "LOINC" display 'Systolic blood pressure'
code "American Indian or Alaska Native": '1002-5' from "CDC Race and Ethnicity Codes"
code "Alaska Native": '1735-0' from "CDC Race and Ethnicity Codes"

codesystem "Antenatal Care Concepts": 'http://example.org/fhir/CodeSystem/anc-codes-example'
codesystem "ICD-11": 'http://hl7.org/fhir/sid/icd-11'

code "Tiredness Code": 'ANC.B5.DE40' from "Antenatal Care Concepts" display 'Tiredness'
code "MB22.7": 'MB22.7' from "ICD-11" display 'Tiredness'

concept "Tiredness": { "Tiredness Code", "MB22.7" } display 'Tiredness'

context Patient

define X:
  @2014-01-01 30 days or less before Today()

define "Blood Pressure Observations Within 30 Days":
  [Observation: "Blood Pressure"] O
    where O.status = 'final'
      and (
        (O.effective as dateTime).value 30 days or less before Today()
          or (O.effective as Period) starts 30 days or less before Today()
      )

define fluent function toInterval(choice Choice<FHIR.dateTime, FHIR.Period>):
  case
    when choice is FHIR.dateTime then
      Interval[FHIRHelpers.ToDateTime(choice as FHIR.dateTime), FHIRHelpers.ToDateTime(choice as FHIR.dateTime)]
    when choice is FHIR.Period then
      FHIRHelpers.ToInterval(choice as FHIR.Period)
    else null as Interval<DateTime>
  end

define "Blood Pressure Observations Within 30 Days (refined)":
  [Observation: "Blood Pressure"] O
    where O.status = 'final'
      and O.effective.toInterval() starts 30 days or less before Today()

define "Blood Pressure With Slices":
  [Observation: "Blood Pressure"] BP
    where (singleton from (BP.component C where C.code ~ "Systolic blood pressure")).value < 140 'mm[Hg]'
      and (singleton from (BP.component C where C.code ~ "Diastolic blood pressure")).value < 90 'mm[Hg]'

define fluent function systolic(observation Observation):
  singleton from (observation.component C where C.code ~ "Systolic blood pressure")

define fluent function diastolic(observation Observation):
  singleton from (observation.component C where C.code ~ "Diastolic blood pressure")

define "Blood Pressure With Slices (refined)":
  [Observation: "Blood Pressure"] BP
    where BP.systolic().value < 140 'mm[Hg]'
      and BP.diastolic().value < 90 'mm[Hg]'

define "Patient Birth Sex Is Male":
  Patient P
    let birthsex: singleton from (
        P.extension E where E.url.value = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'
    ).value as FHIR.code
    where birthsex = 'M'

define fluent function birthsex(patient Patient):
  (singleton from (patient.extension E where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex')).value as FHIR.code

define "Patient Birth Sex Is Male (refined)":
  Patient P
    where P.birthsex() = 'M'

define "Patient With Race Category":
  Patient P
    let
      race: singleton from (
        P.extension E where E.url.value = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'
      ),
      ombCategory: race.extension E where E.url.value = 'ombCategory',
      detailed: race.extension E where E.url.value = 'detailed'
    where (ombCategory O return O.value as FHIR.Coding) contains "American Indian or Alaska Native"
      and (detailed O return O.value as FHIR.Coding) contains "Alaska Native"
    
define fluent function race(patient Patient):
  (singleton from (patient.extension E where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race')) race
    let 
      ombCategory: race.extension E where E.url = 'ombCategory' return E.value as Coding,
      detailed: race.extension E where E.url = 'detailed' return E.value as Coding,
      text: singleton from (race.extension E where E.url = 'text' return E.value as string)
    return { ombCategory: ombCategory, detailed: detailed, text: text }

define "Patient With Race Category (refined)":
  Patient P
    where P.race().ombCategory contains "American Indian or Alaska Native"
      and P.race().detailed contains "Alaska Native"

define "Antithrombotic Not Administered":
  [MedicationAdministration: "Antithrombotic Therapy"] NotAdministered
    where NotAdministered.status = 'not-done'
      and NotAdministered.statusReason in "Medical Reason"

define "Antithrombotic Class Not Administered":
  [MedicationAdministration] NotAdministered
    where NotAdministered.medication.notDoneValueSet() = "Antithrombotic Therapy".id
      and NotAdministered.status = 'not-done'
      and NotAdministered.statusReason in "Medical Reason"

define fluent function notDoneValueSet(element Element):
  (singleton from (element.extension E where E.url = 'http://hl7.org/fhir/StructureDefinition/cqf-notDoneValueSet')).value as uri

define fluent function notDoneValueSet(element Choice<CodeableConcept, Reference>):
  case
    when element is CodeableConcept then (element as CodeableConcept).notDoneValueSet()
    when element is Reference then (element as Reference).notDoneValueSet()
    else null
  end

define "Antithrombotics Not Administered":
  "Antithrombotic Not Administered"
    union "Antithrombotic Class Not Administered"
