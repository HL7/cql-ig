library FHIRCommonTests

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'
include FHIRCommon

context Patient

//* _01_ define fluent function toInterval(choice Choice<FHIR.dateTime, FHIR.Period, FHIR.Timing, FHIR.instant, FHIR.string, FHIR.Age, FHIR.Range>):
define _01_TestToInterval1:
  exists (
    [Condition] C
        where C.id = 'appendicitis-example'
          and C.onset.toInterval() = Interval[@2012-05-24T00:00:00+00:00, @2012-05-24T00:00:00+00:00]
  )

define _01_TestToInterval2:
  exists (
    [Condition] C
        where C.id = 'hc1'
          and C.onset.toInterval() = Interval[@2007-12-14T, @2007-12-14T]
  )

//* _02_ define fluent function hasStart(period Interval<DateTime>):
define _02_TestHasStart1:
  Patient.identifier.where(use = 'usual').single().period.hasStart() is true

define _02_TestHasStart2:
  Patient.name.where(use = 'maiden').single().period.hasStart() is false

//* _03_ define fluent function hasEnd(period Interval<DateTime>):
define _03_TestHasEnd1:
  Patient.identifier.where(use = 'usual').single().period.hasEnd() is false

define _03_TestHasEnd2:
  Patient.name.where(use = 'maiden').single().period.hasEnd() is true

//* _04_ define fluent function latest(choice Choice<FHIR.dateTime, FHIR.Period, FHIR.Age, FHIR.Range> ):
define private _04_TestLatest1:
  Patient.identifier.where(use = 'usual').single().period.latest() = @2001-05-06T

define _04_TestLatest2:
  Patient.name.where(use = 'maiden').single().period.latest() = @2002T

//* _05_ define fluent function earliest(choice Choice<FHIR.dateTime, FHIR.Period, FHIR.Age, FHIR.Range> ):
define _05_TestEarliest1:
  Patient.identifier.where(use = 'usual').single().period.earliest() = @2001-05-06T

define _05_TestEarliest2:
  Patient.name.where(use = 'maiden').single().period.earliest() = @2002T

//* _06_ define fluent function references(reference FHIR.Reference, resource FHIR.Resource):
// MedicationRequest/example medication references Medication/example
define _06_TestReferences:
  exists (
    [MedicationRequest] MR
      with [Medication] M such that MR.medication.references(M)
      where MR.id = 'example'
  )

//* _07_ define fluent function references(reference FHIR.Reference, resourceId String):
// MedicationRequest/example medication references Medication/example
define _07_TestReferences:
  exists (
    [MedicationRequest] MR
      with [Medication] M such that MR.medication.references(M.id)
      where MR.id = 'example'
  )

//* _08_ define fluent function references(references List<FHIR.Reference>, resource FHIR.Resource):
// Encounter/example diagnosis references Condition/appendicitis-example
define _08_TestReferences:
  exists (
    [Encounter] E
      with [Condition] C such that E.diagnosis.condition.references(C)
      where E.id = 'example'
  )

//* _09_ define fluent function references(references List<FHIR.Reference>, resourceId String):
// Encounter/example diagnosis references Condition/appendicitis-example
define _09_TestReferences:
  exists (
    [Encounter] E
      with [Condition] C such that E.diagnosis.condition.references(C.id)
      where E.id = 'example'
  )

//* _10_ define fluent function includesCode(codeList List<CodeableConcept>, code Concept):
// MedicationRequest/negation-example category includesCode community
define _10_TestIncludesCode:
  exists (
    [MedicationRequest] MR
      where MR.id = 'negation-example'
        and MR.category.includesCode(FHIRCommon.Community)
  )

//* _11_ define fluent function codeOptions(code CodeableConcept):
// MedicationRequest/negation-example medication codeOptions = 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.201'
define _11_TestCodeOptions:
  exists (
    [MedicationRequest] MR
      where MR.id = 'negation-example'
        and MR.medication.codeOptions() = 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.201'
  )

//* _12_ define fluent function url(canonical FHIR.canonical):
define _12_TestGetCanonicalURLFromVersionless: (FHIR.canonical { value: 'http://example.org/ValueSet/ABC' }).url() = 'http://example.org/ValueSet/ABC'
define _12_TestGetCanonicalURLFromVersioned: (FHIR.canonical { value: 'http://example.org/ValueSet/ABC|123' }).url() = 'http://example.org/ValueSet/ABC'

