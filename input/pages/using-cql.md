{:toc}

{: #using-cql}

This topic specifies conformance requirements and guidance for the use of CQL with FHIR, whether that be as in-line expressions in expression-valued elements, or in CQL libraries contained in FHIR Library resources.

### Libraries
{: #libraries}

Declarations in CQL are packaged in containers called _libraries_ which provide a unit for the definition, distribution, and versioning of CQL logic. The following conformance requirements and guidance apply when libraries of CQL are used with FHIR knowledge artifacts.

**Conformance Requirement 2.1 (Library Declaration):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-1)
{: #conformance-requirement-2-1}
  1. Any CQL library used by a FHIR artifact **SHALL** contain a [library declaration.](https://cql.hl7.org/02-authorsguide.html#library)
  2. The library identifier **SHALL** be a valid un-quoted identifier and **SHALL NOT** contain underscores. The library identifier **SHALL** only contain alphanumeric characters.

**Note** The example in the Author's Guide from the above library declaration link is not following the "Using CQL With FHIR" convention of prohibiting underscores in library names.

For example:

```cql
library EXM146
```

This declaration specifies the name of the library as `EXM146`. See the discussion on [Library Resources](#library-resources) for more information on library naming conventions.

#### Library Versioning
{: #library-versioning}

This IG recommends [Semantic Versioning](https://semver.org) be used to version libraries used within knowledge artifacts to help track and manage dependencies.

**Conformance Requirement 2.2 (Library Versioning):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-2)
{: #conformance-requirement-2-2}
  1. The library declaration **SHOULD** specify a version.
  2. The library version **SHOULD** follow the convention:
       < major >.< minor >.< patch >
3. For artifacts in draft status, the versioning scheme **SHALL NOT** apply, and there is no expectation that artifact contents are stable.
  4. The versioning scheme **SHALL** apply when an artifact moves to active status.

There are three main types of changes that can be made to a library:

  1. A library can be changed in a way that would alter the public use of its components.
  2. A library can be changed by adding new components or functionality but without changing the way that existing components are used.
  3. A library can be changed in a way that does not change existing components or add new components, but only corrects or improves the originally intended functionality.

By exposing version numbers that identify all three types of changes, libraries can be versioned in a way that makes
clear when a change will impact usage, versus when a change can potentially be safely incorporated as an update. The
first type of change will be referred to as a "major" change, and will require incrementing the "major version
number". The second type of change will be referred to as a "minor" change, and will only require incrementing the
"minor version number". And finally, the third type of change will be referred to as a "patch", and will only require
incrementing the "patch version number". Version numbers for CQL libraries can then be represented as:

```xml
<major>.<minor>.<patch>
```
{: #content-pre}

For example:

```cql
library EXM146 version '1.0.0'
```

This would indicate the first major version of the EXM146 library. A minor change could be released by incrementing the
minor version:

```cql
library EXM146 version '1.1.0'
```

And a major change could be released by incrementing the major version, and resetting the minor version: Minor changes
are expected to retain backwards-compatibility, but may introduce new features and functionality, while patch changes
are expected to retain forward and backwards-compatibility, and may only be used to fix issues.

```cql
library EXM146 version '2.0.0'
```

Snippet 2-1: Library line from EXM146.cql, the second major version.

Note that when CQL libraries are included as part of larger groupings of artifacts (such as quality measures or computable guidelines), the version of the library is specified along with all the other artifacts in the larger group. For more guidance on versioning these artifacts as a group, refer to the [Versioning](http://build.fhir.org/ig/HL7/crmi-ig/content-lifecycle.html#artifact-versioning) topic in the CRMI implementation guide.

#### Nested Libraries
{: #nested-libraries}

CQL allows libraries to re-use logic already defined in other libraries. This is accomplished by utilizing the
include declaration as in Snippet 2-2.

```cql
include Common version '2.0.0' called Common
```

Snippet 2-2: Nested library within EXM146.cql

The set of all CQL libraries used as part of a knowledge artifact must adhere to Conformance Requirement 2.3.

**Conformance Requirement 2.3 (Nested Libraries):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-3)
{: #conformance-requirement-2-3}

1. CQL libraries **SHOULD** be structured such that all CQL expressions referenced from a single FHIR resource are
contained within a single library.
    * If an artifact makes use of multiple libraries, expression references in that artifact **SHALL** be qualified with the `name` of the library (i.e. `library-name.expression-identifier`)
2. CQL libraries **SHALL** use a `called` clause for all included libraries
3. The `called`-alias for an included library **SHOULD** be consistent for usages across libraries

The recommendation that CQL libraries be structured such that all references to expressions from a FHIR artifact are to a single Library is a simplification to ensure that expression references from FHIR artifacts don’t require qualified expressions (as they would if multiple libraries were referenced). However, there are valid use cases for allowing multiple libraries to be referenced, such as modular questionnaires, and dependent library references. However, when an artifact uses multiple libraries, all expressions within the artifact SHALL be qualified. 

#### Library Namespaces
{: #library-namespaces}

CQL allows libraries to define a namespace that can be used to organize libraries across different groups of users.
Within a namespace, library names are required to be unique. Across namespaces, the same library name may be reused.
For example, OrganizationA and OrganizationB can both define a library named `Common`, so long as they use different
namespaces. For example, consider the following library declaration:

```cql
library CMS.Common version '2.0.0'
```

This example declares a library named Common in the CMS namespace. Per the [CQL specification](https://cql.hl7.org/04-logicalspecification.html#versionedidentifier), the namespace for a
library is included in the ELM in the `Library.identifier` element, along with a URI that provides a globally unique, stable identifier for the namespace.
For example, the URI for the CMS namespace might be `https://ecqi.healthit.gov/ecqm/measures`.

Note that this is a URI that may or may not correspond to a reachable web address (a URL). The important aspect is not
the addressability, but the uniqueness, ensuring that library name collisions cannot occur.

**Conformance Requirement 2.4 (Library Namespaces):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-4)
{: #conformance-requirement-2-4}

1. CQL libraries **SHOULD** use namespaces.
2. When a namespace is not used, the library **SHALL** be considered part of a "public" global namespace for the purposes of resolution within a given environment.
3. The root of the CQL namespace **SHALL** match the root of the url of the Library resource housing the CQL library.

In addition, because the namespace of a library functions as part of the globally unique identifier for the library, changing the namespace of the library results in a different artifact.

### Data Model
{: #data-model}

CQL can be used with any data model(s). To be used with FHIR, CQL requires model information. To facilitate use with any FHIR content, a general-purpose FHIR information model is included in the [Common](https://fhir.org/guides/cqf/common) implementation guide. However, CQL may also be used with implementation-guide specific model information (i.e. structures based on the profile definitions in an IG).

**Conformance Requirement 2.5 (CQL Using FHIR-based Data Models):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-5)
{: #conformance-requirement-2-5}

1. All libraries and CQL expressions used directly or indirectly within a knowledge artifact **SHOULD** use FHIR-based data models.
2. Data Model declarations **SHALL** include a version declaration.

For example:

```cql
using FHIR version '4.0.1'
```

Snippet 2-3: Data Model line from EXM146.cql

### Code Systems
{: #code-systems}

Conformance Requirement 2.6 describes how to specify a code system within a CQL library.

**Conformance Requirement 2.6 (Code System Specification):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-6)
{: #conformance-requirement-2-6}

1. Within CQL, the identifier of any code system reference **SHALL** be specified using a URI for the code system.
2. The URI **SHALL** be the canonical URL for the code system.
3. The Code System declaration **MAY** include a version, consistent with the URI specification for FHIR and the code system.
For example:

```cql
codesystem "SNOMED CT:2017-09": 'http://snomed.info/sct'
  version 'http://snomed.info/sct/731000124108/version/201709'
```

Snippet 2-4: codesystem definition line from Terminology.cql.

The canonical URL for a code system is a globally unique, stable, version-independent identifier for the code system.
The [HL7 Terminology site (THO)](http://terminology.hl7.org) defines canonical URLs for most common code systems.

The local identifier for the codesystem ("SNOMED CT:2017-09" in this case) should include the friendly name of the code system
and optionally, an indication of the version, separated with a colon.

Version information for code systems is not required to be included in knowledge artifacts; terminology versioning information may be
specified externally. However, if versioning information is included, it must be done in accordance with the terminology
usage specified by FHIR.

If no version is specified, then the default behavior for a FHIR terminology server is to use the most recent code
system version available on the server.

### Value Sets
{: #value-sets-notes}

##### Value set spelling and case usage.

        "Value set", with two words, regardless of case, is the human-readable spelling. 
        "ValueSet", with one word and in PascalCase, is the FHIR Type.
        "valueset", with one word and all lower case, is the proper spelling for use within cql statements and expressions, except when used within a URL.



{: #value-sets}

Conformance Requirement 2.7 describes how to specify a value set within a CQL library.

**Conformance Requirement 2.7 (Value Set Specification):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-7)
{: #conformance-requirement-2-7}

1. Within CQL, the identifier of any value set reference **SHALL** be specified using a URI for the value set.
2. The URI **SHALL** be the canonical URL for the value set
3. The URI **MAY** include a version, consistent with versioned canonical URL references in FHIR

For example:

```cql
valueset "Absent or Unknown Allergies - IPS": 'http://hl7.org/fhir/uv/ips/ValueSet/absent-or-unknown-allergies-uv-ips'
```

Snippet 2-5: Valueset reference from EXM146.cql

The canonical URL for a value set is typically defined by the value set author, though it may be provided by the
publisher as well. For example, value sets defined in the International Patient Summary have a base URL of `http://hl7.org/fhir/uv/ips/`.
This base is then used to construct the canonical URL for the value set (in the same way as any FHIR URL) using the resource type
(`ValueSet` in this case) and a unique identifier for the value set within that url (typically the same as the value set id in
the implementation guide). Note that the _canonical URL_ is a globally unique, stable, version-independent identifier for the
value set. See [Canonical URLs](http://hl7.org/fhir/references.html#canonical) in the base FHIR specification for more information.

The local identifier for the value set within CQL **SHOULD** be the same as the `title` of the value set. However, because the title of the value set is not
necessarily unique, it is possible to reference multiple value sets with the same title, but different identifiers.
When this happens in a CQL library, the local identifier **SHOULD** be the title of the value set with a qualifying suffix to
preserve the value set title as a human-readable reference, but still allow unique reference within the CQL library.

For example:

```cql
valueset "Acute Pharyngitis (1)": 'http://example.org/fhir/ValueSet/acute-pharyngitis-snomed'
valueset "Acute Pharyngitis (2)": 'http://example.org/fhir/ValueSet/acute-pharyngitis-icd'
```

Note carefully that although this URL may be resolvable for some terminology implementations, this is not necessarily the
case. This use of a canonical URL can be resolved as a search by the `url` element:

```
GET fhir/ValueSet?url=http://example.org/fhir/ValueSet/acute-pharyngitis-snomed
```

#### Value Set Version
{: #value-set-version}

Version information for value sets is not required to be included in knowledge artifacts; terminology versioning information may be
specified externally. However, if versioning information is included, it must be done in accordance with the terminology
usage specified by FHIR.

Conformance Requirement 2.8 describes how to retrieve an expansion of a value set by version.

**Conformance Requirement 2.8 (Value Set Specification By Version):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-8)
{: #conformance-requirement-2-8}

1. When retrieving the expansion of a value set by version, append the version identifier to the canonical URL of the
value set, separated by a pipe (`|`)

For example:

```cql
valueset "Encounter Inpatient SNOMEDCT Value Set":
   'http://example.org/fhir/ValueSet/encounter-inpatient|20160929'
```

Snippet 2-6: valueset definition from Terminology.cql.

This is a _version specific value set reference_, and can be resolved as a search by the `url` and `version` elements:

```
GET fhir/ValueSet?url=http://example.org/fhir/ValueSet/encounter-inpatient&version=20160929
```

#### Value Set Expansion

It is important to maintain the distinction between the _definition_ of a value set and the _expansion_ of a value set. The searches
described in previous sections all retrieve the definition of a value set. For the purposes of local evaluation, implementations may
wish to retrieve the _expansion_ of a value set, or the set of all codes that are defined to be in the value set by the _definition_.

Because the definition of a value set can, and often does, include codes from a code system based on properties of that code system, the
expansion of a value set is sensitive to the versions of the code systems used in the definition. This means that in general, the expansion
of a value set is version-specific, and care must be taken to ensure that version considerations are taken into account when using the
results of an expansion.

**Conformance Requirement 2.9 (Value Set Expansion):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-9)
{: #conformance-requirement-2-9}

1. Value set membership testing **SHOULD** use the terminology membership operation in CQL (`in(ValueSet)`), as opposed to requiring computation on the lists of codes in a value set.  See the [Terminology Operators](http://cql.hl7.org/02-authorsguide.html#terminology-operators) section of the CQL specification for more information.

For example, rather than combining multiple value sets using a `union`, separate membership tests in each value set **SHOULD** be used. For more information, see the [Value Set Expansion](http://hl7.org/fhir/valueset.html#expansion) topic in the base FHIR specification.

#### Representation in Narrative
{: #valueset-representation-in-narrative}

When value sets are used within knowledge artifacts, they will be represented in the narrative (Human-readable) as:

```html
"Encounter Inpatient" using "Encounter Inpatient SNOMEDCT Value Set" (http://example.org/fhir/ValueSet/encounter-inpatient, version 20160929)
```

In other words, the local identifier for the value set, followed by the value set information from the value set declaration, including version if specified.

#### String-based Membership Testing
{: #string-based-membership-testing}

Although CQL allows the use of strings as input to membership testing in value sets, this capability **SHALL NOT** be used with FHIR-based models as it can lead to incorrect matching if the code system is not considered.

**Conformance Requirement 2.10 (String-based Membership Testing):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-10)
{: #conformance-requirement-2-10}

1. String-based membership testing **SHOULD NOT** be used in CQL libraries.

For example, given a value set named `"Administrative Gender"`, the following CQL expression is not recommended:

```cql
'female' in "Administrative Gender"
```

This is because there is no code system associated with the string `'female'` so the comparison to codes in the value set is only partial. There are use cases for this, such as when comparing a string-valued element in FHIR, for example:

```cql
First(Patient.address).state in "New England States"
```

In this case, because the `state` element is string-valued, there is no straightforward way to associate a system, and the string-based membership testing is simpler than requiring the construction of a `Code` value. However, care should be taken with this usage to ensure the string values do not match codes from an unexpected system. Furthermore, if the element being tested is terminology-valued, terminology membership testing SHOULD be used.

### Codes
{: #codes}

When direct-reference codes are represented within CQL, the logical identifier **SHALL NOT** be a URI. Instead,
the logical identifier **SHOULD** be the code from the code system.

**Conformance Requirement 2.11 (Direct Referenced Codes):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-11)
{: #conformance-requirement-2-11}

1. When direct-reference codes are represented within CQL, the logical identifier:<br/>
     a. **SHALL NOT** be a URI.<br/>
     b. **SHOULD** be a code from the code system.

```cql
code "Venous foot pump, device (physical object)": '442023007' from "SNOMED CT"
```

Snippet 2-7: code definition from Terminology.cql.

Note that for direct-reference code usage, the local identifier (in Snippet 2-7 the local identifier is "Venous foot pump,
device (physical object)") **SHOULD** be the same as the description of the code within the terminology in order to avoid
conflicting with any usage or license agreements with the referenced terminologies, but can be different to allow for
potential naming conflicts, as well as simplification of longer names when appropriate.

CQL supports both version-specific and version-independent specification of and comparison to direct-reference codes. The best practice is for artifact authors to use version-independent direct-reference codes and comparisons unless there is a specific reason not to (such as the code is retired in the current version). Even in the case that version-specific direct-reference codes are required, best practice is still to use the equivalent (~) operator in CQL for the comparison (again, unless there is a specific reason to do version-specific comparison)

#### Representation in Narrative
{: #code-representation-in-narrative}

When direct-reference codes are used within knowledge artifacts, they will be represented in the narrative (Human-readable) as:

```html
"Venous foot pump, device (physical object)" using "Venous foot pump, device (physical object) SNOMED CT Code (442023007)"
```

In other words, the library identifier followed by the code and code system information from the code declaration.

### UCUM Best Practices
{: #ucum-best-practices}

Although the Unified Code for Units of Measure (UCUM) is a code system, it requires specific handling for two reasons. First, it is a grammar-based code system with an effectively infinite number of codes, so membership tests must be performed computationally, rather than just by checking for existence of a code in a list; and second, because UCUM codes are so commonly used as part of quantity values, healthcare contexts typically provide direct mechanisms for using UCUM codes.

For these reasons, within quality artifacts in general, and quality measures specifically, UCUM codes **SHOULD** make use of the direct mechanisms wherever possible. In CQL logic, this means using the Quantity literal, rather than declaring UCUM codes as direct-reference codes as is recommended when using codes from other code systems. For example, when accessing a Body Mass Index (BMI) observation in CQL:

```html
define "BMI in Measurement Period":
  [Observation: "BMI"] BMI
    where BMI.status in {'final', 'amended', 'corrected'}
      and BMI.effective during "Measurement Period"
      and BMI.value is not null
      and BMI.value.code = 'kg/m2'
```

Notice the use of the UCUM code directly, as opposed to declaring a CQL code for the unit:

```html
codesystem UCUM: 'http://unitsofmeasure.org'
code "kg/m2": 'kg/m2' from UCUM

define "BMI in Measurement Period":
  [Observation: "BMI"] BMI
    where BMI.status in {'final', 'amended', 'corrected'}
      and BMI.effective during "Measurement Period"
      and BMI.value is not null
      and BMI.value.code = "kg/m2"
```

### Concepts
{: #concepts}

In addition to codes, CQL supports a concept construct, which is defined as a set of codes that are all _about_ the same concept, (e.g. the same concept represented in different code systems, or the same concept from the same code system represented at different levels of detail), but CQL itself will make no attempt to ensure that is the case. Concepts should never be used as a surrogate for proper value set definition. In other words, the Concept declaration should not be used to define sets of codes for membership testing.

**Conformance Requirement 2.12 (Concepts):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-12)
{: #conformance-requirement-2-12}

1. The CQL concept construct **MAY** be used.
2. The CQL concept construct **SHALL NOT** be used as a surrogate for value set definition.

As an example of an anti-pattern for Concept usage, consider the following:

```cql
codesystem "Condition Clinical Status Codes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'
code "Active": 'active' from "Condition Clinical Status Codes" display 'Active'
code "Recurrence": 'recurrence' from "Condition Clinical Status Codes" display 'Recurrence'
code "Relapse": 'relapse' from "Condition Clinical Status Codes" display 'Relapse'
concept "Active Condition Statuses": { "Active", "Recurrence", "Relapse" } display 'Active Condition Statuses'
```

This usage of concept includes multiple concepts with different meanings from the same code system. A value set **SHOULD** be used for this purpose as it provides more flexibility and maintainability for this use case.

### Library-level Identifiers
{: #library-level-identifiers}

A "library-level identifier" is any named expression, function, parameter, code system, value set, concept, or code
defined in the CQL. The library name referenced in the library-line, the data model, and any referenced external library
should not be considered "library-level identifiers". Library-level identifiers ought to be given a descriptive
meaningful name (avoid abbreviations) and conform to Conformance Requirement 2.13.

**Conformance Requirement 2.13 (Library-level Identifiers):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-13)
{: #conformance-requirement-2-13}

1. Library-level identifiers referenced in the CQL:<br/>
      a. **SHOULD** Use quoted identifiers<br/>
      b. **SHOULD** Use Initial Case<br/>
      c. **MAY** Include spaces

**Initial Case Definition** is defined as the first letter of every word is capitalized (e.g. "Observation With Status") (as opposed to Title Case, which would be "Observation with Status")

For example:

```cql
define function
   "Includes Or Starts During"(Condition "Condition", Encounter "Encounter"):
      Interval[Condition.onset, Condition.abatement] includes Encounter.period
         or Condition.onset during Encounter.period
```

Snippet 2-8: Function definition from Common.cql

The `"Includes Or Starts During"` is the library-level identifier in this example.

### Data Type Names
{: #data-type-names}

A "data type" in CQL refers to any named type used within CQL expressions. They may be primitive types, such as the
system-defined "Integer" and "DateTime", or they may be model-defined types such as "Encounter" or "Medication". For
FHIR-based knowledge artifacts using model information based on implementation guides (such as the QI-Core profiles),
these will be the author-friendly identifiers for the profile. Data types referenced in CQL libraries to be included
in a knowledge artifact must conform to Conformance Requirement 2.14.

**Conformance Requirement 2.14 (Data Type Names):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-14)
{: #conformance-requirement-2-14}

1. Data type names referenced in CQL **SHALL**:<br/>
       a. Use quoted identifiers only if necessary (i.e. the data type name includes spaces)<br/>
       b. Use PascalCase plus appropriate spacing

For example:

```cql
define "Flexible Sigmoidoscopy Performed":
  [Procedure: "Flexible Sigmoidoscopy"] FlexibleSigmoidoscopy
    where FlexibleSigmoidoscopy.status = 'completed'
      and FlexibleSigmoidoscopy.performed ends 5 years or less on or before end of "Measurement Period"
```

Snippet 2-9: Expression definition from EXM130.cql

The `Procedure` is the name of the model data type (FHIR resource type) in this example.

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

### Negation in FHIR
{: #negation-in-fhir}

Two commonly used patterns for negation in clinical logic are:

* Absence of evidence for a particular event
* Documentation of an event not occurring, together with a reason

For the purposes of clinical reasoning, when looking for documentation that a particular event did not occur, it must
be documented with a reason in order to meet the intent. If a reason is not part of the intent, then the absence of
evidence pattern **SHOULD** be used, rather than documentation of an event not occurring.

To address the reason an action did not occur (negation rationale), an artifact must define the event it expects to occur
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

To represent Antithrombotic Therapy Not Administered, implementing systems reference the canonical of the "Antithrombotic
Therapy" value set using the ([cqf-notDoneValueSet]({{site.data.fhir.ver.hl7_fhir_uv_extensions}}/StructureDefinition-cqf-notDoneValueSet.html)) extension to indicate
providers did not administer any of the medications in the "Antithrombotic Therapy" value set. By referencing the value
set URI to negate the entire value set rather than reporting a specific member code from the value set, clinicians are
not forced to arbitrarily select a specific medication from the "Antithrombotic Therapy" value set that they
did not administer in order to negate.

### Element Names
{: #element-names}

All elements referenced in the CQL follow Conformance Requirement 2.15.
**Conformance Requirement 2.15 (Element Names):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-15)
{: #conformance-requirement-2-15}
1. Data model elements referenced in the CQL:<br/>
      a. **SHOULD NOT** use quoted identifiers (unless required due to the element name in the model not being a valid identifier in CQL)<br/>
      b. **SHOULD** use camelCase (unless dictated by the element naming in the model being used)

Examples of elements conforming to Conformance Requirement 2.15 are given below. For a full list of valid of elements, refer to an appropriate data model specification such as QI-Core.<br/><br/>

Note: When FHIR and FHIR IGs are used as the data model, the term "element" is synonymous with "attribute". Some data models, such as QDM, use the term "attribute".

```cql
period
authoredOn
result
```

### Aliases and Argument Names
{: #aliases-and-argument-names}

Aliases are used in CQL to reference items within the scope of a query. When defining a function, argument names
are used to create scoped identifiers that refer to the function inputs. Both aliases and argument names conform to
Conformance Requirement 2.16.

**Conformance Requirement 2.16 (Aliases and Argument Names):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-16)
{: #conformance-requirement-2-16}

1. Aliases and argument names referenced in the CQL:<br/>
      a. **SHALL NOT** Use quoted identifiers<br/>
      b. **SHALL** Use PascalCase<br/>
      c. **SHOULD** Use descriptive names (rather than abbreviations)

For example:

```cql
define "Encounters During Measurement Period":
    "Valid Encounters" QualifyingEncounter
        where QualifyingEncounter.period during "Measurement Period"

define function "ED Stay Time"(Encounter "Encounter"):
    duration in minutes of Encounter.period
```

### Library Resources
{: #library-resources}

In addition to the use of CQL directly in expression-valued elements, CQL content used within knowledge artifacts can be included through the use of a Library resource. These libraries can then be referenced from FHIR resources such as PlanDefinition and Measure using the `library` element (as well as the `cqf-library` extension for resources that do not declare a `library` element). The content of the CQL library is included using the `content` element of the Library.

**Conformance Requirement 2.17 (Library Resources):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-17)
{: #conformance-requirement-2-17}

1. Content conforming to this implementation guide **SHALL** use FHIR Library resources to represent CQL libraries in FHIR.

#### Library Name and URL
{: #library-name-and-url}

**Conformance Requirement 2.18 (Library Name and URL):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-18)
{: #conformance-requirement-2-18}

1. The identifying elements of a library **SHALL** conform to the following requirements:
* Library.url **SHALL** be `<CQL namespace url>/Library/<CQL library name>`
* Library.name **SHALL** be `<CQL library name>`
* Library.version **SHALL** be `<CQL library version>`

2. For libraries included in FHIR implementation guides, the CQL namespace is defined by the implementation guide as follows:
* CQL namespace name **SHALL** be IG.packageId
* CQL namespace url **SHALL** be IG.canonicalBase

3. CQL library source files **SHOULD** be named `<CQLLibraryName>-<version>.cql`
4. To avoid issues with characters between web ids and names, library names **SHALL NOT** have underscores.

The prohibition against underscores in CQL library names is required to ensure compliance with the canonical URL pattern (because URLs by convention should not use underscores). In addition, many publishing environments will use the canonical tail (i.e. the name of the library) as the logical id of the Library resource, which does not allow underscores per the FHIR specification.

#### FHIR Type Mapping
{: #fhir-type-mapping}

**Conformance Requirement 2.19 (FHIR Type Mapping):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-19)
{: #conformance-requirement-2-19}

1. CQL defined types **SHALL** map to types in FHIR according to the following mapping:

|CQL System Type |FHIR Type |
|---|---|
|`System.Boolean`|`FHIR.boolean`|
|`System.Integer`|`FHIR.integer`|
|`System.Decimal`|`FHIR.decimal`|
|`System.Date`|`FHIR.date`|
|`System.DateTime`|`FHIR.dateTime`|
|`System.Long`|`FHIR.integer64`|
|`System.Time`|`FHIR.time`|
|`System.String`|`FHIR.string`|
|`System.Quantity`|`FHIR.Quantity`|
|`System.Ratio`|`FHIR.Ratio`|
|`System.Any`|`FHIR.Any`|
|`System.Code`|`FHIR.Coding`|
|`System.Concept`|`FHIR.CodeableConcept`|
|`Interval<System.Date>`|`FHIR.Period`|
|`Interval<System.DateTime>`|`FHIR.Period`|
|`Interval<System.Quantity>`|`FHIR.Range`|
{: .grid }

2. In addition:

* List types **SHALL** have elements of types that can be mapped to FHIR according to this mapping

For example:

```cql
define "Non Elective Inpatient Encounter":
  ["Encounter": "Nonelective Inpatient Encounter"] NonElectiveEncounter
        where NonElectiveEncounter.period ends during day of "Measurement Period"
```

* Tuple types **SHALL** have elements of types that can be mapped to FHIR according to this mapping

For example:

```cql
define "SDE Ethnicity":
  Patient.ethnicity E
    return Tuple {
      codes: { E.ombCategory } union E.detailed,
      display: E.text
    }
```

#### Parameters and Data Requirements
{: #parameters-and-data-requirements}

**Conformance Requirement 2.20 (FHIR Type Mapping):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-20)
{: #conformance-requirement-2-20}

1. Parameters to CQL libraries **SHALL** be either CQL-defined types that map to FHIR types, or FHIR resource types, optionally with profile designations.
2. Top level expressions in CQL libraries **SHALL** return either CQL-defined types that map to FHIR types, or FHIR resources types, optionally with profile designations
3. Tuple types are represented in FHIR as a `parameter` that has parts corresponding to the elements of the tuple types. List types are represented in FHIR as a `parameter` that has a cardinality of 0..*.
4. Libraries used in computable artifacts **SHALL** use the `parameter` element to identify input parameters as well as the type of all top-level expressions as output parameters.
5. Libraries used in computable artifacts **SHALL** use the `dataRequirement` element to identify any retrieves present in the CQL:

|Retrieve Element|DataRequirement Element|
|---|---|
|dataType|type|
|templateId|profile|
|context|subject|
|codeProperty|codeFilter.path or codeFilter.searchParam|
|codes (Concept)|codeFilter.code (for each Code present in the Concept)|
|codes (Code)|codeFilter.code|
|codes (ValueSetRef)|codeFilter.valueSet (as specified by the `id` of the ValueSetDef referenced by the ValueSetRef)|
|dateProperty|dateFilter.path|
|dateLowProperty,dateHighProperty|dateFilter.path (resolved to an interval-valued property)|
|dateRange|dateFilter.path or dateFilter.searchParam|
{: .grid }

> Note that best-practice for CQL evaluation is to make use of and distribute compiled CQL (ELM). In the case that dynamic CQL construction is required, implementers should take care to sanitize inputs from any parameters used in the construction of dynamic CQL to avoid [injection attacks](https://en.wikipedia.org/wiki/SQL_injection).

#### RelatedArtifacts
{: #relatedartifacts}

**Conformance Requirement 2.21 (Related Artifacts):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-21)
{: #conformance-requirement-2-21}

1. Libraries used in computable artifacts **SHALL** use the `relatedArtifact` element to identify includes, code systems, value sets, and data models used by the CQL library:

|Dependency|RelatedArtifact representation|
|Data Model (using declaration)|`depends-on` with `url` of the ModelInfo Library (e.g. `http://hl7.org/fhir/Library/FHIR-ModelInfo|4.0.1`)|
|Library (include declaration)|`depends-on` with `url` of the Library (e.g. `http://hl7.org/fhir/Library/FHIRHelpers|4.0.1`)|
|Code System|`depends-on` with `url` of the CodeSystem (e.g. `http://loing.org`)|
|Value Set|`depends-on` with `url` of the ValueSet (e.g. `http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1116.89`)|
{: .grid }

#### MIME Type version
The version of CQL/ELM used for content in a library **SHOULD** be specified using the version parameter of the text/cql and application/elm+xml, application/elm+json media types.

* `text/cql; version=1.5`
* `application/elm+xml; version=1.5`
* `application/elm+json; version=1.5`

Resource narratives for Libraries and knowledge artifacts that use CQL **SHOULD** include the CQL version if it is specified in the MIME type as shown above.

### Use of Terminologies
{: #use-of-terminologies}

FHIR supports various types of terminology-valued elements, including:

* [code](http://hl7.org/fhir/datatypes.html#code)<br/>
* [Coding](http://hl7.org/fhir/datatypes.html#Coding)<br/>
* [CodeableConcept](http://hl7.org/fhir/datatypes.html#CodeableConcept)<br/>

These types map to the following CQL primitive types, respectively:

* [String](https://cql.hl7.org/09-b-cqlreference.html#string-1)<br/>
* [Code](https://cql.hl7.org/09-b-cqlreference.html#code-1)<br/>
* [Concept](https://cql.hl7.org/09-b-cqlreference.html#concept-1)<br/>

In addition to the type of element, FHIR provides the ability to bind these elements to specific codes, in the form of a direct-reference code (fixed constraint to a specific code in a [CodeSystem](http://hl7.org/fhir/codesystem.html)), or a binding to a [ValueSet](http://hl7.org/fhir/valueset.html). These bindings can be different [binding strengths](http://hl7.org/fhir/codesystem-binding-strength.html)

Within CQL, references to terminology code systems, value sets, codes, and concepts are directly supported, and all such usages are declared within CQL libraries, as described in the  [Terminology](https://cql.hl7.org/02-authorsguide.html#terminology) section of the CQL Author's Guide.

When referencing terminology-valued elements within CQL, the following comparison operations are supported:

* [Equal (`=`)](https://cql.hl7.org/09-b-cqlreference.html#equal-3)<br/>
* [Equivalent (`~`)](https://cql.hl7.org/09-b-cqlreference.html#equivalent-3)<br/>
* [In (`in`)](https://cql.hl7.org/09-b-cqlreference.html#in-valueset)<br/>

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

### Translation to ELM
{: #translation-to-elm}

Tooling exists to support translation of CQL to ELM for distribution in XML or JSON formats. These distributions can be
included with knowledge artifacts to facilitate implementation. [The existing translator tooling](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md) applies to both measure and decision
support development, and has several options available to make use of different data models in different environments.
For knowledge artifact development with FHIR, the following options are recommended:

| Option | Description | Recommendation |
|----|----|----|
| EnableAnnotations | This instructs the translator to include the source CQL as an annotation within the ELM. | This option **SHOULD** be used to ensure that the distributed ELM could be linked back to the source CQL. |
| EnableLocators | This instructs the translator to include line number and character information for each ELM node. | This option **SHOULD** be used to ensure that distributed ELM could be tied directly to the input source CQL. |
| DisableListDemotion | This instructs the translator to disallow demotion of list-valued expressions to singletons. The list demotion feature of CQL is used to enable functionality related to use with FHIRPath. | This option **SHOULD** be used with knowledge artifacts to ensure list demotion does not occur unexpectedly. |
| DisableListPromotion | This instructs the translator to disallow promotion of singletons to list-valued expressions. The list promotion feature of CQL is used to enable functionality related to use with FHIRPath. | This option **SHOULD** be used with knowledge artifacts to ensure list promotion does not occur unexpectedly. |
| DisableMethodInvocation | This instructs the translator to disallow method-style invocation. The method-style invocation feature of CQL is used to enable functionality related to use with FHIRPath. | This option **SHOULD NOT** be used with FHIR-based knowledge artifacts because it prevents the use of the fluent functions feature of CQL 1.5, which can be used to significantly improve readability of knowledge artifact logic, especially when accessing extensions. |
| EnableDateRangeOptimization | This instructs the translator to optimize date range filters by moving them inside retrieve expressions. | This feature **MAY** be used with knowledge artifacts. |
| EnableResultTypes | This instructs the translator to include inferred result types in the output ELM. | This feature **MAY** be used with knowledge artifacts. |
| EnableDetailedErrors | This instructs the translator to include detailed error information. By default, the translator only reports root-cause errors. | This feature **SHOULD NOT** be used with knowledge artifacts. |
| DisableListTraversal | This instructs the translator to disallow traversal of list-valued expressions. With knowledge artifacts, disabling this feature would prevent a useful capability. | This feature **SHOULD NOT** be used with knowledge artifacts. |
| SignatureLevel | This setting controls whether the `signature` element of a FunctionRef will be populated. | The SignatureLevel **SHOULD** be `Overloads` or `All` to ensure signature information is present. |
{: .grid }

#### Specifying Options

The FHIR specification defines the [cqlOptions](http://hl7.org/fhir/extensions/StructureDefinition-cqf-cqlOptions.html) extension to support defining the expected translator options used with a given Library, or set of Libraries. When this extension is not used, the recommended options above **SHOULD** be used. When this extension is present on a Library, it **SHALL** be used to provide options to the translator when translating CQL for that library. When this extension is present in an asset collection or implementation guide, it **SHALL** be used to provide options to the translator unless the options are provided directly by the library.

**Conformance Requirement 2.22 (Translator Options):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-22)
{: #conformance-requirement-2-22}

1. Translator options **SHOULD** be provided in either a CQLLibrary or an ELMLibrary
2. Translator options specified in a Library take precedence over options defined in an asset collection or implementation guide
3. If no translator options are provided, the recommended options above **SHOULD** be used
4. If translator options are provided in a CQLLibrary or ELMLibrary, the options **SHALL** be consistent with the translator options reported by the ELM content

The `cqlOptions` extension references a contained `Parameters` resource that contains a parameter for each option specified, as well as a `translatorVersion` parameter that indicates the version of the translator used to produce the ELM. For example:

```json
{
  "resourceType": "Library",
  "id": "FHIRCommon",
  "meta": {
    "profile": [ "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-library" ]
  },
  "contained": [ {
    "resourceType": "Parameters",
    "id": "options",
    "parameter": [ {
      "name": "translatorVersion",
      "valueString": "2.9.0-SNAPSHOT"
    }, {
      "name": "option",
      "valueString": "EnableAnnotations"
    }, {
      "name": "option",
      "valueString": "EnableLocators"
    }, {
      "name": "option",
      "valueString": "DisableListDemotion"
    }, {
      "name": "option",
      "valueString": "DisableListPromotion"
    }, {
      "name": "format",
      "valueString": "XML"
    }, {
      "name": "format",
      "valueString": "JSON"
    }, {
      "name": "analyzeDataRequirements",
      "valueBoolean": true
    }, {
      "name": "collapseDataRequirements",
      "valueBoolean": true
    }, {
      "name": "compatibilityLevel",
      "valueString": "1.5"
    }, {
      "name": "enableCqlOnly",
      "valueBoolean": false
    }, {
      "name": "errorLevel",
      "valueString": "Info"
    }, {
      "name": "signatureLevel",
      "valueString": "Overloads"
    }, {
      "name": "validateUnits",
      "valueBoolean": true
    }, {
      "name": "verifyOnly",
      "valueBoolean": false
    } ]
  } ],
  "extension": [ {
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlOptions",
    "valueReference": {
      "reference": "#options"
    }
  } ],
  "url": "http://ecqi.healthit.gov/ecqms/Library/FHIRCommon",
  "version": "4.1.000",
  "name": "FHIRCommon",
  ...
}
```

#### ELM Suitability
{: #elm-suitability}

Because certain translator options impact language features and functionality, translated ELM may not be suitable for use in all contexts if the options used to produce the ELM are inconsistent with the options in use in the evaluating environment. To determine suitability of ELM for use in a given environment, the following guidance **SHALL** be followed:
**Conformance Requirement 2.23 (ELM Suitability):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-23)
{: #conformance-requirement-2-23}

1. If the library has function overloads (i.e. function definitions with the same name and different argument lists), the ELM **SHALL** have been translated with a SignatureLevel of `Overloads` or `All`
2. If the evaluation environment or the ELM translator options have a compatibility level set, the compatibility level of the environment **SHALL** be consistent with the compatibility level used to produce the ELM
3. If the ELM has a compatibility level set, it **SHALL** be consistent with the version of the translator used in the evaluation environment
4. The translator version used to produce the ELM **SHOULD** be consistent with the translator version used in the evaluation environment
5. The translator options used in the evaluation environment **SHALL** be consistent with the translator options used to produce the ELM for at least the following options:
    * DisableListTraversal
    * DisableListDemotion
    * DisableListPromotion
    * EnableIntervalDemotion
    * EnableIntervalPromotion
    * DisableMethodInvocation
    * RequireFromKeyword
    * SignatureLevel
6. For authoring environments, the following additional translator options **MAY** be used to determine suitability of available ELM:
    * EnableAnnotations
    * EnableLocators
    * EnableResultTypes

### ModelInfo
{: #modelinfo}

When using CQL with FHIR, FHIR StructureDefinition resources are used to create the ModelInfo that describes the types for use in CQL, according to the following rules:

1. For each StructureDefinition, if the kind is `primitive-type`, `complex-type` (except for types based on Extension), or `resource` (with no derivation or a derivation of `specialization`), a ClassInfo with the same name as the structure definition is created
    1. For each element:
        1. If the element is not a backbone element, a corresponding element with the name and type is added to the ClassInfo. If the maximum cardinality of the element is not "1", the element is created as a list type.
        2. If the element is a backbone element, a new ClassInfo is created with the child elements of the backbone element and a new element is added to the containing ClassInfo with the type of the ClassInfo. Note that this process is recursive and so may result in multiple levels of nested class creation. As such the name of the ClassInfo must include the name of all the parent classes as qualifiers in order to ensure uniqueness. This approach also supports the ability of FHIR elements to reference other element definitions, though a post-processing fixup step is typically needed to resolve these references.

If this process is run against the StructureDefinitions from the base FHIR specification, it produces a complete representation of all the FHIR Resources as classes in the ModelInfo. However, because FHIR primitive types actually have elements (e.g. `value`, `id`, and `extension`), this process produces classes in the ModelInfo for each of the FHIR primitive types, and only the `value` elements of these FHIR primitives are typed with the actual CQL primitive types. This means that to access the actual values of FHIR elements for comparison against CQL primitive values, the `.value` path must be used:

```cql
Patient.gender.value = 'female'
```

To facilitate comparison by authors, these primitives can be implicitly converted to CQL primitive types, and the FHIRHelpers library (typically generated alongside the ModelInfo) defines these implicit conversions. See the [CQF Common](http://fhir.org/guides/cqf/common) implementation guide for a complete FHIR ModelInfo as well as FHIRHelpers library representing the FHIR specification.

#### ModelInfo Libraries

Similar to CQL content, ModelInfo can be included in FHIR Library resources to facilitate distribution.

**Conformance Requirement 2.24 (ModelInfo Libraries):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-23)
{: #conformance-requirement-2-24}

1. Libraries used to package ModelInfo **SHALL** conform to the [CQLModelInfo](StructureDefinition-cql-modelinfo.html) profile

#### Profile-informed ModelInfo

The process for producing ModelInfo from FHIR StructureDefinitions can also be applied to FHIR profile definitions, allowing for ModelInfos that reflect profile definitions, using the following refinements:

1. Each profile results in a new ClassInfo in the ModelInfo, derived from the ClassInfo for the baseDefinition of the profile
1. FHIR Primitive types are mapped to CQL types according to the above FHIR Type Mapping section
2. Extensions and slices defined in profiles are represented as first-class elements in the ClassInfo

#### ModelInfo Settings

In addition, to support more fine-grained control over the process of producing ModelInfo from FHIR StructureDefinitions, this implementation guide defines several ModelInfo-related extensions:

* cqf-modelInfo-isIncluded - Determines whether to create a ClassInfo for the profile or extension on which it appears
* cqf-modelInfo-isRetrievable - Determines whether the ClassInfo for the profile on which it appears is marked retrievable (i.e. can appear as the target type of a Retrieve in CQL)
* cqf-modelInfo-label - Specifies an author-friendly title for the ClassInfo (i.e. an alternate name by which the type can be referenced in CQL type specifiers)
* cqf-modelInfo-primaryCodePath - Specifies the primary code path for the ClassInfo produced from the profile on which it appears (i.e. the default path for terminology-valued filters when the type is used in a Retrieve in CQL)
* cqf-modelInfoSettings - Specifies additional settings used to produce the ModelInfo for profiles and extensions defined in the Implementation Guide on which it appears
