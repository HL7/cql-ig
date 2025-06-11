{:toc}

{: #using-modelinfo}

This topic specifies conformance requirements for the use of Model Information as part of FHIR Knowledge Artifacts that make use of Clinical Quality Language (CQL).

### ModelInfo
{: #modelinfo}

To use CQL with FHIR, [model information (ModelInfo)](https://cql.hl7.org/07-physicalrepresentation.html#data-model-references) must be provided to the implementation environment. To create this ModelInfo FHIR StructureDefinition resources can be processed according to the following rules:

1. For each StructureDefinition, if the kind is `primitive-type`, `complex-type` (except for types based on Extension), or `resource` (with no derivation or a derivation of `specialization`), a ClassInfo with the same name as the structure definition is created
    1. For each element:
        1. If the element is not a backbone element, a corresponding element with the name and type is added to the ClassInfo. If the maximum cardinality of the element is not "1", the element is created as a list type.
        2. If the element is a backbone element, a new ClassInfo is created with the child elements of the backbone element and a new element is added to the containing ClassInfo with the type of the ClassInfo. Note that this process is recursive and so may result in multiple levels of nested class creation. As such the name of the ClassInfo must include the name of all the parent classes as qualifiers in order to ensure uniqueness. This approach also supports the ability of FHIR elements to reference other element definitions, though a post-processing fixup step is typically needed to resolve these references.

If this process is run against the StructureDefinitions from the base FHIR specification, it produces a complete representation of all the FHIR Resources as classes in the ModelInfo. However, because FHIR primitive types actually have elements (e.g. `value`, `id`, and `extension`), this process produces classes in the ModelInfo for each of the FHIR primitive types, and only the `value` elements of these FHIR primitives are typed with the actual CQL primitive types. This means that to access the actual values of FHIR elements for comparison against CQL primitive values, the `.value` path must be used:

```cql
Patient.gender.value = 'female'
```

To facilitate comparison by authors, these primitives can be implicitly converted to CQL primitive types, and the [FHIRHelpers](Library-FHIRHelpers.html) library (generated alongside the [FHIR-ModelInfo](Library-FHIR-ModelInfo.html)) defines these implicit conversions.

To make use of these implicit conversions within a CQL library, include the FHIRHelpers library:

```cql
include hl7.fhir.uv.cql.FHIRHelpers version '4.0.1'
```

> NOTE: Previous versions of the FHIRHelpers library were included A) as embedded resources in the CQL-to-ELM translator (referenced without a namespace and the version `4.0.1`), as well as B) in the CQFramework Common implementation guide (referenced with the namespace `fhir.cqf.common` and the version `4.0.1`). In both these cases, the content is the same as what is now published in this implementation guide, with the namespace `hl7.fhir.uv.cql` and the version `4.0.1`. Note that the version here is explicitly aligned with the FHIR specification version, because the FHIRHelpers library is generated as part of the process of constructing the model information and so is cohesively tied to the FHIR specification version.

#### ModelInfo Libraries

Similar to CQL content, ModelInfo can be included in FHIR Library resources to facilitate distribution.

**Conformance Requirement 6.1 (ModelInfo Libraries):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-6-1)
{: #conformance-requirement-6-1}

1. Libraries used to package ModelInfo **SHALL** conform to the [CQLModelInfo](StructureDefinition-cql-modelinfo.html) profile
1. The identifying elements of a modelinfo **SHALL** conform to the following requirements:
* Library.url **SHALL** be `<CQL model namespace url>/Library/<CQL model name>-ModelInfo`
* Library.name **SHALL** be `<CQL model name>`
* Library.version **SHALL** be `<CQL model version>`
2. For model info libraries included in FHIR implementation guides, the CQL model namespace is defined by the implementation guide as follows:
* CQL model namespace name **SHALL** be IG.packageId of the implementation guide being described by the model info
* CQL model namespace url **SHALL** be IG.canonicalBase of the implementation guide being described by the model info
3. To avoid issues with characters between web ids and names, CQL model names **SHALL NOT** have underscores.

The prohibition against underscores in CQL model names is required to ensure compliance with the canonical URL pattern (because URLs by convention should not use underscores). In addition, many publishing environments will use the canonical tail (i.e. the name of the library) as the logical id of the Library resource, which does not allow underscores per the FHIR specification.

This implementation guide includes [FHIR-ModelInfo](Library-FHIR-ModelInfo.html), a ModelInfo for FHIR version 4.0.1.

> NOTE: Previous versions of the FHIR-ModelInfo library were included A) as embedded resources in the CQL-to-ELM translator (referenced without a namespace and the semantic version of the FHIR specification being modeled), as well as B) in the CQFramework Common implementation guide (referenced with the canonical reference `http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1`). The content of the 4.0.1 version of this ModelInfo is the same as what is now published in this implementation guide, with the canonical reference `http://hl7.org/fhir/uv/cql/Library/FHIR-ModelInfo|4.0.1`. Note the model information version here is explicitly aligned with the FHIR specification version being modeled, not the version of this implementation guide. This is to avoid any confusion about what version of the FHIR model is being used in a given CQL library.

