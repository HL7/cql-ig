{:toc}

{: #patterns}

This topic provides general guidance and best-practices for authors building FHIR-based Knowledge Artifacts that make use of Clinical Quality Language (CQL). The topics provide informative guidance to facilitate authoring CQL directly with the FHIR data model, including support for primitives, choices, slices, and extensions, as well as guidance for dealing with missing information, negation, the use of terminologies in FHIR, and some discussion of profile-informed authoring.

### FHIR Patterns

#### Primitives

As an exchange specification, FHIR has a rich syntax for expressing the values of elements defined in FHIR
resources. In particular, FHIR data types for representing basic values such as integers, strings, and dates and
times allow for [extensions](http://hl7.org/fhir/extensibility.html#extension). This means that a FHIR
`string` is not just a string value, but has elements (specifically, `id`, `extension`, and
`value`, where the `value` element contains the actual string value). This means that to access
the actual value of a FHIR `string` element in CQL, authors would need to reference the `value` element:

```cql
define "Patient is Female":
  Patient.gender.value = 'female'
```
  
To avoid this, a [FHIRHelpers](http://fhir.org/guides/cqf/common/Library-FHIRHelpers.html) library defines implicit conversions for all the FHIR types, allowing authors to treat
FHIR elements as integers, strings, etc. directly:

```cql
define "Patient is Female":
  Patient.gender = 'female'
```

Note that these conversions are performed automatically by the [CQL-to-ELM translator](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md) when they are used by CQL, resulting in a conversion error if the FHIRHelpers library is not included using an [include declaration](https://cql.hl7.org/02-authorsguide.html#libraries):
  
```cql
include FHIRHelpers version '4.0.1'
```

The version of the library is not required by CQL, but for the FHIRHelpers reference, because it is so closely tied to the FHIR ModelInfo, best-practice is to include the version of FHIRHelpers.

#### Choices

FHIR includes the notion of [_choice_](https://hl7.org/fhir/formats.html#choice) types, or elements that can be represented as any of a number of types. For example,
the `Patient.deceased` element can be specified as a `boolean` or as a `dateTime`. CQL also supports [choice](https://cql.hl7.org/03-developersguide.html#choice-types) types, so these elements are represented directly as Choice Types within the Model Info.

When authoring CQL using FHIR, logic must take into account the possible choice types of the elements involved. For example, the `Observation.effective` element may be represented as a `dateTime` or a `Period` (among other types):

```cql
define "Blood Pressure Observations Within 30 Days":
  [Observation: "Blood Pressure"] O
    where O.status = 'final'
      and (
        (O.effective as dateTime).value 30 days or less before Today()
          or (O.effective as Period) starts 30 days or less before Today()
      )
```

Rather than requiring different representations to be considered in the logic each time they are encountered, a [fluent function](https://cql.hl7.org/03-developersguide.html#fluent-functions) can be defined that accepts a choice type argument:

```cql
define fluent function toInterval(choice Choice<FHIR.dateTime, FHIR.Period>):
  case
    when choice is FHIR.dateTime then
      Interval[FHIRHelpers.ToDateTime(choice as FHIR.dateTime), FHIRHelpers.ToDateTime(choice as FHIR.dateTime)]
    when choice is FHIR.Period then
      FHIRHelpers.ToInterval(choice as FHIR.Period)
    else null as Interval<DateTime>
  end
```

This can then be written as:

```cql
define "Blood Pressure Observations Within 30 Days (refined)":
  [Observation: "Blood Pressure"] O
    where O.status = 'final'
      and O.effective.toInterval() starts 30 days or less before Today()
```

#### Slices

Another common pattern in FHIR is the use of [_slices_](https://hl7.org/fhir/profiling.html#slicing) to constrain list-valued elements into sub-lists and elements. Consider the [Blood Pressure](http://hl7.org/fhir/bp.html) that defines "Systolic" and "Diastolic" elements:

```cql
define "Blood Pressure With Slices":
  [Observation: "Blood Pressure"] BP
    where (singleton from (BP.component C where C.code ~ "Systolic blood pressure")).value < 140 'mm[Hg]'
      and (singleton from (BP.component C where C.code ~ "Diastolic blood pressure")).value < 90 'mm[Hg]'
```

To reuse slices, CQL fluent functions can be defined for each slice:

```cql
define fluent function systolic(observation Observation):
  singleton from (observation.component C where C.code ~ "Systolic blood pressure")

define fluent function diastolic(observation Observation):
  singleton from (observation.component C where C.code ~ "Diastolic blood pressure")
```

These fluent functions can then be used to access the slices:

```cql
define "Blood Pressure With Slices (refined)":
  [Observation: "Blood Pressure"] BP
    where BP.systolic().value < 140 'mm[Hg]'
      and BP.diastolic().value < 90 'mm[Hg]'
```

#### Extensions

FHIR also supports defining [_extensions_](https://hl7.org/fhir/extensibility.html) to allow additional information beyond what is available in the base FHIR resources to be specified. Profiles then make use of these extensions to establish how this additional information is exchanged in specific use cases. As a simple example, consider the [birthsex](https://hl7.org/fhir/us/core/StructureDefinition-us-core-patient-definitions.html#Patient.extension:birthsex) extension in US Core:

```cql
define "Patient Birth Sex Is Male":
  Patient P
    let birthsex: singleton from (
        P.extension E where E.url.value = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'
    ).value as FHIR.code
    where birthsex = 'M'
```

In this example, a _let clause_ is used to build a `birthsex` element in the query that finds the birthsex extension value. As with slicing, fluent functions can be used to provide access to extensions:

```cql
define fluent function birthsex(patient Patient):
  (singleton from (
    patient.extension E where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'
  )).value as FHIR.code
```

This function can then be used to easily access the birthsex extension:

```cql
define "Patient Birth Sex Is Male (refined)":
  Patient P
    where P.birthsex() = 'M'
```

As a more complex example, consider the [race](https://hl7.org/fhir/us/core/StructureDefinition-us-core-race.html) extension. This is a complex extension that define elements for `ombCategory`, `detailed`, and `text`:

```cql
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
```

Again, these can be accessed directly using a let clause, or a fluent function can be defined to allow access:

```cql
define fluent function race(patient Patient):
  (singleton from (patient.extension E where E.url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race')) race
    let 
      ombCategory: race.extension E where E.url = 'ombCategory' return E.value as Coding,
      detailed: race.extension E where E.url = 'detailed' return E.value as Coding,
      text: singleton from (race.extension E where E.url = 'text' return E.value as string)
    return { ombCategory: ombCategory, detailed: detailed, text: text }
```

```cql
define "Patient With Race Category (refined)":
  Patient P
    where P.race().ombCategory contains "American Indian or Alaska Native"
      and P.race().detailed contains "Alaska Native"
```

#### FHIRCommon

For common use cases, the [CQF Common](http://fhir.org/guides/cqf/common) implementation guide provides a FHIRCommon library that defines many of these types of functions and declarations that are commonly used with CQL and FHIR. By including a reference to this implementation guide, content IGs can build CQL that refers to these common functions by including the FHIRCommon library:

```cql
include fhir.cqf.common.FHIRCommon
```

### Profile-informed Authoring
{: #profile-informed-authoring}

Note that rather than using FHIR directly, CQL also supports models derived from implementation guides specifically. For example:

```cql
using USCore version '6.1.0'
```

With this approach, the profiles defined in the USCore implementation guide are used to provide the model. This approach is referred to as "profile-informed authoring" and automates the patterns described above, so that rather than building fluent functions, the model contains elements for slices and extensions defined in the profiles of the implementation guide. For example:

```cql
define "Blood Pressure With Slices":
  ["BloodPressureProfile"] BP
    where BP.systolic.value < 140 'mm[Hg]'
      and BP.diastolic.value < 90 'mm[Hg]'

define "Patient With Birthsex":
  Patient P
    where P.birthsex = 'M'

define "Patient With Race":
  Patient P
    where P.race.ombCategory contains "American Indian or Alaska Native"
      and P.race.detailed contains "Alaska Native"
```

For detailed information on how model information is produced for an implementation guide, see the [Profile-informed ModelInfo](using-modelinfo.html#profile-informed-modelinfo) section.

### Use of Terminologies
{: #use-of-terminologies}

FHIR supports various types of terminology-valued elements, including:

* [code](http://hl7.org/fhir/datatypes.html#code)
* [Coding](http://hl7.org/fhir/datatypes.html#Coding)
* [CodeableConcept](http://hl7.org/fhir/datatypes.html#CodeableConcept)

These types map to the following CQL primitive types, respectively:

* [String](https://cql.hl7.org/09-b-cqlreference.html#string-1)
* [Code](https://cql.hl7.org/09-b-cqlreference.html#code-1)
* [Concept](https://cql.hl7.org/09-b-cqlreference.html#concept-1)

In addition to the type of element, FHIR provides the ability to bind these elements to specific codes, in the form of a direct-reference code (fixed constraint to a specific code in a [CodeSystem](http://hl7.org/fhir/codesystem.html)), or a binding to a [ValueSet](http://hl7.org/fhir/valueset.html). These bindings can be different [binding strengths](http://hl7.org/fhir/codesystem-binding-strength.html)

Within CQL, references to terminology code systems, value sets, codes, and concepts are directly supported, and all such usages are declared within CQL libraries, as described in the  [Terminology](https://cql.hl7.org/02-authorsguide.html#terminology) section of the CQL Author's Guide.

When referencing terminology-valued elements within CQL, the following comparison operations are supported:

* [Equal (`=`)](https://cql.hl7.org/09-b-cqlreference.html#equal-3)
* [Equivalent (`~`)](https://cql.hl7.org/09-b-cqlreference.html#equivalent-3)
* [In (`in`)](https://cql.hl7.org/09-b-cqlreference.html#in-valueset)

### Time Valued Quantities
{: #time-valued-quantities}

For time-valued quantities, in addition to the definite duration UCUM units, CQL defines calendar duration keywords to support calendar-based durations and arithmetic. For example, UCUM defines an annum ('a') as 365.25 days, whereas the year ('year') duration in CQL is specifically a calendar year. This difference is important, especially when performing calendar arithmetic.

For example if we take a datetime and subtract a calendar year
```cql
@2019-01-01T05:00:00 - 1 year
```
This would resolve to 2018-01-01T05:00:00

However, if we take the same datetime and subtract a UCUM annum
```cql
@2019-01-01T05:00:00 - 1 'a'
```
This would resolve to 2017-12-31T23:00:00

See the definition of the [Quantity](https://cql.hl7.org/2020May/02-authorsguide.html#quantities) type in the CQL Author's Guide, as well as the [Date/Time Arithmetic](https://cql.hl7.org/2020May/02-authorsguide.html#datetime-arithmetic) discussion for more information.

### Missing Information

Because clinical information is often incomplete, CQL provides constructs and support for representing and dealing with _unknown_ or missing information. In FHIR, when the value of an element is not present, accessing that element will result in a `null`:

```cql
Observation.interpretation
```

Given an instance of an Observation resource that does not have an interpretation element, the above expression will return `null`. In general, `null` results will _propagate_ through operations. For example:

```cql
MedicationRequest.doNotPerform = false
```

If the MedicationRequest instance does not have a `doNotPerform` element, this expression will return `null`. When a `null` result is encountered in the evaluation of a criteria (such as a `where` clause), it will be interpreted as `false`. For this reason, best-practice when comparing boolean-valued elements such as `doNotPerform` is to use the `is true | false` predicate test:

```cql
MedicationRequest MR
  where MR.doNotPerform is not true
```

This pattern ensures that whether the instance does not have a doNotPerform element, or the doNotPerform element is false, the result of the expression is true, correctly accounting for the potential missing information.

Another common case encountered in FHIR is the use of an `unknown` code in terminology-valued elements:

```cql
MedicationRequeest.status = 'unknown'
```

This is a special-case of characterizing missing information within FHIR resources. To treat this status value as a null, the following pattern can be used:

```cql
if MedicationRequest.status is null or MedicationRequest.status ~ 'unknown'
```

For more information about dealing with Missing Information in CQL in general, see the [Missing Information](https://cql.hl7.org/02-authorsguide.html#missing-information) topic in the CQL Author's Guide.

### Activity Extent
{: #activity-extent}

<div class="new-content" markdown="1">
FHIR offers several possibilities for describing _what_ activity (i.e. request or event) is being performed (e.g. the `code` element of a Procedure, or the `medication` element of a MedicationRequest):

1. Specify a particular code
2. Specify a higher-level code that includes all the concepts by subsumption
3. Specify the items with a value set (via the `codeOptions` extension)
4. Specify a protocol
5. Use a RequestOrchestration to group items
6. Use the basedOn element rather than coding the activity

These approaches allow for the _extent_ of an activity to be defined:

#### Specific Code

The first two approaches make use of terminology to define the extent of an activity, and is the most common approach. The code in a terminology may identify a single, precise concept, or it may identify a class of concepts, such as a type of procedure, or a class of medications.

For example, the following MedicationAdministration indicates a specific drug:

```json
{
  "resourceType" : "MedicationAdministration",
  ...,
  "medicationCodeableConcept" : {
      "coding" : [{
          "system" : "http://www.nlm.nih.gov/research/umls/rxnorm",
          "code" : "1116635",
          "display" : "ticagrelor 90 MG Oral Tablet"
      }]
  },
  ...
}
```

As opposed to specifying only a concept code:

```json
{
  "resourceType" : "MedicationAdministration",
  ...,
  "medicationCodeableConcept" : {
      "coding" : [{
          "system" : "http://www.nlm.nih.gov/research/umls/rxnorm",
          "code" : "11289",
          "display" : "warfarin"
      }]
  },
  ...
}
```

Retrieving resources with codes specified using these approaches can be accomplished with a simple [Retrieve](https://cql.hl7.org/02-authorsguide.html#filtering-with-terminology):

```cql
define "Antithrombotic Therapy Administered":
  [MedicationAdministration: "Antithrombotic Therapy"] AntithromboticTherapy
    where AntithromboticTherapy.status = 'completed'
      and AntithromboticTherapy.category ~ "Inpatient Setting"
```

This example retrieves `MedicationAdministration` resources that have a code in the `Antithrombotic Therapy` value set, a status of `completed`, and a category of `Inpatient Setting`.

#### Code Options

The third approach (specifying the items with a value set) is enabled through the use of the [codeOptions](https://build.fhir.org/ig/HL7/fhir-extensions/branches/br-48852-codeOptions-extension/StructureDefinition-codeOptions.html) extension. Rather than specifying a code, this extension is used to indicate that the activity may be any one of the codes in the value set:

```json
{
  "resourceType" : "MedicationAdministration",
  ...,
  "medicationCodeableConcept" : {
      "extension" : [{
          "url" : "http://hl7.org/fhir/StructureDefinition/codeOptions",
          "valueCanonical" : "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1110.62"
      }],
      "text" : "Value Set: Antithrombotic Therapy for Ischemic Stroke"
  },
  ...
}
```

#### Structural Options

The other three approaches make use of structures such as PlanDefinition, RequestOrchestration, and the relationships between events and requests to establish the extent of an activity. See the [Clinical Guidelines](http://hl7.org/fhir/uv/cpg) implementation guide for more information on using these approaches to characterize and manage the extent of activities.

When this pattern is used in FHIR resources, the CQL needs to take this into account by looking for the `codeOptions` extension:

```cql
define "Antithrombotic Therapy Class Administered":
  [MedicationAdministration] Administered
    where Administered.medication.codeOptions() = "Antithrombotic Therapy".id
      and Administered.status = 'completed'
      and AntithromboticTherapy.category ~ "Inpatient Setting"
```

This example retrieves `MedicationAdministration` resources that use the `codeOptions` extension to specify a candidate medication in the `Antithrombotic Therapy` value set, a status of `completed`, and a category of `Inpatient Setting`.

NOTE: See the [FHIRCommon.cql](Library-FHIRCommon.html#contents) for the definition of the `codeOptions()` fluent function.

To ensure both approaches are accounted for, these two expressions would then be used together:

```cql
define "Antithrombotics Administered":
  "Antithrombotic Therapy Administered"
    union "Antithrombotic Therapy Class Administered"
```

> NOTE: Profile-informed authoring exposes elements that have a `codeOptions` extension using a Choice of `CodeableConcept` and `ValueSet`, which is then translated as a union, accounting for both cases as part of profile-informed authoring.

</div>

### Negation in FHIR
{: #negation-in-fhir}

The [HL7 Cross-Paradigm Specification: Representing Negatives](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=592) provides guidance and best practices for the representation of pertinent negatives and other negative semantics in clinical information. The following sections describe how these best practices may be represented in FHIR resources and profiles, as well as guidance for accessing negated information in CQL.

For an example of a set of profiles following these best practices to support the representation of negation in FHIR, see the [Negation](https://hl7.org/fhir/us/qicore/negation.html) profiles in QI-Core. 

In summary, negation statements typically cover three different use cases:

1. Documentation that an event did not occur
2. Documentation that an activity should not be performed (i.e. is prohibited)
3. Documentation that a requested activity was not performed

Given the representation of negative information in FHIR, two commonly used patterns for negation in clinical logic are:

* Absence of evidence for a particular event
* Documentation of an event not occurring (represented as one of the above 3 use cases), together with a reason

For the purposes of clinical reasoning, when looking for documentation that a particular event did not occur, it must
be documented with a reason in order to meet the intent. If a reason is not part of the intent, then the absence of
evidence pattern **SHOULD** be used, rather than documentation of an event not occurring.

To address the reason an action did not occur (negation rationale), clinical logic must define the event it expects to occur
using appropriate terminology to identify the kind of event (using a value set or direct-reference code), and then use
additional criteria to indicate that the event did not occur, as well as identifying a reason.

The following examples differentiate methods to indicate (a) presence of evidence of an action, (b) absence of evidence
of an action, and (c) negation rationale for not performing an action. In each case, the "action" is an administration
of medication included within a value set for "Antithrombotic Therapy".

#### Presence
{: #presence}

Evidence that "Antithrombotic Therapy" (defined by a medication-specific value set) was administered:

```cql
define "Antithrombotic Administered":
  [MedicationAdministration: "Antithrombotic Therapy"] AntithromboticTherapy
    where AntithromboticTherapy.status = 'completed'
      and AntithromboticTherapy.category ~ "Inpatient Setting"
```

#### Absence
{: #absence}

No evidence that "Antithrombotic Therapy" medication was administered:

```cql
define "No Antithrombotic Therapy":
  not exists (
    [MedicationAdministration: "Antithrombotic Therapy"] AntithromboticTherapy
      where AntithromboticTherapy.status = 'completed'
        and AntithromboticTherapy.category ~ "Inpatient Setting"
  )
```

#### Negation Rationale
{: #negation-rationale}

Evidence that "Antithrombotic Therapy" medication administration did not occur for an acceptable medical reason as
defined by a value set referenced by the clinical logic (i.e., negation rationale):

```cql
define "Antithrombotic Not Administered":
  [MedicationAdministration: "Antithrombotic Therapy"] NotAdministered
    where NotAdministered.status = 'not-done'
      and NotAdministered.statusReason in "Medical Reason"
```

In this example for negation rationale, the logic looks for a member of the value set "Medical Reason" as the rationale
for not administering any of the anticoagulant and antiplatelet medications specified in the "Antithrombotic Therapy"
value set.

As discussed in the [Activity Extent](#activity-extent) section, to represent Antithrombotic Therapy Not Administered, implementing systems reference the canonical of the "Antithrombotic
Therapy" value set using the ([codeOptions](https://build.fhir.org/ig/HL7/fhir-extensions/branches/br-48852-codeOptions-extension/StructureDefinition-codeOptions.html)) extension to indicate
providers did not administer any of the medications in the "Antithrombotic Therapy" value set. By referencing the value
set URI to negate the entire value set rather than a specific member code from the value set, clinicians are
not forced to arbitrarily select a specific medication from the "Antithrombotic Therapy" value set that they
did not administer in order to negate.

When this pattern is used in FHIR resources, the CQL needs to take this into account by looking for the `codeOptions` extension:

```cql
define "Antithrombotic Class Not Administered":
  [MedicationAdministration] NotAdministered
    where NotAdministered.medication.codeOptions() = "Antithrombotic Therapy".id
      and NotAdministered.status = 'not-done'
      and NotAdministered.statusReason in "Medical Reason"
```

To ensure both cases are accounted for, these two expressions would then be used together:

```cql
define "Antithrombotics Not Administered":
  "Antithrombotic Not Administered"
    union "Antithrombotic Class Not Administered"
```

This approach ensures that the logic will retrieve negated activities whether they are recorded as singular activities (i.e. with a code from the value set) or as indications that none of the activities were performed (i.e. with a reference to a value set).

> NOTE: Profile-informed authoring exposes elements that have a `notDoneValueSet` extension using a Choice of CodeableConcept and ValueSet, which is then translated as a union, accounting for both cases as part of profile-informed authoring.

#### Prohibited Activities

Evidence that "Antithrombotic Therapy" medication was prohibited for an acceptable medical reason makes use of the appropriate `Request` resource:

```cql
define "Antithrombotic Therapy Prohibited":
  [MedicationRequest: "Antithrombotic Therapy"] Prohibited
    where Prohibited.status = 'active'
      and Prohibited.doNotPerform is true
      and Prohibited.statusReason in "Medical Reason"
```

This example retrieves `MedicationRequest` resources with a code in the `Antithrombotic Therapy` value set that have a status of `active`, a doNotPerform of `true`, and a statusReason in the `Medical Reason` value set.

As with negation of events, the extent of the activity can be accounted for by searching for instances that make use of the `codeOptions` extension.

#### Rejected Requests

Evidence that a proposal to administer "Antithrombotic Therapy" was rejected for an acceptable medical reason makes use of the `Task` resource:

```cql
define "Antithrombotic Therapy Requested":
  [MedicationRequest: "Antithrombotic Therapy"] MR
    where MR.status = 'active'
      and MR.doNotPerform is not true

define "Antithrombotic Therapy Rejected":
  "Antithrombotic Therapy Requested" MR
    with [Task: Fulfill] T
      such that T.focus.references(MR)
        and T.status = 'rejected'
        and T.statusReason in "Medical Reason"
```

This example retrieves "Antithrombotic Therapy Requested" resources that have a fulfillment Task focused on the request, a status of `rejected`, and a statusReason in the `Medical Reason` value set.

As with negation of events, the extent of the activity can be accounted for by searching for request instances that make use of the `codeOptions` extension.
