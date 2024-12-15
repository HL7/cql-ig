{:toc}

{: #conformance}

This topic specifies conformance requirements for systems that support authoring, publishing, distribution, and implementation of FHIR Knowledge Artifacts that make use of Clinical Quality Language (CQL).

### Library Resources
{: #library-resources}

In addition to the use of CQL directly in [expression-valued elements](#using-expressions), CQL content used within knowledge artifacts can be included through the use of a Library resource. These libraries can then be referenced from FHIR resources such as PlanDefinition and Measure using the `library` element (as well as the `cqf-library` extension for resources that do not declare a `library` element). The content of the CQL library is included using the `content` element of the Library.

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
* Library.name **SHALL** be `<CQL library name>`, **SHALL** be 64 characters or less, and **SHOULD** be 30 characters or less
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
|`System.DateTime`|`FHIR.dateTime`, with the exception that seconds must be provided|
|`System.Long`|`FHIR.string` in R4, `FHIR.integer64` in R5 and above|
|`System.Time`|`FHIR.time`, with the exception that seconds must be provided|
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
    * Tuple types **SHALL** have elements of types that can be mapped to FHIR according to this mapping

For example, the following CQL expression results in a `List<FHIR.Observation>`:

```cql
define "FHIRObservationListExample":
  [Observation]
```

In the Library resource, this is represented as a `parameter`:

```json
{
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
      "valueString": "List<FHIR.Observation>"
    }],
    "name": "FHIRObservationListExample",
    "use": "out",
    "min": 0,
    "max": "*",
    "type": "Observation"
  }
  ```

  Note the parameter is multi-cardinality to indicate this is a list-valued expression. Also note the use of the `cqf-cqlType` extension to relay the CQL type.

  When invoked through an operation (such as `$cql` or `Library/$evaluate`), this would be represented as multiple entries in the resulting Parameters resource:

  ```json
{
  "name": "FHIRObservationListExample",
  "resource": {
    "resourceType": "Observation",
    "id": "blood-glucose",
    "status": "final",
    ...
  }
}, {
  "name": "FHIRObservationListExample",
  "resource": {
    "resourceType": "Observation",
    "id": "blood-pressure",
    "status": "final",
    ...
  }
}, {
  "name": "FHIRObservationListExample",
  "resource": {
    "resourceType": "Observation",
    "id": "bmi",
    "status": "final",
    ...
  }
}
```

Note that for an empty list, the `cqf-isEmptyList` extension is used:

```json
{
  "extension": [{
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
    "valueString": "List<FHIR.Observation>"
  }],
  "name": "FHIRObservationEmptyListExample",
  "_valueBoolean": {
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/cqf-isEmptyList",
      "valueBoolean": true
    }]
  }
}
```

Note that the extension is provided on the `value` element, and an arbitrary choice of `boolean` is selected; there is no value to provide, the result is an empty list, so this is just a way to provide the cqf-isEmptyList extension (because parameters in a FHIR Parameters resource must have a value element).

For the special case of nested lists, where a parameter name is not available, the name `element` **SHALL** be used. For example:

```cql
define CQLListListExample:
  { { 1, 2, 3 }, { 4, 5, 6 } }
```

The result of this expression is represented in the resulting Parameters resource as:

```json
  {
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
      "valueString": "List<List<System.Integer>>"
    }],
    "name": "CQLListListExample",
    "part": [{
      "name": "element",
      "valueInteger": 1
    }, {
      "name": "element",
      "valueInteger": 2
    }, {
      "name": "element",
      "valueInteger": 3
    }]
  }, {
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
      "valueString": "List<List<System.Integer>>"
    }],
    "name": "CQLListListExample",
    "part": [{
      "name": "element",
      "valueInteger": 4
    }, {
      "name": "element",
      "valueInteger": 5
    }, {
      "name": "element",
      "valueInteger": 6
    }]
  }
```

For a complete example illustrating all possible type mappings, refer to the [Type Mapping Example](Library-TypeMappingExample.html) and [Type Mapping Evaluation Result Example](Parameters-cql-typemappingexampleresult.html)

#### Parameters and Data Requirements
{: #parameters-and-data-requirements}

**Conformance Requirement 4.4 (Parameters and Data Requirements):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-4)
{: #conformance-requirement-4-4}

1. Parameters to CQL libraries **SHALL** be either CQL-defined types that map to FHIR types, or FHIR resource types, optionally with profile designations.
2. Top level expressions in CQL libraries **SHALL** return either CQL-defined types that map to FHIR types (as defined in 2.19), or FHIR resource types, optionally with profile designations
3. Tuple types are represented in FHIR as a `parameter` that has parts corresponding to the elements of the tuple type. List types are represented in FHIR as a `parameter` that has a cardinality of 0..*.
4. Libraries used in computable artifacts **SHALL** use the `parameter` element to identify input parameters as well as the type of all top-level expressions as output parameters.
5. Libraries used in computable artifacts **SHALL** use the `dataRequirement` element to identify any retrieves present in the CQL, according to the following mapping:

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

For example, given the following CQL:

```cql
define Conditions: [Condition]
```

The corresponding data requirement is:

```json
{
  "type": "Condition",
  "profile": [ "http://hl7.org/fhir/StructureDefinition/Condition" ]
}
```

When the retrieve includes a terminology filter, the `codeFilter` element is used to communicate the filter:

```cql
valueset "Inpatient Encounters": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292'
...
define Encounters: [Encounter: "Inpatient Encounters"]
```

```json
{
  "type": "Encounter",
  "codeFilter": [ {
    "path": "type",
    "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292"
  } ]
}
```

The [`cqf-isSelective`]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-isSelective.html) extension **MAY** be used to identify _selective_ data requirements (i.e. data requirements that are likely to be the most selective of the data of interest for the artifact:

```json
{
  "extension": [ {
      "url": "http://hl7.org/fhir/StructureDefinition/cqf-isSelective",
      "valueBoolean": true
  } ],
  "type": "Encounter",
  "codeFilter": [ {
    "path": "type",
    "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292"
  } ]
}
```

Although this extension may be used by artifact authors as a way to indicate expected selectivity of a data requirement, it will more typically be used by implementers and downstream packaging repositories to indicate selectivity of a data requirement given known data heuristics in particular datasets.

The [`cqf-fhirQueryPattern`]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-fhirQueryPattern.html) extension **MAY** be used to recommend a FHIR RESTful query that can be used to satisfy the data requirement:

```json
{
  "extension": [ {
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
    "valueString": "Encounter?subject=Patient/{{context.patientId}}&type:in=http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292"
  } ],
  "type": "Encounter",
  "profile": [ "http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-encounter" ],
  "codeFilter": [ {
    "path": "type",
    "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292"
  } ]
}
```

Systems that can infer more selective requirements from additional restrictions applied in the CQL after the retrieve **MAY** include those requirements to provide more selective data requirements. For example:

```cql
define "Completed Inpatient Encounters": 
  [Encounter: "Inpatient Encounters"] E
    where E.status = 'finished'
```

The `status` restriction is represented using the [`cqf-valueFilter`]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-valueFilter.html) extension:

```json
{
  "extension": [ {
    "extension" : [
      {
        "url" : "path",
        "valueString" : "status"
      },
      {
        "url" : "comparator",
        "valueCode" : "eq"
      },
      {
        "url" : "value",
        "valueString" : "finished"
      }
    ],
    "url" : "http://hl7.org/fhir/StructureDefinition/cqf-valueFilter"
  } ],
  "type": "Encounter",
  "codeFilter": [ {
    "path": "type",
    "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292"
  } ]
}
```

Elements that are referred to in the CQL **MAY** be communicated using the `mustSupport` element:

```cql
define "Inpatient Encounters During Measurement Period": 
  [Encounter: "Inpatient Encounters"] E
    where E.period during "Measurement Period"
```

```json
{
  "type": "Encounter",
  "mustSupport": [ "period" ],
  "codeFilter": [ {
    "path": "type",
    "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292"
  } ]
}
```

When using profile-informed authoring, the retrieve will have a `templateId` corresponding to the profile:

```json
{
  "type": "Encounter",
  "profile": [ "http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-encounter" ],
  "codeFilter": [ {
    "path": "type",
    "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292"
  } ]
}
```

When referencing extensions that are surfaced as elements in profile-informed authoring, the `mustSupport` uses the `.extension()` function in FHIRPath, and the [`rendered-value`]({{site.data.fhir.ver.ext}}/StructureDefinition-rendered-value.html) extension is used to provide a human-readable rendering, corresponding to the `sliceName` of the extension:

```cql
using QICore
...
define SDEEthnicity: Patient.ethnicity
```

```json
{
  "type": "Patient",
  "profile": [ "http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-patient" ],
  "mustSupport": [ "extension('http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity')" ],
  "_mustSupport": [
    {
      "extension": [{
        "url": "http://hl7.org/fhir/StructureDefinition/rendered-value",
        "valueString": "ethnicity"
      }]
    }
  ]
}
```

> In the case that dynamic CQL construction is required, implementers should take care to sanitize inputs from any parameters used in the construction of dynamic CQL to avoid [injection attacks](https://en.wikipedia.org/wiki/SQL_injection).

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
{: #cql-version}

**Conformance Requirement 4.6 (Specifying CQL Version):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-6)
{: #conformance-requirement-4-6}

1. The version of CQL/ELM used for content in a library **SHOULD** be specified using the version parameter of the text/cql and application/elm+xml, application/elm+json media types.
    a. If specified, the value of the version parameter **SHALL** correspond to the _major_ and _minor_ version of a published release of the CQL specification (https://cql.hl7.org/history.html)
2. Resource narratives for Libraries and knowledge artifacts that use CQL **SHOULD** include the CQL/ELM version if it is specified in the media type.

For example, the following media types indicate version 1.5 of the CQL specification.

* `text/cql; version=1.5`
* `application/elm+xml; version=1.5`
* `application/elm+json; version=1.5`

### Using Expressions
{: #using-expressions}

CQL can be used in [expression-valued elements](http://hl7.org/fhir/R4/metadatatypes.html#Expression) in the following ways:

1. To specify an unqualified expression name in the "primary" library for an artifact
2. To specify a qualified expression name in a library referenced by an artifact
3. To directly specify an inline expression

To distinguish these use cases, the `language` element of the expression value is used as specified in the [Using Expressions](https://hl7.org/fhir/R5/clinicalreasoning-topics-using-expressions.html) topic of the FHIR specification.

The "primary library" for an artifact is determined as follows:

1. If the resource type has a `library` element (e.g. PlanDefinition.library), and there is one and only one library specified, that is the primary library
2. If the resource has one and only one `cqf-library` extension, that is the primary library

If there is more than one library specified in the resource, then expression identifiers must be qualified with the name of the library (see [Conformance Requirement 2.3 (Nested Libraries)](using-cql.html#conformance-requirement-2-3)).

### Must Support
{: #must-support}

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