//* _13_ define fluent function version(canonical FHIR.canonical):
define _13_TestGetCanonicalVersionFromVersionless: (FHIR.canonical { value: 'http://example.org/ValueSet/ABC' }).version() is null
define _13_TestGetCanonicalVersionFromVersioned: (FHIR.canonical { value: 'http://example.org/ValueSet/ABC|123' }).version() = '123'

//* _14_ define fluent function exts(domainResource DomainResource, url String):
define _14_TestExts:
  exists (Patient.exts('http://hl7.org/fhir/us/core/StructureDefinition/uscore-ethnicity'))

//* _15_ define fluent function ext(domainResource DomainResource, url String):
define _15_TestExt:
  Patient.ext('http://hl7.org/fhir/us/core/StructureDefinition/uscore-ethnicity') is not null

//* _16_ define fluent function exts(element Element, url String):
define _16_TestExts:
  exists (Patient.birthDate.exts('http://hl7.org/fhir/StructureDefinition/patient-birthTime'))

//* _17_ define fluent function ext(element Element, url String):
define _17_TestExt:
  Patient.birthDate.ext('http://hl7.org/fhir/StructureDefinition/patient-birthTime') is not null

//* _18_ define fluent function modifierExts(domainResource DomainResource, url String):
define _18_TestModifierExts:
  exists (
    [Communication] C
        where C.id = 'negation-example'
        and exists (C.modifierExts('http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-notDone'))
  )    

//* _19_ define fluent function modifierExt(domainResource DomainResource, url String):
define _19_TestModifierExt:
  exists (
    [Communication] C
        where C.id = 'negation-example'
        and C.modifierExt('http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-notDone') is not null
  )    

// TODO: Need modifier extension on backbond element examples
//* _20_ define fluent function modifierExts(element BackboneElement, url String):
//* _21_ define fluent function modifierExt(element BackboneElement, url String):

// TODO: Failing in Java engine: https://github.com/cqframework/clinical_quality_language/issues/1559
//* _21A_ define fluent function birthTime(patient Patient):
define _21A_TestBirthTime:
  Patient.birthTime() = @1974-12-25T14:35:45-05:00

// TODO: Failing in Java engine: https://github.com/cqframework/clinical_quality_language/issues/1559
//* _21B_ define fluent function birthDateTime(patient Patient):
define _21B_TestBirthDateTime:
  Patient.birthDateTime() = @1974-12-25T14:35:45-05:00

//* _22_ define fluent function hasCategory(condition FHIR.Condition, category Code):
define _22_TestHasCategory:
  exists (
    [Condition] C
      where C.id = 'example'
        and C.hasCategory(FHIRCommon."problem-list-item")
  )

//* _23_ define fluent function isProblemListItem(condition FHIR.Condition):
define _23_TestIsProblemListItem:
  exists (
    [Condition] C
      where C.id = 'example'
        and C.isProblemListItem()
  )

//* _24_ define fluent function isEncounterDiagnosis(condition FHIR.Condition):
define _24_TestIsEncounterDiagnosis:
  exists (
    [Condition] C
      where C.id = 'appendicitis-example'
        and C.isEncounterDiagnosis()
  )

//* _25_ define fluent function abatementInterval(condition Condition):
define _25_TestAbatementInterval:
  exists (
    [Condition] C
      where C.id = 'example'
        and end of C.abatementInterval() is null
  )

//* _26_ define fluent function prevalenceInterval(condition Condition):
define _26_TestPrevalenceInterval:
  exists (
    [Condition] C
      where C.id = 'example'
       and C.prevalenceInterval() = Interval[@2012-05-24T00:00:00+00:00, null]
  ) 

//* _27_ define fluent function isActive(condition FHIR.Condition):
define _27_TestIsActive:
  exists (
    [Condition] C
      where C.id = 'example'
        and C.isActive()
  )
    
//* _28_ define fluent function active(conditions List<FHIR.Condition>):
define _28_TestActive:
  exists (
    [Condition] C
      where C.id = 'example'
  ).active()

//* _28A_ define fluent function isVerified(condition FHIR.Condition):
define _28A_TestIsVerified:
  exists (
    [Condition] C
      where C.id = 'example'
        and C.isVerified()
  )

//* _28B_ define fluent function verified(conditions List<FHIR.Condition>):
define _28B_TestVerified:
  exists (
    [Condition] C
      where C.id = 'example'
  ).verified()

