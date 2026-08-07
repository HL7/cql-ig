{:toc}
{::options toc_levels="1..4"/}

{: #conformance}

This topic specifies conformance requirements for systems that support authoring, publishing, distribution, and implementation of FHIR Knowledge Artifacts that make use of Clinical Quality Language (CQL).

### Library Resources
{: #library-resources}

In addition to the use of CQL directly in [expression-valued elements](#using-expressions), CQL content used within knowledge artifacts can be included through the use of a Library resource. These libraries can then be referenced from FHIR resources such as PlanDefinition and Measure using the `library` element (as well as the `cqf-library` extension for resources that do not declare a `library` element). The content of the CQL library is included using the `content` element of the Library.

**Conformance Requirement 4.1 (Library Resources):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-1)
{: #conformance-requirement-4-1}

1. Content conforming to this implementation guide **SHALL** use FHIR Library resources to represent CQL libraries in FHIR.
2. For distribution to environments that support CQL compilation directly, FHIR Library resources **SHOULD** include CQL content.
3. FHIR Library resources that include CQL content **SHALL** conform to the [CQLLibrary](StructureDefinition-cql-library.html) profile.
4. FHIR Library resources that include CQL content **SHALL** have a `subject` element that corresponds to the single context declaration in the CQL library. See [Conformance Requirement 2.17 (Context Declarations)](using-cql.html#conformance-requirement-2-17).

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

3. CQL library source files **SHOULD** be named `<CQLLibraryName>-<version>.cql`.
4. To avoid issues with characters between web ids and names, library names **SHALL NOT** have underscores.
5. Library.subject **SHALL** correspond to the context declaration in the CQL library

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
|`System.Decimal`|`FHIR.decimal`, with the use of the `quantity-precision` extension to communicate precision of the value|
|`System.Date`|`FHIR.date`|
|`System.DateTime`|`FHIR.dateTime`, with the exception that if hours are provided, minutes and seconds must be provided; use the `time-precision` extension to indicate precision of partial time values; use the `time-hasOffset` extension to indicate whether the underlying datetime value has a timezone offset|
|`System.Long`|`FHIR.string` in R4 (string only, no `L`, as that is part of the literal in CQL), `FHIR.integer64` in R5 and above|
|`System.Time`|`FHIR.time`, with the exception that minutes and seconds must be provided; use the `time-precision` extension to indicate precision of partial time values|
|`System.String`|`FHIR.string`|
|`System.Quantity`|`FHIR.Quantity`|
|`System.Ratio`|`FHIR.Ratio`|
|`System.Any`|`FHIR.Any`|
|`System.Code`|`FHIR.Coding`|
|`System.Concept`|`FHIR.CodeableConcept`|
|`Interval<System.Integer>`|`FHIR.Range`|
|`Interval<System.Long>`|`FHIR.Range`|
|`Interval<System.Decimal>`|`FHIR.Range`; use the `quantity-precision` extension to prevent the switch from an open to a closed interval from forcing a choice on precision (e.g. `Interval[1.0, 1.4)` is represented as `Period { 1.0, 1.3 }` with a `quantity precision` of `1`)|
|`Interval<System.Date>`|`FHIR.Period`|
|`Interval<System.DateTime>`|`FHIR.Period`|
|`Interval<System.Time>`|`FHIR.Period` with the Time values serialized as FHIR dateTime values with a date component of the minimum date (`@0001-01-01`)|
|`Interval<System.Quantity>`|`FHIR.Range`|
{: .grid }

2\. All CQL-valued parameters and results **SHALL** include a [cqf-cqlType]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-cqlType.html) extension to unambiguously specify the type of the parameter or result. In other words, in the absence of a cqlType extension, the value being represented is assumed to be of the type specified in the FHIR parameters element (i.e. the type of the FHIR value or resource element).
    1. The value of the cqlType extension **SHALL** be the fully qualified name of the type to avoid potential ambiguity (e.g. `System.Quantity` vs `FHIR.Quantity`)

3\. `null` parameters and results **SHALL** use a [data-absent-reason]({{site.data.fhir.ver.ext}}/StructureDefinition-data-absent-reason.html) extension with a `code` of `unknown` on the `value` element

4\. List types **SHALL** have elements of types that can be mapped to FHIR according to this mapping.
    1. In the case of an empty list, the [cqf-isEmptyList]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-isEmptyList.html) extension **SHALL** be used to indicate the list is empty
    2. In the case of nested list-valued elements, where there is no parameter name, the parameter name `element` **SHALL** be used.

5\. Tuple types **SHALL** have elements of types that can be mapped to FHIR according to this mapping.
    1. In the case of an empty tuple, the [cqf-isEmptyTuple]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-isEmptyTuple.html) extension **SHALL** be used to indicate the tuple is empty (i.e. has no elements)

For a complete example illustrating all possible type mappings, refer to the [Type Mapping Example](Library-TypeMappingExample.html) and [Type Mapping Evaluation Result Example](Parameters-cql-typemappingexampleresult.html)

The following sections illustrate some important examples of CQL expressions and results. 

##### Example: Simple Boolean

The following CQL expression results in a CQL Boolean value:

```cql
define CQLBooleanExample: true
```

In the Library resource, this is represented as a `parameter` with a FHIR type of `boolean` and a cqlType extension:

```json
{
  "extension": [{
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
    "valueString": "System.Boolean"
  }],
  "name": "CQLBooleanExample",
  "use": "out",
  "min": 0,
  "max": "1",
  "type": "boolean"
}
```

Note the parameter is single-cardinality to indicate this is a single value. When invoked through an operation, this result is represented as a single entry in the resulting Parameters resource:

```json
{
  "extension": [{
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
    "valueString": "System.Boolean"
  }],
  "name": "CQLBooleanExample",
  "valueBoolean": true
}
```

Here the CQL value is represented as a parameter element with the FHIR-mapped value, a boolean `true`

##### Example: Null Boolean

The following CQL expression results in a `null`, typed as a CQL Boolean:

```cql
define CQLBooleanExample: null as System.Boolean
```

In the Library resource, this is represented as a `parameter` with a FHIR type of `boolean` and a cqlType extension:

```json
{
  "extension": [{
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
    "valueString": "System.Boolean"
  }],
  "name": "CQLBooleanExample",
  "use": "out",
  "min": 0,
  "max": "1",
  "type": "boolean"
}
```

Note the parameter is single-cardinality to indicate this is a single value. When invoked through an operation, this result is represented as a single entry in the resulting Parameters resource:

```json
{
  "extension": [{
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
    "valueString": "System.Boolean"
  }],
  "name": "CQLBooleanExample",
  "_valueBoolean": {
    "extension": [{
      "url": "hl7.org/fhir/StructureDefinition/data-absent-reason",
      "valueCode": "unknown"
    }]
  }
}
```

In this case, the CQL `null` is still represented as a parameter element, but with a `data-absent-reason` extension indicating the result is `unknown`.

##### Example: List of FHIR Observation Resources

The following CQL expression results in a `List<FHIR.Observation>`:

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
  "extension": [{
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
    "valueString": "List<FHIR.Observation>"
  }],
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

##### Example: Empty List

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

##### Example: Nested Lists

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

##### Example: Empty Tuples

For an empty tuple, the `cqf-isEmptyTuple` extension is used:

```json
{
  "extension": [{
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
    "valueString": "Tuple{}"
  }],
  "name": "CQLEmptyTupleExample",
  "_valueBoolean": {
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/cqf-isEmptyTuple",
      "valueBoolean": true
    }]
  }
}
```

As with empty lists, the extension is provided on the `value` element, and an arbitrary choice of `boolean` is selected; there is no value to provide, the result is an empty tuple, so this is just a way to provide the cqf-isEmptyTuple extension (because parameters in a FHIR Parameters resource must have a value element).

##### Example: BackboneElement-valued Results

For expressions that result in a BackboneElement, the value is represented in the same way that a Tuple is represented:

```json
{
    "name": "FHIRBackboneElementExample",
    "part": [{
      "name": "relationship",
      "valueCodeableConcept": {
        "coding": [{
          "system": "http://terminology.hl7.org/CodeSystem/v2-0131",
          "code": "N"
        }]
      }
    }, {
      "name": "name",
      "valueHumanName": {
        "family": "du Marché",
        "_family": {
          "extension": [
            {
              "url": "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix",
              "valueString": "VV"
            }
          ]
        },
        "given": [
          "Bénédicte"
        ]
      }
    }, 
    ...
    ]
  }
  ```

##### Example: Extension-valued Results

For expressions that result in Extension values, the elements of the extension are mapped using parts, `url` and `value` for simple extensions:

```json
{
  "name": "FHIRSimpleExtensionExample",
  "part": [{
    "name": "url",
    "valueUri": "http://hl7.org/fhir/StructureDefinition/patient-birthTime"
  }, {
    "name": "value",
    "valueDateTime": "1974-12-25T14:35:45-05:00"
  }]
}
```

Parts `url` and `extension` for complex extensions:

```json
{
  "name": "FHIRComplexExtensionExample",
  "part": [{
    "name": "url",
    "valueUri": "http://hl7.org/fhir/StructureDefinition/patient-citizenship"
  }, {
    "name": "extension",
    "part": [{
      "name": "url",
      "valueUri": "code"
    }, {
      "name": "value",
      "valueCoding": {
        "system" : "urn:iso:std:iso:3166",
        "code" : "CH"
      }
    }]
  }, {
    "name": "extension",
    "part": [{
      "name": "url",
      "valueUri": "period"
    }, {
      "name": "value",
      "valuePeriod": {
        "start": "2016-01-01"
      }
    }]
  }]
}
```

##### Example: Representing CQL Values in Extensions

In addition to representation in Parameters, the FHIR Type Mapping allows CQL values to be represented using Extensions in much the same way, and using the same `data-absent-reason`, `cqf-cqlType`, `cqf-isEmptyList`, and `cqf-isEmptyTuple` extensions. For example, the following snippets illustrate the use of these extensions on the `value` component of a complex extension that is used to represent the result of evaluating a CQL expression:

Representation of a null:

```json
  {
    "extension" : [
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/data-absent-reason",
        "valueCode" : "unknown"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
        "valueString" : "System.Any"
      }
    ],
    "url" : "value"
  }
```

Representation of an empty list:

```json
  {
    "extension" : [
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/cqf-isEmptyList",
        "valueBoolean" : true
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/cqf-cqlType",
        "valueString" : "List<System.Any>"
      }
    ],
    "url" : "value"
  }
```

#### Parameters and Data Requirements
{: #parameters-and-data-requirements}

**Conformance Requirement 4.4 (Parameters and Data Requirements):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-4)
{: #conformance-requirement-4-4}

1. Parameters to CQL libraries **SHALL** be either
    1. CQL-defined types that map to FHIR types (as defined in [4.3](#conformance-requirement-4-3)), or 
    2. FHIR resource types, optionally with profile designations, or
    3. One of the types specified in [Open Types (*)](https://hl7.org/fhir/R4/datatypes.html#open), or
    4. A BackboneElement, in which case the elements of the BackboneElement are represented as parts, or
    5. An Extension, in which case the elements of the Extension are represented as parts.
2. Top level expressions in CQL libraries, regardless of access level, **SHALL** return either
    1. CQL-defined types that map to FHIR types (as defined in [4.3](#conformance-requirement-4-3)), or 
    2. FHIR resource types, optionally with profile designations, or
    3. One of the types specified in [Open Types (*)](https://hl7.org/fhir/R4/datatypes.html#open), or
    4. A BackboneElement, in which case the elements of the value are represented as parts, or
    5. An Extension, in which case the elements of the Extension are represented as parts.
3. Tuple types are represented in FHIR as a `parameter` that has parts corresponding to the elements of the tuple type. List types are represented in FHIR as a `parameter` that has a cardinality of `0..*`.
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

6. FHIR query patterns, if provided (using the [`cqf-fhirQueryPattern`]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-fhirQueryPattern.html) extension), **SHALL** be relative queries (i.e. with no base URL), and **SHALL** only use context tokens that are defined for the subject type of the artifact, as described in [FHIR Query Patterns](#fhir-query-patterns).
7. FHIR query patterns **SHALL** be _sound_ with respect to the data requirement, meaning that the union of the results of all the query patterns given for a data requirement **SHALL** include all the data described by that data requirement. Criteria that cannot be expressed as search parameters **SHALL** be omitted from the query patterns, rather than approximated with criteria that could exclude required data.
8. When more than one FHIR query pattern is present on a data requirement, consuming systems **SHALL** perform all of the queries and use the union of the results, de-duplicated by resource identity.
9. Producing systems **SHOULD** use the [cql-fhirQueryPatternCoverage](StructureDefinition-cql-fhirQueryPatternCoverage.html) extension to indicate the extent to which the query patterns cover the data requirement, and consuming systems **SHALL** apply the criteria of the data requirement to the results of the query patterns unless the coverage is `total`.
10. FHIR query patterns **SHOULD** only use search parameters, modifiers, and result parameters that are supported by the server that will be queried, as declared in the `CapabilityStatement` for that server.
{: start="6"}

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

{% raw %}
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
{% endraw %}

Constructing a query pattern from a data requirement, determining how completely the resulting query pattern covers that data requirement, and determining when more than one query pattern is required are discussed in detail in [FHIR Query Patterns](#fhir-query-patterns).

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
using IPS
...
define SDEGenderIdentity: Patient.genderIdentity
```

```json
{
  "type": "Patient",
  "profile": [ "http://hl7.org/fhir/uv/ips/StructureDefinition/Patient-uv-ips" ],
  "mustSupport": [ "extension('http://hl7.org/fhir/StructureDefinition/individual-genderIdentity')" ],
  "_mustSupport": [
    {
      "extension": [{
        "url": "http://hl7.org/fhir/StructureDefinition/rendered-value",
        "valueString": "genderIdentity"
      }]
    }
  ]
}
```

> In the case that dynamic CQL construction is required, implementers should take care to sanitize inputs from any parameters used in the construction of dynamic CQL to avoid [injection attacks](https://en.wikipedia.org/wiki/SQL_injection).

##### Parameter Constraints
{: #parameter-constraints}

In some cases, it is useful to describe constraints on the allowed values for parameters in CQL libraries. CQL currently does not support stating these requirements beyond the type and optional default for the parameter. Parameter constraints are being considered in a future version of CQL, but in anticipation of that feature being available, this guide provides a mechanism for declaring a parameter constraint in the CQLLibrary profile by allowing the [targetConstraint]({{site.data.fhir.ver.ext}}/StructureDefinition-targetConstraint.html) extension to be used. For example, given a CQL library with the following parameter declaration:

```cql
// NOTE: The measurement period provided must describe a full calendar year to meet measure intent
parameter "Measurement Period" Interval<DateTime>
```

In this case, to indicate to consuming systems the requirement that the measurement period must be a full calendar year, the following extension can be used on the parameter definition in the Library:

```json
  "parameter": [
    {
      "extension" : [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/targetConstraint",
          "extension": [
            {
              "url" : "key",
              "valueString": "mp-valid"
            },
            {
              "url" : "severity",
              "code" : "error"
            },
            {
              "url" : "expression",
              "valueExpression" : {
                "language" : "text/cql-expression",
                "expression" : "duration in years of \"Measurement Period\" = 1"
              }
            },
            {
              "url" : "human",
              "valueString" : "The measurement period must be a full calendar year in order to meet measure intent"
            }
          ]
        }
      ],
      "name" : "Measurement Period",
      "use" : "in",
      "min" : 0,
      "max" : "1",
      "type" : "Period"
    }
  ]
```

As another example, consider a co-occurrence constraint on parameters:

```cql
// A value for X must be supplied if NeedsX is true
parameter NeedsX Boolean
parameter X Integer
```

And the associated targetConstraint:

```json
  "parameter": [
    {
      "name" : "NeedsX",
      "use" : "in",
      "min" : 0,
      "max" : "1",
      "type" : "boolean"
    },
    {
      "extension" : [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/targetConstraint",
          "extension": [
            {
              "url" : "key",
              "valueString": "x-valid"
            },
            {
              "url" : "severity",
              "code" : "error"
            },
            {
              "url" : "expression",
              "valueExpression" : {
                "language" : "text/cql-expression",
                "expression" : "NeedsX implies X is not null"
              }
            },
            {
              "url" : "human",
              "valueString" : "A value for X must be supplied if NeedsX is true"
            }
          ]
        }
      ],
      "name" : "X",
      "use" : "in",
      "min" : 0,
      "max" : "1",
      "type" : "Integer"
    }
  ]
```

> NOTE: This capability can be provided in the declaring CQL library using the Error function to provide run-time enforcement as illustrated in the snippet below. The use of the `targetConstraint` extension as described here allows this information to be communicated structurally, allowing consumers of the library to understand the constraints. For example to provide a user-interface that guides user to providing correct values for the parameters, rather than waiting for the run-time error to occur.

```cql
library ParameterConstraintsExample

using FHIR version '4.0.1'

parameter "Measurement Period" Interval<DateTime>
parameter NeedsX Boolean
parameter X Integer

context Patient

define private function ValidateMeasurementPeriod()
  Message(true, duration in years of "Measurement Period" = 1, 'mp-valid', 'Error', 'Measurement Period must describe a full calendar year to meet measure intent')

define private function ValidateX()
  Message(true, NeedsX implies X is not null, 'x-valid', 'Error', 'A value for X must be supplied if NeedsX is true')

define "Initial Population":
  ValidateMeasurementPeriod()
    and ValidateX()
    and ...
```

<!--NOTE: Added extension tracker to enable this use case: https://jira.hl7.org/browse/FHIR-50991 -->

##### Related Data Requirements
{: #related-data-requirements}

To establish relationships between data requirements, the [cqf-relatedRequirement]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-relatedRequirement.html) extension can be used. For example, consider the following expression that retrieves both MedicationRequest and Medication resources:

```cql
define "Medication Request With Aspirin":
  [MedicationRequest] MR
    with [Medication] M
      such that MR.medication.references(M)
        and M.code in "Aspirin"
```

And the resulting data requirements:

```json
  "dataRequirement": [
    {
      "id": "G10001",
      "type": "MedicationRequest"
    },
    {
      "id": "G10002",
      "extension": [{
        "url": "http://hl7.org/fhir/StructureDefinition/cqf-relatedRequirement",
        "extension": [{
          "url": "targetId",
          "valueString": "G10001"
        }, {
          "url": "targetPath",
          "valueString": "medication"
        }]
      }],
      "type": "Medication",
      "codeFilter": [{
        "path": "code",
        "valueset": "http://example.org/ValueSet/Aspirin"
      }]
    }
  ]
```

##### FHIR Query Patterns
{: #fhir-query-patterns}

The [`cqf-fhirQueryPattern`]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-fhirQueryPattern.html) extension communicates a FHIR RESTful query that can be used to retrieve the data described by a data requirement. This allows consumers of a module definition Library, such as the one returned by the [$data-requirements](https://hl7.org/fhir/uv/crmi/OperationDefinition-crmi-data-requirements.html) operation, to gather the data an artifact needs without having to interpret the structure of each data requirement themselves.

Query patterns are _patterns_, not resolvable URLs:

* They are relative queries with no base URL, so that they can be applied to any server
* They contain _context tokens_, delimited with double-braces, that the consumer replaces with the identity of the subject for which the artifact is being evaluated

The context tokens available depend solely on the subject type of the artifact:

{% raw %}

|Subject Type|Context Token|
|---|---|
|`Patient`|`{{context.patientId}}`|
|`Practitioner`|`{{context.practitionerId}}`|
|`Organization`|`{{context.organizationId}}`|
|`Location`|`{{context.locationId}}`|
|`Device`|`{{context.deviceId}}`|
{: .grid }{% endraw %}

The remainder of this section describes how to construct query patterns from a data requirement, how to determine and communicate how completely the resulting queries cover that data requirement, and when more than one query pattern is required.

###### Constructing a Query Pattern
{: #constructing-a-query-pattern}

Construction of a query pattern is informed by three inputs:

1. The data requirement
2. The subject (context) type of the artifact
3. The capabilities of the server that will be queried, as declared in its `CapabilityStatement`, together with the `SearchParameter` definitions that server supports

The third input matters because search parameters, modifiers, chained parameters, `_include`, and compartment searches are all optional capabilities. Where the server that will be queried is not known at the time the query pattern is produced, producing systems **SHOULD** restrict the query pattern to search parameters defined in the base specification for the resource type, and **SHOULD NOT** use modifiers, chained parameters, or result parameters.

Elements of the data requirement map to components of the query as follows:

{% raw %}

|Data Requirement Element|Query Pattern Component|
|---|---|
|`type`|The resource type of the query (e.g. `Encounter?`)|
|(subject in context)|A search parameter relating the resource to the subject in context (e.g. `subject=Patient/{{context.patientId}}`), or a compartment search (e.g. `Patient/{{context.patientId}}/Encounter?`)|
|`profile`|`_profile`, subject to the considerations described below|
|`codeFilter.searchParam`|Used directly as the name of the search parameter|
|`codeFilter.path`|Mapped to a `token` search parameter whose expression resolves to the path|
|`codeFilter.code`|The value of the search parameter, expressed as one or more system and code pairs|
|`codeFilter.valueSet`|The `:in` modifier with the canonical of the value set, or the codes of an expansion of the value set|
|`dateFilter.searchParam`|Used directly as the name of the search parameter|
|`dateFilter.path`|Mapped to a `date` search parameter whose expression resolves to the path|
|`dateFilter.value`|The value of the search parameter, using prefixes for interval-valued criteria|
|`sort`|`_sort`, with the sort paths mapped to search parameters|
|`limit`|`_count`, subject to the considerations described below|
|`mustSupport`|`_elements`, subject to the considerations described below|
|`cqf-valueFilter` extension|A search parameter with a prefix or modifier corresponding to the comparator|
|`cqf-relatedRequirement` extension|`_include` or `_revinclude`, or a separate query pattern for the related data requirement|
{: .grid }{% endraw %}

**Resource type and context:** The `type` element of the data requirement determines the resource type of the query. The search parameter that relates that resource type to the subject in context is determined by the context relationships declared in the [model info](using-modelinfo.html) for the type (i.e. `contextRelationship`), which correspond to the `CompartmentDefinition` for the context type in FHIR. Where the type declares more than one relationship for the context type (for example, `Coverage` relates to `Patient` through `policyHolder`, `subscriber`, `beneficiary`, and `payor`), a single search parameter does not establish membership in the compartment, and more than one query pattern is required (see [Multiple Query Patterns](#multiple-query-patterns)). Where the server supports the compartment for the context type, as declared by `CapabilityStatement.rest.compartment`, a compartment search **SHOULD** be preferred, because a compartment search covers every relationship that establishes membership in the compartment with a single query.

**Mapping paths to search parameters:** For each filter that specifies a `path` rather than a `searchParam`, the producing system determines the search parameter to use by locating a `SearchParameter` that is supported by the server, whose `base` includes the resource type of the data requirement, whose `type` is appropriate to the filter (`token` for code filters, `date` for date filters), and whose `expression` resolves to the path given in the filter. Note that the expression of a search parameter may cover only part of a polymorphic element (e.g. `(MedicationRequest.medication as CodeableConcept)`), or may include additional restrictions (e.g. `where(resolve() is Patient)`), in which case the search parameter only partially covers the path. Where no such search parameter can be determined, the filter **SHALL** be omitted from the query pattern; producing systems **SHALL NOT** use a search parameter that does not resolve to the path of the filter.

**Terminology filters:** A code filter that references a value set can be expressed in two ways:

1. By reference, using the `:in` modifier with the canonical URL of the value set. This form is preferred where it is available, because it avoids inlining a potentially large expansion, and because it defers expansion to the server being queried. It requires that the server support the `:in` modifier and that the server be able to resolve and expand the value set.
2. By value, by expanding the value set and listing the codes of the expansion as the value of the search parameter. Multiple values for a single search parameter are ORed, so the expansion is expressed as a comma-delimited list of system and code pairs.

{% raw %}
```
Encounter?subject=Patient/{{context.patientId}}&type:in=http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292
Encounter?subject=Patient/{{context.patientId}}&type=http://snomed.info/sct|183452005,http://snomed.info/sct|32485007
```
{% endraw %}

A code filter that specifies codes directly (i.e. `codeFilter.code`, resulting from direct-reference codes in the CQL) uses the same system and code form.

When a value set is expanded and inlined, the query pattern reflects that expansion at the time the pattern was produced. The expansion **SHOULD** be performed using the expansion parameters declared for the artifact (i.e. the [`cqf-expansionParameters`]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-expansionParameters.html) extension) so that the codes used in the query are the same codes the evaluating engine will use. Because inlined expansions become stale when the value set or its code systems change, query patterns that use inlined expansions **SHOULD** be produced as part of packaging an artifact for a particular environment, where the expansion can be pinned with a manifest, rather than published as part of the artifact itself.

**Date filters:** The value of a date filter may be a `dateTime`, a `Period`, or a `Duration`:

{% raw %}
```
Observation?subject=Patient/{{context.patientId}}&date=2026-01-01T00:00:00.000-07:00
Encounter?subject=Patient/{{context.patientId}}&date=ge2026-01-01T00:00:00.000-07:00&date=le2026-12-31T23:59:59.999-07:00
```
{% endraw %}

Repeating a search parameter ANDs the criteria, so an interval is expressed with a `ge` prefix on the low boundary and an `le` prefix on the high boundary. A `Duration` value is relative to the evaluation time; if the evaluation time is not known when the query pattern is produced, the filter is omitted. Date values in query patterns **SHOULD** include a timezone offset, because a value without an offset is interpreted using the timezone of the server being queried, which may differ from the timezone used by the evaluating engine.

Note that FHIR search on a date parameter whose expression resolves to a period-valued or range-valued element uses _overlap_ semantics, whereas the CQL criteria a date filter is typically derived from (e.g. `during`) uses containment semantics. The query therefore returns a superset of the data described by the data requirement.

**Value filters:** The `comparator` element of the `cqf-valueFilter` extension is drawn from the FHIR search comparators (`eq`, `gt`, `lt`, `ge`, `le`, `sa`, and `eb`), and maps directly onto the search prefix for `number`, `date`, and `quantity` search parameters. For `token` search parameters, only `eq` can be expressed, and it is expressed as the value with no prefix. For `string` search parameters, the default search semantics is a case- and accent-insensitive starts-with match, so `eq` is expressed with the `:exact` modifier:

{% raw %}
```
Encounter?subject=Patient/{{context.patientId}}&status=finished
Observation?subject=Patient/{{context.patientId}}&value-quantity=gt40
```
{% endraw %}

**Profiles:** The `_profile` search parameter matches against the `meta.profile` element, which is a claim made by a resource instance, not a guarantee of conformance. Many servers do not index `_profile`, and many data sources hold resources that conform to a profile without declaring it. Including `_profile` in a query pattern against such a data source will exclude data the artifact requires, making the query pattern unsound. For this reason, `_profile` **SHOULD** only be used when the data source is known to tag resources with the profiles they conform to, and **SHOULD** otherwise be omitted from the query pattern, leaving conformance to be validated by the consumer.

**Sort, limit, and elements:** Where the data requirement specifies `sort`, the sort paths are mapped to search parameters in the same way as filter paths, and the query uses `_sort` (with a `-` prefix for descending order), which requires that the server support sorting on those parameters. Where the data requirement specifies `limit`, the query can use `_count`, but note that `_count` specifies a page size rather than a limit on the total number of results, so the consumer must stop after the first page for the query to be equivalent. Using `_elements` to reflect `mustSupport` is **NOT** recommended: `_elements` is a hint, to which servers may respond with more or fewer elements than were asked for, and any element the artifact requires that is not returned causes the artifact to produce incorrect results rather than an error.

**Encoding:** Values in a query pattern are URL-encoded, with the exception of the context tokens, which are substituted by the consumer before the query is performed. Within search parameter values, the characters `,`, `|`, `$`, and `\` have special meaning, and are escaped with a backslash where they appear literally in a value.

###### Determining Coverage
{: #determining-coverage}

Two distinct properties of a set of query patterns are of interest:

* **Soundness** &mdash; whether the union of the results of the query patterns includes _all_ the data described by the data requirement. Query patterns **SHALL** be sound (see [Conformance Requirement 4.4](#conformance-requirement-4-4)); an unsound query pattern causes the artifact to produce incorrect results, with no indication that anything is wrong.
* **Coverage** &mdash; how much of the data requirement is expressed in the query patterns, and therefore how much filtering the consumer must still perform on the results.

Soundness is preserved by only ever _omitting_ a criterion from the query, or expressing it with _broader_ semantics than the data requirement states. It is never preserved by narrowing a criterion, or by substituting an approximation of one, which is why criteria that cannot be mapped to a search parameter are dropped rather than approximated.

Coverage is determined by examining each element of the data requirement in turn, beginning with an assumed coverage of `total`:

1. If the criterion is not expressed in any of the query patterns, coverage is at most `partial`
2. If the criterion is expressed, but with broader semantics than the data requirement states, coverage is at most `partial`
3. If no criterion other than the resource type and the subject in context is expressed, coverage is `non`

The following situations commonly result in coverage that is less than `total`:

|Situation|Effect on Coverage|
|---|---|
|A filter path has no corresponding search parameter on the server|The filter is omitted, so the query returns resources that do not meet the criteria|
|A search parameter covers only some choices of a polymorphic element|Resources using the other choices are only returned if a query pattern is provided for each choice|
|A value set filter where the server does not support `:in` and the value set could not be expanded|The filter is omitted entirely|
|A value set filter expressed with `:in`|The expansion the server uses may differ from the expansion the evaluating engine uses|
|A date filter on a period-valued or range-valued element|Search uses overlap semantics, whereas the criteria the filter was derived from typically uses containment|
|A value filter on a string element expressed without `:exact`|The default string search is a starts-with match, and is case- and accent-insensitive|
|A profile is specified but `_profile` was not used|Conformance to the profile must be validated by the consumer|
|The subject in context is expressed with a single search parameter, but the type declares more than one context relationship|Resources related to the subject through the other relationships are only returned if a query pattern is provided for each relationship, or if a compartment search is used|
{: .grid }

###### Indicating Coverage
{: #indicating-coverage}

Because the query patterns for a data requirement are considered as a set, coverage is a characteristic of the data requirement as a whole, rather than of any individual query pattern. The [cql-fhirQueryPatternCoverage](StructureDefinition-cql-fhirQueryPatternCoverage.html) extension is used to communicate it:

{% raw %}
```json
{
  "extension": [ {
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
    "valueString": "Encounter?subject=Patient/{{context.patientId}}&type:in=http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292&status=finished&date=ge2026-01-01T00:00:00.000-07:00&date=le2026-12-31T23:59:59.999-07:00"
  }, {
    "url": "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-fhirQueryPatternCoverage",
    "valueCode": "partial"
  }, {
    "extension": [ {
      "url": "path",
      "valueString": "status"
    }, {
      "url": "comparator",
      "valueCode": "eq"
    }, {
      "url": "value",
      "valueString": "finished"
    } ],
    "url": "http://hl7.org/fhir/StructureDefinition/cqf-valueFilter"
  } ],
  "type": "Encounter",
  "profile": [ "http://hl7.org/fhir/us/qicore/StructureDefinition/qicore-encounter" ],
  "mustSupport": [ "type", "status", "period" ],
  "codeFilter": [ {
    "path": "type",
    "valueSet": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.117.1.7.1.292"
  } ],
  "dateFilter": [ {
    "path": "period",
    "valuePeriod": {
      "start": "2026-01-01T00:00:00.000-07:00",
      "end": "2026-12-31T23:59:59.999-07:00"
    }
  } ]
}
```
{% endraw %}

The coverage here is `partial`, rather than `total`, for two reasons: the profile is not expressed in the query, and the date filter on `period` is expressed with a date search parameter that uses overlap semantics. A consumer of this data requirement performs the query, and then applies the profile and date criteria to the results.

Where the coverage extension is not present, consumers **SHALL** assume a coverage of `partial` and apply the criteria of the data requirement to the results.

###### Multiple Query Patterns
{: #multiple-query-patterns}

More than one query pattern may be required to cover a single data requirement. Where multiple query patterns are present, they are ORed: each contributes to the data described by the data requirement, and the union of their results, de-duplicated by resource identity, represents the complete data for the requirement. A consumer that performs only some of the query patterns for a data requirement will be missing data the artifact requires.

**Inlined expansions:** Where a value set must be inlined rather than referenced with `:in`, the resulting list of codes may produce a URL longer than the servers and intermediaries involved will accept. In that case, the codes of the expansion are partitioned, and one query pattern is produced for each partition:

{% raw %}
```json
"extension": [ {
  "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
  "valueString": "Encounter?subject=Patient/{{context.patientId}}&type=http://snomed.info/sct|183452005,http://snomed.info/sct|32485007,http://snomed.info/sct|8715000"
}, {
  "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
  "valueString": "Encounter?subject=Patient/{{context.patientId}}&type=http://snomed.info/sct|4525004,http://snomed.info/sct|50849002,http://snomed.info/sct|305686008"
}, {
  "url": "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-fhirQueryPatternCoverage",
  "valueCode": "total"
} ]
```
{% endraw %}

Because the partitions differ only in the codes they filter on, and code filters are ORed within a single search parameter, the union of the results is exactly the result of the unpartitioned query, so coverage is unaffected by the partitioning. Consumers **MAY** instead perform the equivalent search using `POST [base]/[type]/_search` with the parameters in the body, which avoids the URL length limit; the query pattern is partitioned because the extension communicates a URL, not because the queries must be performed as separate requests.

**Polymorphic elements:** Where the path of a filter resolves to a choice-typed element, a single search parameter may cover only some of the choices. For example, `MedicationRequest.medication[x]` may be a `CodeableConcept` or a reference to a `Medication`, and the `code` search parameter only covers the `CodeableConcept` choice. Covering the data requirement requires a second query pattern that accounts for the reference:

{% raw %}
```json
"extension": [ {
  "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
  "valueString": "MedicationRequest?subject=Patient/{{context.patientId}}&code:in=http://example.org/ValueSet/Aspirin"
}, {
  "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
  "valueString": "MedicationRequest?subject=Patient/{{context.patientId}}&_include=MedicationRequest:medication"
}, {
  "url": "http://hl7.org/fhir/uv/cql/StructureDefinition/cql-fhirQueryPatternCoverage",
  "valueCode": "partial"
} ]
```
{% endraw %}

The first pattern covers medications specified as a `CodeableConcept`. The second covers medications specified as a reference, and uses `_include` to return the referenced `Medication` resources, which the artifact requires in order to evaluate the criteria. Because the code filter cannot be applied to the referenced `Medication` in the second pattern, it returns all of the subject's medication requests, and the coverage of the data requirement is `partial`. Where the server supports chained parameters, the second pattern can be made more selective by chaining through the reference (e.g. `medication.code:in=http://example.org/ValueSet/Aspirin`), which is a server capability rather than something that can be assumed.

The relationship between the `MedicationRequest` and the included `Medication` is the same relationship described by the `cqf-relatedRequirement` extension (see [Related Data Requirements](#related-data-requirements)); a related requirement can be satisfied either with `_include` on the query pattern for the requirement that references it, or with its own query pattern.

**Context relationships:** Where the type of a data requirement relates to the context type through more than one element, one query pattern is required for each relationship:

{% raw %}
```json
"extension": [ {
  "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
  "valueString": "Coverage?policy-holder=Patient/{{context.patientId}}"
}, {
  "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
  "valueString": "Coverage?subscriber=Patient/{{context.patientId}}"
}, {
  "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
  "valueString": "Coverage?beneficiary=Patient/{{context.patientId}}"
} ]
```
{% endraw %}

Where the server supports the compartment, the same data is covered by a single compartment search:

{% raw %}
```json
"extension": [ {
  "url": "http://hl7.org/fhir/StructureDefinition/cqf-fhirQueryPattern",
  "valueString": "Patient/{{context.patientId}}/Coverage"
} ]
```
{% endraw %}

###### Consuming Query Patterns
{: #consuming-query-patterns}

To use the query patterns of a data requirement, a consuming system:

1. Replaces the context tokens in each query pattern with the identity of the subject the artifact is being evaluated for
2. Resolves each query pattern against the base URL of the server to be queried
3. Performs every query pattern given for the data requirement, following paging links until all results have been retrieved
4. Takes the union of the results of all the query patterns, de-duplicating by resource type and logical id
5. Unless the coverage of the data requirement is `total`, applies the criteria of the data requirement to the results

Although query patterns are primarily used to satisfy a data requirement for a single subject, the same patterns can be used to gather data at the population level by removing the context criteria (i.e. the search parameter that relates the resource to the subject in context, or the compartment prefix), leaving the remaining criteria intact.

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
   * Note that this is **SHOULD**, rather than a **SHALL** to support existing systems that do not communicate version in this way, as well as to allow for forward-compatible representation with future versions of the CQL specification.
2. If specified, the value of the version parameter **SHALL** correspond to the _major_ and _minor_ version of a published release of the CQL specification (https://cql.hl7.org/history.html).
3. Resource narratives for Libraries and knowledge artifacts that use CQL **SHALL** include the CQL/ELM version if it is specified in the media type.

For example, the following media types indicate version 1.5 of the CQL specification.

* `text/cql; version=1.5`
* `application/elm+xml; version=1.5`
* `application/elm+json; version=1.5`

### Using Expressions
{: #using-expressions}

CQL can be used in [expression-valued elements](https://hl7.org/fhir/R4/metadatatypes.html#Expression) in the following ways:

1. To specify an unqualified expression name in the "primary" library for an artifact
2. To specify a qualified expression name in a library referenced by an artifact
3. To directly specify an inline expression

To distinguish these use cases, the `language` element of the expression value is used as specified in the [Using Expressions](https://hl7.org/fhir/R5/clinicalreasoning-topics-using-expressions.html) topic of the FHIR specification.

The "primary library" for an artifact is determined as follows:

1. If the resource type has a `library` element (e.g. PlanDefinition.library), and there is one and only one library specified, that is the primary library
2. If the resource has one and only one `cqf-library` extension, that is the primary library

If there is more than one library specified in the resource, then expression identifiers must be qualified with the name of the library (see [Conformance Requirement 2.3 (Nested Libraries)](using-cql.html#conformance-requirement-2-3)), or with the library alias as specified by the `cqf-libraryAlias` extension.

When CQL expressions are identified (i.e. using an Expression element with a language type of `text/cql-identifier`), if the expression element has a `reference`, the identifier **SHALL** be to an expression in the referenced library.

#### In-line CQL Expressions

When CQL expressions are included in-line (i.e. with a language specifier of `text/cql-expression`), then that expression **SHALL** have access to any libraries referenced by the resource (with either a `library` element or the `cqf-library` extension). This means that in-line expressions may reference declarations in those libraries by using the name of the library as a qualifier (or the `alias` as defined by the `cqf-libraryAlias` extension).

For example, given a PlanDefinition with a library element referencing the Example library in this implementation guide, the following CQL in-line expression is valid:

```cql
exists (Example."Flexible Sigmoidoscopy Performed")
```

### Must Support
{: #must-support}

Certain elements in the profiles defined in this implementation guide are marked as Must Support. This flag is used to indicate that the element plays a critical role in defining, sharing, and implementing artifacts, and implementations **SHALL** understand and process the element.

In addition, because artifact specifications typically make use of data implementation guides (e.g. International Patient Summary (IPS), US Core, AU igCore), the implications of the Must Support flag for profiles used from those implementation guides must be considered.

For more information, see the definition of [Must Support](https://hl7.org/fhir/R4/profiling.html#mustsupport) in the base FHIR specification.

**Conformance Requirement 4.7 (Must Support Elements):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-4-7)
{: #conformance-requirement-4-7}

For resource instances claiming to conform to profiles from this IG, Must Support on any profile data element **SHALL** be interpreted as follows:
* Authoring systems and knowledge repositories **SHALL** be capable of populating all Must Support data elements.
* Evaluating systems **SHALL** be capable of processing resource instances containing Must Support data elements without generating an error or causing the evaluation to fail.
* In situations where information on a particular data element is not present and the reason for absence is unknown, authoring and repository systems **SHALL NOT** include the data elements in the resource instance. For example, for systems using ‘9999’ to indicate unknown data values, do not include ‘9999’ in the resource instance.
* When consuming resource instances, evaluating systems **SHALL** interpret missing data elements within resource instances as data not present for the artifact.
* Submitting and receiving systems using knowledge artifacts to perform data exchange or artifact evaluation operations **SHALL** respect the must support requirements of the profiles used by the artifact to describe the data involved in the operation.

