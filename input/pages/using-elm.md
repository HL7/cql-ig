{:toc}

{: #using-elm}

This topic specifies conformance requirements for the use of Expression Logical Model (ELM) content as part of FHIR Knowledge Artifacts.

### Translation to ELM
{: #translation-to-elm}

Tooling exists to support translation of CQL to ELM for distribution in XML or JSON formats. These distributions can be
included with knowledge artifacts to facilitate implementation. [The existing translator tooling](https://github.com/cqframework/clinical_quality_language/blob/master/Src/java/cql-to-elm/OVERVIEW.md) applies to both measure and decision
support development, and has several options available to make use of different data models in different environments.

**Conformance Requirement 5.1 (ELM Libraries):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-5-1)
{: #conformance-requirement-5-1}

1. Compiled ELM **MAY** be distributed either independently, or in combination with the source CQL
2. Libraries that include ELM **SHALL** conform to either the [ELMJSONLibrary](StructureDefinition-elm-json-library.html) or [ELMXMLLibrary](StructureDefinition-elm-xml-library.html) (or both)
3. Compiled ELM **SHALL** be logically equivalent to the source CQL

**Conformance Requirement 5.2 (Recommended Translator Options):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-5-2)
{: #conformance-requirement-5-2}

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

#### Specifying Translator Options

The FHIR specification defines the [cqlOptions](http://hl7.org/fhir/extensions/StructureDefinition-cqf-cqlOptions.html) extension to support defining the expected translator options used with a given Library, or set of Libraries. When this extension is not used, the recommended options above **SHOULD** be used. When this extension is present on a Library, it **SHALL** be used to provide options to the translator when translating CQL for that library. When this extension is present in an asset collection or implementation guide, it **SHALL** be used to provide options to the translator unless the options are provided directly by the library.

**Conformance Requirement 5.3 (Specifying Translator Options):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-5-3)
{: #conformance-requirement-5-3}

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

**Conformance Requirement 5.4 (ELM Suitability):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-5-4)
{: #conformance-requirement-5-4}

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