//* _29_ define fluent function isUnconfirmed(condition FHIR.Condition):
define _29_TestIsUnconfirmed:
  not exists (
    [Condition] C
      where C.id = 'example'
        and C.isUnconfirmed()
  ) 

//* _30_ define fluent function unconfirmed(conditions List<FHIR.Condition>):
define _30_TestUncomfirmed:
  not exists (
    [Condition] C
      where C.id = 'example'
  ).unconfirmed()

//* _31_ define fluent function isProvisional(condition FHIR.Condition):
define _31_TestIsProvisional:
  not exists (
    [Condition] C
      where C.id = 'example'
        and C.isProvisional()
  ) 

//* _32_ define fluent function provisional(conditions List<FHIR.Condition>):
define _32_TestProvisional:
  not exists (
    [Condition] C
      where C.id = 'example'
  ).provisional()

//* _33_ define fluent function isDifferential(condition FHIR.Condition):
define _33_TestIsDifferential:
  not exists (
    [Condition] C
      where C.id = 'example'
        and C.isDifferential()
  ) 

//* _34_ define fluent function differential(conditions List<FHIR.Condition>):
define _34_TestDifferential:
  not exists (
    [Condition] C
      where C.id = 'example'
  ).differential() 

//* _35_ define fluent function isConfirmed(condition FHIR.Condition):
define _35_TestIsConfirmed:
  exists (
    [Condition] C
      where C.id = 'example'
        and C.isConfirmed()
  ) 

//* _36_ define fluent function confirmed(conditions List<FHIR.Condition>):
define _36_TestConfirmed:
  exists (
    [Condition] C
      where C.id = 'example'
  ).confirmed() 

//* _37_ define fluent function isRefuted(condition FHIR.Condition):
define _37_TestIsRefuted:
  not exists (
    [Condition] C
      where C.id = 'example'
        and C.isRefuted()
  ) 

//* _38_ define fluent function refuted(conditions List<FHIR.Condition>):
define _38_TestRefuted:
  not exists (
    [Condition] C
      where C.id = 'example'
  ).refuted() 

//* _38A_ define fluent function abatement(allergyIntolerance FHIR.AllergyIntolerance):
define _38A_TestAbatement:
  not exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.abatement() is not null
  )

//* _38B_ define fluent function resolutionAge(allergyIntolerance FHIR.AllergyIntolerance):
define _38B_TestResolutionAge:
  not exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.resolutionAge() is not null
  )

//* _38C_ define fluent function abatementInterval(allergyIntolerance AllergyIntolerance):
define _38C_TestAbatementInterval:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.abatementInterval() is null
  )

//* _38D_ define fluent function prevalenceInterval(allergyIntolerance AllergyIntolerance):
define _38D_TestPrevalenceInterval:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.prevalenceInterval() starts before @2015
  )

//* _39_ define fluent function isActive(allergyIntolerance FHIR.AllergyIntolerance):
define _39_TestIsActive:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.isActive()
  )

//* _40_ define fluent function active(allergyIntolerances List<FHIR.AllergyIntolerance>):
define _40_TestActive:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example'
  ).active()

//* _41_ define fluent function isInactive(allergyIntolerance FHIR.AllergyIntolerance):
define _41_TestIsInactive:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example-refuted'
        and A.isInactive()
  )

//* _42_ define fluent function inactive(allergyIntolerances List<FHIR.AllergyIntolerance>):
define _42_TestInactive:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example-refuted'
  ).inactive()
  
//* _43_ define fluent function isResolved(allergyIntolerance FHIR.AllergyIntolerance):
define _43_TestIsResolved:
  not exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.isResolved()
  )

//* _44_ define fluent function resolved(allergyIntolerances List<FHIR.AllergyIntolerance>):
define _44_TestResolved:
  not exists (
    [AllergyIntolerance] A
      where A.id = 'example'
  ).resolved()

//* _44A_ define fluent function isVerified(allergyIntolerance FHIR.AllergyIntolerance):
define _44A_TestIsVerified:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.isVerified()
  )

//* _44B_ define fluent function verified(allergyIntolerances List<FHIR.AllergyIntolerance>):
define _44B_TestVerified:
  exists (
    [AllergyIntolerance] C
      where C.id = 'example'
  ).verified()