#### Derived ModelInfo
{: #derived-modelinfo}

CQL can be used with a FHIR ModelInfo directly, as described above. However, FHIR profiles include a wealth of computable information about the intended structure of the clinical data involved in an exchange, including terminology bindings, constraints, descriptive metadata, _slices_, and _extensions_. To facilitate authoring that can easily reference this information, the tooling to construct ModelInfo from the base FHIR StructureDefinitions has been enhanced to support building ModelInfo that is specific to an implementation guide.

There are multiple approaches to generating ModelInfo based on the profiles in an implementation guide. The first of these is _Derived ModelInfo_, which performs the following step for each profile:

1. Each profile (StructureDefinition with derivation set to `constraint`) results in a new ClassInfo in the ModelInfo, derived from the ClassInfo for the baseDefinition of the profile
    1. `namespace` is set to the `modelName`
    2. `name` is set to the `name` element of the StructureDefinition (without the prefix if the name is prefixed with the modelName)
    3. `baseType` is set to the qualified name of the class corresponding to the `baseDefinition`
    4. `identifier` is set to the canonical `url` of the StructureDefinition
    5. `label` is set to the `title` of the StructureDefinition (unless overridden by the cqf-modelInfo-label extension)
    6. `retrievable` is set to `true` (unless overridden by the cqf-modelInfo-isRetrievable extension)
    7. `primaryCodePath` is set based on the cqf-modelInfo-primaryCodePath extenssion

For example, processing the US Core 7.0.0 implementation guide produces a ModelInfo with a ClassInfo for the EncounterProfile:

```cql
using USCore version '7.0.0'

...

define "Encounters":
  ["EncounterProfile"]
```

Conceptually, this expression results in any Encounter resource that conforms to the US Core Encounter Profile.

> NOTE: How systems implement the requirement that retrieve expressions only result in resource instances that conform to the requested profile is not prescribed, because there are many different ways this requirement can be achieved. Because profile conformance testing can be expensive, there are performance tradeoffs associated with how this is done in any particular environment.

#### Profile-informed ModelInfo
{: #profile-informed-modelinfo}

The second widely used approach to generating ModelInfo based on the profiles in an implementation guide is called _Profile-informed Authoring_, and takes greater advantage of the information defined in profiles, including slices and extensions. However, it also "flattens" the types produced in the ModelInfo, so that authors are presented with a complete picture of FHIR from the perspective of the particular implementation guide. This approach has some advantages, but it also has the primary disadvantage of preventing reuse of logic across implementation guides, because profiles in each implementation guide result in entirely separate classes in CQL. 

This approach has been used for artifacts authored with USCore and QICore versions 6 and below, and is constructed by performing the following steps for each profile:

1. Each profile (StructureDefinition with derivation set to `constraint`) results in a new ClassInfo in the ModelInfo, derived from the ClassInfo for the baseDefinition of the profile
    1. `namespace` is set to the `modelName`
    2. `name` is set to the `name` element of the StructureDefinition
    3. `baseType` is set to the qualified name of the class corresponding to the `type` (as opposed to the `baseDefinition` used for Derived ModelInfo)
    4. `identifier` is set to the canonical `url` of the StructureDefinition
    5. `label` is set to the `title` of the StructureDefinition (unless overridden by the cqf-modelInfo-label extension)
    6. `retrievable` is set to `true` (unless overridden by the cqf-modelInfo-isRetrievable extension)
    7. `primaryCodePath` is set based on the cqf-modelInfo-primaryCodePath extenssion
2. FHIR Primitive types are mapped to CQL types according to the [FHIR Type Mapping](conformance.html#fhir-type-mapping) section.
3. Extensions and slices defined in profiles are represented as first-class elements in the ClassInfo. Specifically, ClassInfo structures are created with elements as defined by the slice or extension definitions.
    1. For slices, a new ClassInfo is created derived from the ClassInfo corresponding to the element being sliced, and named based on the `sliceName` element of the slice definition. An element of this type and named with the `sliceName` is then added to the containing ClassInfo.
    2. For extensions, a new ClassInfo is created derived from the `Extension` ClassInfo and named based on the `name` of the extension definition. An element of this type and named with the extension `sliceName` is then added to the containing ClassInfo.
4. If a terminology-valued element has a `cqf-notDoneValueSet` or `codeOptions` extension defined, the element is typed as a Choice of the terminology-value (CodeableConcept, Coding, or Code) and ValueSet, allowing retrieves to be performed against the ValueSet referenced by the cqf-notDoneValueSet or codeOptions extension

For example, consider the [US Core Blood Pressure Profile](https://hl7.org/fhir/us/core/StructureDefinition-us-core-blood-pressure.html). This profile has two slices of the `component` element, named `systolic` and `diastolic`. The resulting USCore ModelInfo has classes derived from the `USCore.Observation.Component` class:

```xml
  <typeInfo xsi:type="ClassInfo" namespace="USCore" name="Observation.Component.systolic" retrievable="false" baseType="USCore.Observation.Component"/>
  <typeInfo xsi:type="ClassInfo" namespace="USCore" name="Observation.Component.diastolic" retrievable="false" baseType="USCore.Observation.Component"/>
```

and then elements in the `USCore.BloodPressureProfile` class corresponding to these slices:

```xml
  <element name="systolic" elementType="USCore.Observation.Component.systolic"/>
  <element name="diastolic" elementType="USCore.Observation.Component.diastolic"/>
```

For extensions, consider the [US Core Ethnicity Extension](https://hl7.org/fhir/us/core/StructureDefinition-us-core-ethnicity.html). This is a complex extension, and so the constructed ClassInfo has elements for each of the elements defined by the extension:

```xml
  <typeInfo xsi:type="ClassInfo" namespace="USCore" name="EthnicityExtension" identifier="http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity" label="US Core Ethnicity Extension" retrievable="false" baseType="USCore.Extension">
      <element name="ombCategory" elementType="System.Code"/>
      <element name="detailed">
          <elementTypeSpecifier xsi:type="ListTypeSpecifier" elementType="System.Code"/>
      </element>
      <element name="text" elementType="System.String"/>
      <element name="url" elementType="System.String"/>
  </typeInfo>
```

And the `USCore.PatientProfile` class then has an element named `ethnicity` of this type:

```xml
  <element name="ethnicity" elementType="USCore.EthnicityExtension"/>
```

> NOTE: Importantly, with profile-informed modelinfo, each element in the modelinfo includes a `target` mapping that specifies an expansion to be performed by the translator so that access in the ELM is performed directly against the base FHIR resources, rather than requiring engines (and by extension runtime environments) to deal with data in terms of the profile definitions. As a result, the ELM output of CQL libraries using profile-informed authoring is in terms of the base FHIR resources. Note that for implementations that support profile-informed CQL, this means that the result of retrieve expressions must respect the profile stated in the `templateId` element of the retrieve. This is not to say that the FHIR resource must declare profiles to which they conform, only that with profile-informed authoring, there is an expectation that the ELM expects that FHIR resources returned through a retrieve will conform to the stated profiles. How that conformance is guaranteed is left up to implementations.

#### ModelInfo Settings

In addition, to support more fine-grained control over the process of producing ModelInfo from FHIR StructureDefinitions, this implementation guide defines several ModelInfo-related extensions:

* [cqf-modelInfo-isIncluded]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-modelInfo-isIncluded.html) - Determines whether to create a ClassInfo for the profile or extension on which it appears
* [cqf-modelInfo-isRetrievable]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-modelInfo-isRetrievable.html) - Determines whether the ClassInfo for the profile on which it appears is marked retrievable (i.e. can appear as the target type of a Retrieve in CQL)
* [cqf-modelInfo-label]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-modelInfo-label.html) - Specifies an author-friendly title for the ClassInfo (i.e. an alternate name by which the type can be referenced in CQL type specifiers)
* [cqf-modelInfo-primaryCodePath]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-modelInfo-primaryCodePath.html) - Specifies the primary code path for the ClassInfo produced from the profile on which it appears (i.e. the default path for terminology-valued filters when the type is used in a Retrieve in CQL)
* [cqf-modelInfoSettings]({{site.data.fhir.ver.ext}}/StructureDefinition-cqf-modelInfoSettings.html) - Specifies additional settings used to produce the ModelInfo for profiles and extensions defined in the Implementation Guide on which it appears

> NOTE: All the setting information provided by the StructureDefinition extensions (cqf-modelInfo-...) can be provided directly in the cqf-modelInfoSettings Parameters resource to support the case where the StructureDefinition resources being used for generation are already published or otherwise not under the authoring control of the model information author.
