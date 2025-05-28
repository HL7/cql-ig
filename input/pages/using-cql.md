{:toc}

{: #using-cql}

This topic specifies conformance requirements for the use of Clinical Quality Language (CQL) with Fast Healthcare Interoperability Resources (FHIR), whether that be as in-line expressions in expression-valued elements, or in CQL libraries contained in FHIR Library resources.

### Libraries
{: #libraries}

Declarations in CQL are packaged in containers called _libraries_ which provide a unit for the definition, distribution, and versioning of CQL logic. The following conformance requirements and guidance apply when libraries of CQL are used with FHIR knowledge artifacts.

**Conformance Requirement 2.1 (Library Declaration):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-1)
{: #conformance-requirement-2-1}
  1. Any CQL library used by a FHIR artifact **SHALL** contain a [library declaration.](https://cql.hl7.org/02-authorsguide.html#library)
  2. The library identifier **SHALL** be a valid un-quoted identifier and **SHALL NOT** contain underscores. The library identifier **SHALL** only contain alphanumeric characters.

> The example in the Author's Guide from the above library declaration link is not following the "Using CQL With FHIR" convention of prohibiting underscores in library names.

For example:

```cql
library EXM146
```

This declaration specifies the name of the library as `EXM146`. See the discussion on [Library Resources](conformance.html#library-resources) for more information on library naming conventions.

#### Library Versioning
{: #library-versioning}

This Implementation Guide (IG) recommends [Semantic Versioning](https://semver.org) be used to version libraries used within knowledge artifacts to help track and manage dependencies.

**Conformance Requirement 2.2 (Library Versioning):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-2)
{: #conformance-requirement-2-2}
  1. The library declaration in the CQL source **NEED NOT** specify a version, since version can be provided as part of the translation and publishing process.
  2. The library version **SHOULD** follow the convention:
       < major >.< minor >.< patch >
  3. For artifacts in draft status, a version is not required, the versioning scheme **NEED NOT** apply, and there is no expectation that artifact contents are stable.
  4. When an artifact moves to active status, a version is required in either the CQL source, the translated ELM (if included), or the containing FHIR Library resources.

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

Note that when CQL libraries are included as part of larger groupings of artifacts (such as quality measures or computable guidelines), the version of the library is specified along with all the other artifacts in the larger group. For more guidance on versioning these artifacts as a group, refer to the [Versioning](http://build.fhir.org/ig/HL7/crmi-ig/artifact-lifecycle.html#artifact-versioning) topic in the Canonical Resource Management Infrastructure (CRMI) implementation guide.

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
    * If an artifact makes use of multiple libraries, expression references in that artifact **SHALL** be qualified with the `name` of the library (i.e. `library-name.expression-identifier`), or with the `alias` of the library as specified using the [cqf-libraryAlias]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-libraryAlias.html) extension.
2. CQL libraries **SHALL** use a `called` clause for all included libraries
3. The `called`-alias for an included library **SHOULD** be consistent for usages across libraries

The recommendation that CQL libraries be structured such that all references to expressions from a FHIR artifact are to a single Library is a simplification to ensure that expression references from FHIR artifacts do not require qualified expressions (as they would if multiple libraries were referenced). However, there are valid use cases for allowing multiple libraries to be referenced, such as modular questionnaires, and dependent library references. However, when an artifact uses multiple libraries, all expressions within the artifact SHALL be qualified.

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
library is included in the ELM in the `Library.identifier` element, along with a Uniform Resource Identifier (URI) that provides a globally unique, stable identifier for the namespace.
For example, the URI for the CMS namespace might be `https://ecqi.healthit.gov/ecqm/measures`.

Note that this is a URI that may or may not correspond to a reachable web address (a Uniform Resource Locater (URL)). The important aspect is not
the addressability, but the uniqueness, ensuring that library name collisions cannot occur.

**Conformance Requirement 2.4 (Library Namespaces):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-4)
{: #conformance-requirement-2-4}

1. CQL libraries **SHOULD** use namespaces.
2. When a namespace is not used, the library **SHALL** be considered part of a "public" global namespace for the purposes of resolution within a given environment.
3. The root of the CQL namespace **SHALL** match the root of the url of the Library resource housing the CQL library.

In addition, because the namespace of a library functions as part of the globally unique identifier for the library, changing the namespace of the library results in a different artifact.

### Data Model
{: #data-model}

CQL can be used with any data model(s). To be used with FHIR, CQL requires model information. To facilitate use with any FHIR content, a general-purpose FHIR information model is included in the [Clinical Quality Framework Common FHIR Assets](https://fhir.org/guides/cqf/common) implementation guide. However, CQL may also be used with implementation-guide specific model information (i.e. structures based on the profile definitions in an IG).

**Conformance Requirement 2.5 (CQL Using FHIR-based Data Models):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-5)
{: #conformance-requirement-2-5}

1. All libraries and CQL expressions used directly or indirectly within a knowledge artifact **SHOULD** use FHIR-based data models.
2. Data Model declarations **SHALL** include a version declaration.

For example:

```cql
using FHIR version '4.0.1'
```

Snippet 2-3: Data Model line from [Example.cql](Library-Example.html#cql-content)

### Code Systems
{: #code-systems}

Conformance Requirement 2.6 describes how to specify a code system within a CQL library.

**Conformance Requirement 2.6 (Code System Specification):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-6)
{: #conformance-requirement-2-6}

1. Within CQL, the identifier of any code system reference **SHALL** be specified using a URI for the code system.
2. The URI **SHALL** be the canonical URL for the code system.
3. The Code System declaration **MAY** include a version, consistent with the URI specification for FHIR and the code system.

For example, the following CQL `codesystem` declaration establishes `"SNOMED CT:20250301"` as the local identifier for the code system with url `http://snomed.info/sct` and version `http://snomed.info/sct/731000124108/version/20250301`:

```cql
codesystem "SNOMED CT:20250301": 'http://snomed.info/sct'
  version 'http://snomed.info/sct/731000124108/version/20250301'
```

Snippet 2-4: codesystem definition line from [Example.cql](Library-Example.html#cql-content).

The canonical URL for a code system is a globally unique, stable, version-independent identifier for the code system.
The [HL7 Terminology (THO) site ](http://terminology.hl7.org) defines canonical URLs for most common code systems.

The local identifier for the codesystem ("SNOMED CT:20250301" in this case) should include the friendly name of the code system
and optionally, an indication of the version, separated with a colon.

Version information for code systems is not required to be included in knowledge artifacts; terminology versioning information may be
specified externally. However, if versioning information is included, it must be done in accordance with the terminology
usage specified by FHIR.

If no version is specified, then the default behavior for a FHIR terminology server is to use the most recent code
system version available on the server.

#### Representation in Narrative
{: #codesystem-representation-in-narrative}

When code systems are used within knowledge artifacts, if the artifact includes narrative (Human-readable, such as the narrative in the `text` element of a resource), it **SHALL** include a representation of at least the following information for each code system:

* The local identifier for the code system.
* The external identifier for the code system.
* The version of the code system, if specified.

For example, the code system declaration from Snippet 2-4 `"SNOMED CT:20250301"` could be represented in the narrative HTML of the library resource as:

```html
"SNOMED CT:20250301": "SNOMED CT" (http://snomed.info/sct, version http://snomed.info/sct/731000124108/version/20250301)
```

### Value Sets
{: #value-sets}

Conformance Requirement 2.7 describes how to specify a value set within a CQL library.

**Conformance Requirement 2.7 (Value Set Specification):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-7)
{: #conformance-requirement-2-7}

1. Within CQL, the identifier of any value set reference **SHALL** be specified using a URI for the value set.
2. The URI **SHALL** be the canonical URL for the value set
3. The URI **MAY** include a version, consistent with versioned canonical URL references in FHIR

For example, the following `valueset` declaration establishes the local identifier `"Absent or Unknown Allergies - IPS"` for the value set with url `http://hl7.org/fhir/uv/ips/ValueSet/absent-or-unknown-allergies-uv-ips`:

```cql
valueset "Absent or Unknown Allergies - IPS": 'http://hl7.org/fhir/uv/ips/ValueSet/absent-or-unknown-allergies-uv-ips'
```

Snippet 2-5: Valueset reference from [Example.cql](Library-Example.html#cql-content).

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

> A note about usage of the term value set in this documentation: "Value set", with two words, regardless of case, is the human-readable spelling. "ValueSet", with one word and in PascalCase, is the FHIR Type. "valueset", with one word and all lower case, is the proper spelling for use within CQL statements and expressions.

#### Value Set Version
{: #value-set-version}

Version information for value sets is not required to be included in knowledge artifacts; terminology versioning information may be
specified externally. However, if versioning information is included, it must be done in accordance with the terminology
usage specified by FHIR.

Conformance Requirement 2.8 describes how to specify a value set, including the definition version to be used.

**Conformance Requirement 2.8 (Value Set Specification Including Version):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-8)
{: #conformance-requirement-2-8}

1. When specifying the definition version of a value set to be used in a CQL library, use the `version` clause of the value set declaration

For example:

```cql
valueset "Encounter Inpatient SNOMEDCT Value Set":
   'http://example.org/fhir/ValueSet/encounter-inpatient' version '20160929'
```

Snippet 2-6: valueset definition from [Example.cql](Library-Example.html#cql-content).

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

When value sets are used within knowledge artifacts, if the artifact includes narrative (Human-readable), it **SHALL** include a representation of at least the following information for each value set:

* The local identifier for the value set.
* The external identifier for the value set.
* The version of the value set, if specified.

For example, the `"Encounter Inpatient"` value set could be represented in the narrative HTML for a library resource as:

```html
"Encounter Inpatient": "Encounter Inpatient SNOMEDCT Value Set" (http://example.org/fhir/ValueSet/encounter-inpatient, version 20160929)
```

#### String-based Membership Testing
{: #string-based-membership-testing}

Although CQL allows the use of strings as input to membership testing in value sets, this capability should not be used with FHIR-based models as it can lead to incorrect matching if the code system is not considered.

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

In this case, because the `state` element is string-valued, there is no straightforward way to associate a system, and the string-based membership testing is simpler than requiring the construction of a `Code` value. However, care should be taken with this usage to ensure the string values do not match codes from an unexpected system. Furthermore, if the element being tested is terminology-valued, terminology membership testing **SHOULD** be used.

### Codes
{: #codes}

When direct-reference codes are represented within CQL, the logical identifier **SHALL NOT** be a URI. Instead,
the logical identifier **SHOULD** be the code from the code system.

**Conformance Requirement 2.11 (Direct Referenced Codes):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-11)
{: #conformance-requirement-2-11}

1. When direct-reference codes are represented within CQL, the logical identifier:
    1. **SHALL NOT** be a URI.
    2. **SHOULD** be a code from the code system.

```cql
code "Venous foot pump, device (physical object)": '442023007' from "SNOMED CT"
```

Snippet 2-7: code definition from [Example.cql](Library-Example.html#cql-content).

Note that for direct-reference code usage, the local identifier (in Snippet 2-7 the local identifier is "Venous foot pump,
device (physical object)") **SHOULD** be the same as the description of the code within the terminology in order to avoid
conflicting with any usage or license agreements with the referenced terminologies, but can be different to allow for
potential naming conflicts, as well as simplification of longer names when appropriate.

CQL supports both version-specific and version-independent specification of and comparison to direct-reference codes. The best practice is for artifact authors to use version-independent direct-reference codes and comparisons unless there is a specific reason not to (such as the code is retired in the current version). Even in the case that version-specific direct-reference codes are required, best practice is still to use the equivalent (~) operator in CQL for the comparison (again, unless there is a specific reason to do version-specific comparison)

#### Representation in Narrative
{: #code-representation-in-narrative}

When direct-reference codes are used within knowledge artifacts, if the artifact includes narrative (Human-readable), it **SHALL** include a representation of at least the following information for each direct-reference code:

* The local identifier for the code within the codesystem.
* The external identifier for the codesystem.
* The version of the codesystem, if specified.
* The display value from the code system.

For example, the `"Venous foot pump, device (physical object)"` code declaration could be represented in the narrative HTML for a library resource as:

```html
code "Venous foot pump, device (physical object)":  '442023007' from "SNOMEDCT" display Venous foot pump, device (physical object)"
```

### UCUM Best Practices
{: #ucum-best-practices}

Although the Unified Code for Units of Measure (UCUM) is a code system, it requires specific handling for two reasons. First, it is a grammar-based code system with an effectively infinite number of codes, so membership tests must be performed computationally, rather than just by checking for existence of a code in a list; and second, because UCUM codes are so commonly used as part of quantity values, healthcare contexts typically provide direct mechanisms for using UCUM codes.

For these reasons, within quality artifacts in general, and quality measures specifically, UCUM codes **SHOULD** make use of the direct mechanisms wherever possible. In CQL logic, this means using the `Quantity` literal, rather than declaring UCUM codes as direct-reference codes as is recommended when using codes from other code systems. For example, when accessing a Body Mass Index (BMI) observation in CQL:

```cql
define "BMI in Measurement Period":
  [Observation: "BMI"] BMI
    where BMI.status in {'final', 'amended', 'corrected'}
      and BMI.effective during "Measurement Period"
      and BMI.value is not null
      and BMI.value.code = 'kg/m2'
```

Notice the use of the UCUM code directly, as opposed to declaring a CQL code for the unit:

```cql
// Anti-pattern illustrating inappropriate use of code system and code declarations for UCUM
codesystem UCUM: 'http://unitsofmeasure.org'
code "kg/m2": 'kg/m2' from UCUM

define "BMI in Measurement Period":
  [Observation: "BMI"] BMI
    where BMI.status in {'final', 'amended', 'corrected'}
      and BMI.effective during "Measurement Period"
      and BMI.value is not null
      and BMI.value.code = "kg/m2"
// Anti-pattern illustrating inappropriate use of code system and code declarations for UCUM
```

### Concepts
{: #concepts}

In addition to codes, CQL supports a concept construct, which is defined as a set of codes that are all _about_ the same concept, (e.g. the same concept represented in different code systems, or the same concept from the same code system represented at different levels of detail), but CQL itself will make no attempt to ensure that is the case. Concepts should never be used as a surrogate for proper value set definition. In other words, the Concept declaration should not be used to define sets of codes for membership testing.

**Conformance Requirement 2.12 (Concepts):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-12)
{: #conformance-requirement-2-12}

1. The CQL concept construct **MAY** be used.
2. The CQL concept construct **SHALL NOT** be used as a surrogate for value set definition.

The following example illustrates appropriate usage of the Concept construct to establish a "Tiredness" concept that has both a context-specific and a standardized representation:

```cql
codesystem "Antenatal Care Concepts": 'http://example.org/fhir/CodeSystem/anc-codes-example'
codesystem "ICD-11": 'http://id.who.int/icd/release/11/mms'

code "Tiredness Code": 'ANC.B5.DE40' from "Antenatal Care Concepts" display 'Tiredness'
code "MB22.7": 'MB22.7' from "ICD-11" display 'Tiredness'

concept "Tiredness": { "Tiredness Code", "MB22.7" } display 'Tiredness'
```

As an example of an anti-pattern for Concept usage, consider the following:

```cql
// Anti-pattern illustrating inappropriate use of the Concept construct
codesystem "Condition Clinical Status Codes": 'http://terminology.hl7.org/CodeSystem/condition-clinical'
code "Active": 'active' from "Condition Clinical Status Codes" display 'Active'
code "Recurrence": 'recurrence' from "Condition Clinical Status Codes" display 'Recurrence'
code "Relapse": 'relapse' from "Condition Clinical Status Codes" display 'Relapse'
concept "Active Condition Statuses": { "Active", "Recurrence", "Relapse" } display 'Active Condition Statuses'
// Anti-pattern illustrating inappropriate use of the Concept construct
```

This usage of concept includes multiple concepts with different meanings from the same code system. Instead, a value set **SHOULD** be used for this purpose as it provides more flexibility and maintainability for this use case.

### Library-level Identifiers
{: #library-level-identifiers}

A "library-level identifier" is the identifier used to name any expression, function, parameter, code system, 
value set, concept, or code defined in the CQL library. The library name specified in the library declaration, 
the data model names, and any referenced external library names are not considered "library-level identifiers" 
for the purposes of this conformance requirement. 

It is critical that library-level identifiers have descriptive and meaningful names, avoid the use of abbreviations,
and as much as possible, clearly and concisely communicate the intent of the declaration. These best-practices help 
ensure that:
* Common logic can be effectively shared, reducing the overall development effort
* Logic can be quickly and easily understood, facilitating accurate communication of intent and reducing maintenance and review effort

As an example of a library that makes use of these best-practices, consider the [USCoreElements](https://hl7.org/fhir/us/cql/2025May/Library-USCoreElements.html) library.

Conformance Requirement 2.13 captures these best-practices for Library-level identifiers in a CQL library. Note that this conformance requirement is characterized as a best-practice (i.e. a **SHOULD**) only because it is not possible to computably enforce it as a **SHALL**.

**Conformance Requirement 2.13 (Library-level Identifiers):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-13)
{: #conformance-requirement-2-13}

1. Library-level identifiers in CQL:
    1. **SHOULD** Have descriptive, meaningful names
    2. **SHOULD** Avoid abbreviations
    3. **SHOULD** Use quoted identifiers if necessary
    4. **SHOULD** Use Initial Case
    5. **MAY** Include spaces

> NOTE: **Initial Case** is defined as the first letter of every word is capitalized (e.g. "Includes Or Starts During") (as opposed to Title Case, which traditionally does not capitalize conjunctions and prepositions, e.g. "Includes or Starts During")

For example:

```cql
define function
   "Includes Or Starts During"(condition Condition, encounter Encounter):
      Interval[condition.onset, condition.abatement] includes encounter.period
         or condition.onset during encounter.period
```

Snippet 2-8: Function definition from [Example.cql](Library-Example.html#cql-content).

The `"Includes Or Starts During"` is the library-level identifier in this example.

#### Fluent Functions
{: #fluent-functions}

<div class="new-content" markdown="1">
Because fluent functions are invoked using _dot-invocation_, they should follow the naming convention for elements, rather than library-level identifiers. For example:

```cql
define fluent function includesOrStartsDuring(condition Condition, encounter Encounter):
  Interval[condition.onset, condition.abatement] includes encounter.period
    or condition.onset during encounter.period
```

</div>

### Data Type Names
{: #data-type-names}

A "data type" in CQL refers to any named type used within CQL expressions. They may be primitive types, such as the
system-defined "Integer" and "DateTime", or they may be model-defined types such as "Encounter" or "Medication". For
FHIR-based knowledge artifacts using model information based on implementation guides (such as the QI-Core profiles),
these will be the author-friendly identifiers for the profile.

**Conformance Requirement 2.14 (Data Type Names):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-14)
{: #conformance-requirement-2-14}

1. Data type names referenced in CQL:
    1. **SHALL** use PascalCase (unless dictated by the name of the type in the model)
    2. **SHALL NOT** use quoted identifiers (unless required because the name of the type in the model contains spaces or is otherwise not a valid identifier without quoting)

For example:

```cql
define "Flexible Sigmoidoscopy Performed":
  [Procedure: "Flexible Sigmoidoscopy"] FlexibleSigmoidoscopy
    where FlexibleSigmoidoscopy.status = 'completed'
      and FlexibleSigmoidoscopy.performed ends 5 years or less on or before end of "Measurement Period"
```

Snippet 2-9: Expression definition from [Example.cql](Library-Example.html#cql-content).

The `Procedure` is the name of the model data type (FHIR resource type) in this example.

### Element Names
{: #element-names}

**Conformance Requirement 2.15 (Element Names):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-2-15)
{: #conformance-requirement-2-15}

1. Data model elements referenced in the CQL:
    1. **SHALL NOT** use quoted identifiers (unless required due to the element name in the model not being a valid identifier in CQL)
    2. **SHOULD** use camelCase (unless dictated by the element naming in the model being used)

Examples of elements conforming to Conformance Requirement 2.15 are given below. For a full list of valid of elements, refer to an appropriate data model specification such as QI-Core.

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

1. Aliases and argument names referenced in the CQL:
    1. **SHALL NOT** Use quoted identifiers
    2. **SHOULD** Use PascalCase for alias names
    3. **SHOULD** Use camelCase for argument names
    4. **SHOULD** Use descriptive names (rather than abbreviations)

For example:

```cql
define "Encounters During Measurement Period":
    "Valid Encounters" QualifyingEncounter
        where QualifyingEncounter.period during "Measurement Period"

define function "ED Stay Time"(encounter "Encounter"):
    duration in minutes of encounter.period
```