//* _45_ define fluent function isConfirmed(allergyIntolerance FHIR.AllergyIntolerance):
define _45_TestIsConfirmed:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.isConfirmed()
  )

//* _46_ define fluent function confirmed(allergyIntolerances List<FHIR.AllergyIntolerance>):
define _46_TestConfirmed:
  exists (
    [AllergyIntolerance] A
      where A.id = 'example'
  ).confirmed()

//* _47_ define fluent function isUnconfirmed(allergyIntolerance FHIR.AllergyIntolerance):
define _47_TestIsUnconfirmed:
  not exists (
    [AllergyIntolerance] A
      where A.id = 'example'
        and A.isUnconfirmed()
  )

//* _48_ define fluent function unconfirmed(allergyIntolerance FHIR.AllergyIntolerance):
define _48_TestUnconfirmed:
  not exists (
    [AllergyIntolerance] A
      where A.id = 'example'
  ).unconfirmed()

//* _49_ define fluent function isRefuted(allergyIntolerance FHIR.AllergyIntolerance):
define _49_TestIsRefuted:
  not exists (
    [AllergyIntolerance] A
      where A.id = 'example-refuted'
        and A.isRefuted()
  )

//* _50_ define fluent function refuted(allergyIntolerances FHIR.AllergyIntolerance):
define _50_TestRefuted:
  not exists (
    [AllergyIntolerance] A
      where A.id = 'example'
  ).refuted()

//* _51_ define fluent function hasCategory(observation FHIR.Observation, category Code):
define _51_TestHasCategory:
  exists (
    [Observation] O
      where O.id = 'some-day-smoker'
        and O.hasCategory(FHIRCommon."social-history")
  )

//* _52_ define fluent function isSocialHistory(observation FHIR.Observation):
define _52_TestIsSocialHistory:
  exists (
    [Observation] O
      where O.id = 'some-day-smoker'
        and O.isSocialHistory()
  )

//* _53_ define fluent function isVitalSign(observation FHIR.Observation):
define _53_TestIsVitalSign:
  exists (
    [Observation] O
      where O.id = 'temperature'
        and O.isVitalSign()
  )

//* _54_ define fluent function isImaging(observation FHIR.Observation):
define _54_TestIsImaging:
  not exists (
    [Observation] O
      where O.isImaging()
  )

//* _55_ define fluent function isLaboratory(observation FHIR.Observation):
define _55_TestIsLaboratory:
  exists (
    [Observation] O
      where O.id = 'blood-glucose'
        and O.isLaboratory()
  )

//* _56_ define fluent function isProcedure(observation FHIR.Observation):
define _56_TestIsProcedure:
  not exists (
    [Observation] O
      where O.id = 'example'
        and O.isProcedure()
  )

//* _57_ define fluent function isSurvey(observation FHIR.Observation):
define _57_TestIsSurvey:
  not exists (
    [Observation] O
      where O.id = 'example'
        and O.isSurvey()
  )
    
//* _58_ define fluent function isExam(observation FHIR.Observation):
define _58_TestIsExam:
  not exists (
    [Observation] O
      where O.id = 'example'
        and O.isExam()
  )
    
//* _59_ define fluent function isTherapy(observation FHIR.Observation):
define _59_TestIsTherapy:
  not exists (
    [Observation] O
      where O.id = 'example'
        and O.isTherapy()
  )
    
//* _60_ define fluent function isActivity(observation FHIR.Observation):
define _60_TestIsActivity:
  not exists (
    [Observation] O
      where O.id = 'example'
        and O.isActivity()
  )
    
//* _61_ define fluent function isResulted(observation FHIR.Observation):
define _61_TestIsResulted:
  exists (
    [Observation] O
      where O.id = 'example'
        and O.isResulted()
  )    

//* _62_ define fluent function resulted(observations List<FHIR.Observation>):
define _62_TestResulted:
  exists (
    [Observation] O
      where O.id = 'example'
  ).resulted()
    
//* _63_ define fluent function isFinal(observation FHIR.Observation):
define _63_TestIsFinal:
  exists (
    [Observation] O
      where O.id = 'example'
        and O.isFinal()
  )

//* _64_ define fluent function final(observations List<FHIR.Observation>):
define _64_TestFinal:
  exists (
    [Observation] O
      where O.id = 'example'
  ).final()
    
