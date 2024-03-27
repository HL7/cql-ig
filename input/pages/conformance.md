{:toc}

{: #conformance}

This topic specifies conformance requirements for systems that support authoring, publishing, distribution, and implementation of FHIR Knowledge Artifacts that make use of Clinical Quality Language (CQL).

### Library Resources
{: #library-resources}

In addition to the use of CQL directly in expression-valued elements, CQL content used within knowledge artifacts can be included through the use of a Library resource. These libraries can then be referenced from FHIR resources such as PlanDefinition and Measure using the `library` element (as well as the `cqf-library` extension for resources that do not declare a `library` element). The content of the CQL library is included using the `content` element of the Library.

**Conformance Requirement 4.1 (Library Resources):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-1)
{: #conformance-requirement-4-1}

1. Content conforming to this implementation guide **SHALL** use FHIR Library resources to represent CQL libraries in FHIR.
2. For distribution to environments that support CQL compilation directly, FHIR Library resources **SHOULD** include CQL content.
    a. FHIR Library resources that include CQL content **SHALL** conform to the [CQLLibrary](StructureDefinition-cql-library.html) profile

> For distribution to environments that support ELM execution directly, FHIR Library resources **MAY** include ELM content in XML or JSON format. See the [Using ELM](using-elm.html) topic for conformance requirements related to the use of ELM for distribution and implementation of CQL logic.

#### Library Name and URL
{: #library-name-and-url}

**Conformance Requirement 4.2 (Library Name and URL):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-2)
{: #conformance-requirement-4-2}

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

**Conformance Requirement 4.3 (FHIR Type Mapping):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-3)
{: #conformance-requirement-4-3}

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

Which might be represented as

```
{
    "resourceType": "Parameters",
    "id": "cql-list-example",
    "meta": {
      "profile": [ "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-evaluationresult" ]
    },
    "parameter": [ {
      "name": "Non Elective Inpatient Encounter",
      "resource": {
        "resourceType": "Encounter",
        ...
      }
    }, {
      "name": "Non Elective Inpatient Encounter",
      "resource": {
      "resourceType": "Encounter",
      ...
      }
    }
  ]
}
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

Which might be represented as

```
{
    "resourceType": "Parameters",
    "id": "cql-tuple-example",
    "meta": {
      "profile": [ "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-evaluationresult" ]
    },
    "parameter": [ {
      "name": "SDE Ethnicity",
      "part": [
        {
          "name": "code",
          "valueCode": "2135-2"
        },
        {
          "name": "display",
          "valueString": "Hispanic or Latino"
        }
      ]
    }]
}
```

#### Parameters and Data Requirements
{: #parameters-and-data-requirements}

**Conformance Requirement 4.4 (FHIR Type Mapping):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-4)
{: #conformance-requirement-4-4}

1. Parameters to CQL libraries **SHALL** be either CQL-defined types that map to FHIR types, or FHIR resource types, optionally with profile designations.
2. Top level expressions in CQL libraries **SHALL** return either CQL-defined types that map to FHIR types (as defined in 2.19), or FHIR resources types, optionally with profile designations
3. Tuple types are represented in FHIR as a `parameter` that has parts corresponding to the elements of the tuple type. List types are represented in FHIR as a `parameter` that has a cardinality of 0..*.
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

**Conformance Requirement 4.5 (Related Artifacts):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-5)
{: #conformance-requirement-4-5}

1. Libraries used in computable artifacts **SHALL** use the `relatedArtifact` element to identify includes, code systems, value sets, and data models used by the CQL library:

|Dependency|RelatedArtifact representation|
|Data Model (using declaration)|`depends-on` with `url` of the ModelInfo Library (e.g. `http://hl7.org/fhir/Library/FHIR-ModelInfo|4.0.1`)|
|Library (include declaration)|`depends-on` with `url` of the Library (e.g. `http://hl7.org/fhir/Library/FHIRHelpers|4.0.1`)|
|Code System|`depends-on` with `url` of the CodeSystem (e.g. `http://loing.org`)|
|Value Set|`depends-on` with `url` of the ValueSet (e.g. `http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1116.89`)|
{: .grid }

#### CQL Version

**Conformance Requirement 4.6 (Specifying CQL Version):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-6)
{: #conformance-requirement-4-6}

1. The version of CQL/ELM used for content in a library **SHOULD** be specified using the version parameter of the text/cql and application/elm+xml, application/elm+json media types.
    a. If specified, the value of the version parameter **SHALL** correspond to the _major_ and _minor_ version of a published release of the CQL specification (https://cql.hl7.org/history.html)
2. Resource narratives for Libraries and knowledge artifacts that use CQL **SHOULD** include the CQL/ELM version if it is specified in the media type.

For example, the following media types indicate version 1.5 of the CQL specification.

* `text/cql; version=1.5`
* `application/elm+xml; version=1.5`
* `application/elm+json; version=1.5`


### Must Support

Certain elements in the profiles defined in this implementation guide are marked as Must Support. This flag is used to indicate that the element plays a critical role in defining, sharing, and implementing artifacts, and implementations **SHALL** understand and process the element.

In addition, because artifact specifications typically make use of data implementation guides (e.g. International Patient Summary(IPS), US Core, QI-Core), the implications of the Must Support flag for profiles used from those implementation guides must be considered.

For more information, see the definition of [Must Support](https://hl7.org/fhir/R4/profiling.html#mustsupport) in the base FHIR specification.

**Conformance Requirement 4.7 (Must Support Elements):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-7)
{: #conformance-requirement-4-7}

For resource instances claiming to conform to profiles from this IG, Must Support on any profile data element **SHALL** be interpreted as follows:
* Authoring systems and knowledge repositories **SHALL** be capable of populating all Must Support data elements.
* Evaluating systems **SHALL** be capable of processing resource instances containing Must Support data elements without generating an error or causing the evaluation to fail.
* In situations where information on a particular data element is not present and the reason for absence is unknown, authoring and repository systems **SHALL NOT** include the data elements in the resource instance. For example, for systems using ‘9999’ to indicate unknown data values, do not include ‘9999’ in the resource instance.
* When consuming resource instances, evaluating systems **SHALL** interpret missing data elements within resource instances as data not present for the artifact.
* Submitting and receiving systems using knowledge artifacts to perform data exchange or artifact evaluation operations **SHALL** respect the must support requirements of the profiles used by the artifact to describe the data involved in the operation.