//* _65_ define fluent function isAmended(observation FHIR.Observation):
define _65_TestIsAmended:
  not exists (
    [Observation] O
      where O.id = 'example'
        and O.isAmended()
  )
    
//* _66_ define fluent function amended(observations List<FHIR.Observation>):
define _66_TestAmended:
  not exists (
    [Observation] O
      where O.id = 'example'
  ).amended()
    
//* _67_ define fluent function isCorrected(observation FHIR.Observation):
define _67_TestIsCorrected:
  not exists (
    [Observation] O
      where O.id = 'example'
        and O.isCorrected()
  )
    
//* _68_ define fluent function corrected(observations List<FHIR.Observation>):
define _68_TestCorrected:
  not exists (
    [Observation] O
      where O.id = 'example'
  ).corrected()
    
//* _69_ define fluent function isCommunity(medicationRequest MedicationRequest):
define _69_TestIsCommunity:
  exists (
    [MedicationRequest] MR
      where MR.id = 'negation-example'
        and MR.isCommunity()
  )

//* _70_ define fluent function isDischarge(medicationRequest MedicationRequest):
define _70_TestIsDischarge:
  not exists (
    [MedicationRequest] MR
      where MR.id = 'negation-example'
        and MR.isDischarge()
  )

//* _71_ define fluent function hasCategory(medicationRequest MedicationRequest, category Code):
define _71_TestHasCategory:
  exists (
    [MedicationRequest] MR
      where MR.id = 'negation-example'
        and MR.hasCategory(FHIRCommon.Community)
  )

//* _72_ define fluent function mostRecent(conditions List<Condition>):
define _72_TestMostRecent:
  ([Condition]).mostRecent().id = 'example'

//* _73_ define fluent function mostRecent(observations List<FHIR.Observation>):
define _73_TestMostRecent:
  ([Observation]).mostRecent().id = 'some-day-smoker'

//* _73A_ define fluent function mostRecent(procedures List<FHIR.Procedure>):
define _73A_TestMostRecent:
  ([Procedure]).mostRecent().id = 'defib-implant'

//* _74_ define fluent function mostRecent(medicationRequests List<"MedicationRequest">):
define _74_TestMostRecent:
  ([MedicationRequest]).mostRecent().id = 'self-tylenol'

//* _75_ define fluent function mostRecent(serviceRequests List<FHIR.ServiceRequest>):
define _75_TestMostRecent:
  ([ServiceRequest]).mostRecent().id = 'appropriateness-example'

//* _76_ define fluent function toDayNumbers(period Interval<DateTime>):
define _76_TestToDayNumbers:
  (Interval[@2024-01-01, @2024-01-10]).toDayNumbers() = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }

//* _77_ define fluent function daysInPeriod(period Interval<DateTime>):
define _77_TestDaysInPeriod:
  (Interval[@2024-01-01, @2024-01-10]).daysInPeriod() =
  {
    Tuple {
      "dayIndex": 1,
      "dayPeriod": Interval[@2024-01-01T00:00:00.000, @2024-01-02T00:00:00.000)
    }, Tuple {
      "dayIndex": 2,
      "dayPeriod": Interval[@2024-01-02T00:00:00.000, @2024-01-03T00:00:00.000)
    }, Tuple {
      "dayIndex": 3,
      "dayPeriod": Interval[@2024-01-03T00:00:00.000, @2024-01-04T00:00:00.000)
    }, Tuple {
      "dayIndex": 4,
      "dayPeriod": Interval[@2024-01-04T00:00:00.000, @2024-01-05T00:00:00.000)
    }, Tuple {
      "dayIndex": 5,
      "dayPeriod": Interval[@2024-01-05T00:00:00.000, @2024-01-06T00:00:00.000)
    }, Tuple {
      "dayIndex": 6,
      "dayPeriod": Interval[@2024-01-06T00:00:00.000, @2024-01-07T00:00:00.000)
    }, Tuple {
      "dayIndex": 7,
      "dayPeriod": Interval[@2024-01-07T00:00:00.000, @2024-01-08T00:00:00.000)
    }, Tuple {
      "dayIndex": 8,
      "dayPeriod": Interval[@2024-01-08T00:00:00.000, @2024-01-09T00:00:00.000)
    }, Tuple {
      "dayIndex": 9,
      "dayPeriod": Interval[@2024-01-09T00:00:00.000, @2024-01-10T00:00:00.000)
    }  
  }
