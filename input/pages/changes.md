{: toc}

{: #changes}

This page details changes made in each version of the Using CQL with FHIR Implementation Guide.

### STU2 Publication (version 2.0.0)

#### Non-Compatible Changes

* [FHIR-50821](https://jira.hl7.org/browse/FHIR-50821): Added support for inline libraries in Library/$evaluate
* [FHIR-49606](https://jira.hl7.org/browse/FHIR-49606): Required version in narrative if present in the CQL/ELM media type
* [FHIR-49603](https://jira.hl7.org/browse/FHIR-49603): Clarified library verrsioning conformance requirement

#### Compatible, Substantive Changes

* [FHIR-50721](https://jira.hl7.org/browse/FHIR-50721): Incorporated USCoreCommon functions that are not USCore specific
* [FHIR-50473](https://jira.hl7.org/browse/FHIR-50473): Added mapping for BackboneElement and Extension and documented with examples
* [FHIR-50215](https://jira.hl7.org/browse/FHIR-50215): Added guidance on the use of the cqf-libraryAlias extension
* [FHIR-50172](https://jira.hl7.org/browse/FHIR-50172): Added precision to the mapping of quantity, decimal, and date/time values
* [FHIR-50050](https://jira.hl7.org/browse/FHIR-50050): Added includePrivate to the Library/$evaluate operation
* [FHIR-48683](https://jira.hl7.org/browse/FHIR-48683): Added support for parameter constraints
* [FHIR-48618](https://jira.hl7.org/browse/FHIR-48618): Added support empty tuple
* [FHIR-48365](https://jira.hl7.org/browse/FHIR-48365): Added ModelInfo settings outside the context of a StructureDefinition
* [FHIR-46559](https://jira.hl7.org/browse/FHIR-46559): Include child library expression results in Library/$evaluate

#### Non-Substantive Changes

* [FHIR-49740](https://jira.hl7.org/browse/FHIR-49740): Clarified ability for in-line expressions to reference declarations in libraries in context
* [FHIR-49626](https://jira.hl7.org/browse/FHIR-49626): Corrected label of changes page
* [FHIR-49625](https://jira.hl7.org/browse/FHIR-49625): Submitted "Plain Language Summary about this Guide"
* [FHIR-49605](https://jira.hl7.org/browse/FHIR-49605): Provided rationale for best-practice, rather than requirement, for version declaration in media types
* [FHIR-49604](https://jira.hl7.org/browse/FHIR-49604): Added rationale and language to library-level identifiers conformance requirement
* [FHIR-49475](https://jira.hl7.org/browse/FHIR-49475): Explain USCore-ModelInfo
* [FHIR-49379](https://jira.hl7.org/browse/FHIR-49379): Clarified representation in narrative sections for code systems, values sets, and codes
* [FHIR-49378](https://jira.hl7.org/browse/FHIR-49378): Corrected mistaken lettering in conformance requirements
* [FHIR-49317](https://jira.hl7.org/browse/FHIR-49317): Punctuation, Spelling, Spacing corrections
* [FHIR-49316](https://jira.hl7.org/browse/FHIR-49316): Clarified release language
* [FHIR-49315](https://jira.hl7.org/browse/FHIR-49315): Clarified terminology-valued types and elements
* [FHIR-49314](https://jira.hl7.org/browse/FHIR-49314): Corrected label of changes page
* [FHIR-49195](https://jira.hl7.org/browse/FHIR-49195): Clarified how profile names are constructed in ModelInfo
* [FHIR-49150](https://jira.hl7.org/browse/FHIR-49150): Updated examples and conventions for fluent function use
* [FHIR-49138](https://jira.hl7.org/browse/FHIR-49138): Updated SNOMED CT version in example
* [FHIR-49103](https://jira.hl7.org/browse/FHIR-49103): Added guidance regarding contains as a terminological operator
* [FHIR-49076](https://jira.hl7.org/browse/FHIR-49076): Corrected links to historical IGs that include previously released material
* [FHIR-48647](https://jira.hl7.org/browse/FHIR-48647): Clarified top-level expression mapping for parameters and data requirements
* [FHIR-45598](https://jira.hl7.org/browse/FHIR-45598): Clarified activity extent description and examples


### STU2 Ballot (version 2.0.0-ballot)

* [FHIR-48919](https://jira.hl7.org/browse/FHIR-48919): Updated discussion of negation to address rejected proposals use case and added activity extent discussion. Applied ([here](patterns.html#negation-in-fhir))
* [FHIR-48819](https://jira.hl7.org/browse/FHIR-48819): Documented fluent function naming convention. Applied ([here](using-cql.html#fluent-functions))
* [FHIR-48814](https://jira.hl7.org/browse/FHIR-48814): Updated examples that did not follow naming conventions. Applied ([here](using-cql.html))
* [FHIR-48641](https://jira.hl7.org/browse/FHIR-48641): Added FHIRHelpers and FHIRCommon libraries. Applied ([here](artifacts.html#knowledge-artifacts-libraries))
* [FHIR-48529](https://jira.hl7.org/browse/FHIR-48529): Noted difference in precision between CQL and FHIR date/time types. Applied ([here](conformance.html#fhir-type-mapping))
* [FHIR-48332](https://jira.hl7.org/browse/FHIR-48332): Noted Long mapping to integer64 is only available in R5 and above. Applied ([here](conformance.html#fhir-type-mapping))
* [FHIR-46423](https://jira.hl7.org/browse/FHIR-46423): Added guidance on library name length. Applied ([here](conformance.html#library-name-and-url))
* [FHIR-46112](https://jira.hl7.org/browse/FHIR-46112): Clarified mapping for lists of lists. Applied ([here](conformance.html#fhir-type-mapping))
* [FHIR-45580](https://jira.hl7.org/browse/FHIR-45580): Expanded guidance on use of terminologies. Applied ([here](patterns.html#use-of-terminologies))
* [FHIR-45579](https://jira.hl7.org/browse/FHIR-45579): Updated missing information example to improve flow. Applied ([here](patterns.html#missing-information))

### STU1 Publication (version 1.0.0)

The following changes were made as a result of comments received in the 1.0.0-ballot

> NOTE: This changelist is inclusive of changes published in the 1.0.0-snapshot version

#### Non-Compatible Changes

* [FHIR-43914](https://jira.hl7.org/browse/FHIR-43914): Simplified representation of CQL Options in Parameters Applied ([here](using-elm.html#specifying-translator-options))
* [FHIR-43908](https://jira.hl7.org/browse/FHIR-43908): Created CQL Options profile Applied ([here](StructureDefinition-cql-options.html))
* [FHIR-43762](https://jira.hl7.org/browse/FHIR-43762): CQL CQL Operation: Clarify return ([Applied here](OperationDefinition-cql-cql.html))

#### Compatible, Substantive Changes

* [FHIR-43885](https://jira.hl7.org/browse/FHIR-43885): A Conformance Requirement that SHOULD be followed is confusing Applied ([here](using-elm.html#elm-suitability))
* [FHIR-43780](https://jira.hl7.org/browse/FHIR-43780): Relax prohibition against string-based membership testing Applied ([here](using-cql.html#conformance-requirement-2-10))
* [FHIR-43698](https://jira.hl7.org/browse/FHIR-43698): Conformance requirement 2.10 - provide example Applied ([here](using-cql.html#conformance-requirement-2-10))

#### Non-Substantive Changes

* [FHIR-45296](https://jira.hl7.org/browse/FHIR-45296): QA review fixes
* [FHIR-45273](https://jira.hl7.org/browse/FHIR-45273): Added guidance on using expressions in artifacts (Applied [here](conformance.html#using-expressions))
* [FHIR-44666](https://jira.hl7.org/browse/FHIR-44666): Documented ModelInfo usage
* [FHIR-44551](https://jira.hl7.org/browse/FHIR-44551): Added examples of using CQL parameters (Applied [here](operations.html#examples))
* [FHIR-44548](https://jira.hl7.org/browse/FHIR-44548): Large number of technical corrections Applied ([here](using-cql.html#conformance-requirement-2-2)), ([here](using-cql.html#element-names)), ([here](conformance.html#conformance-requirement-4-4)), ([here](profiles.html)), and ([here](extensions.html))
* [FHIR-44541](https://jira.hl7.org/browse/FHIR-44541): Attributes versus Elements ([Applied here](using-cql.html#conformance-requirement-2-15))
* [FHIR-44512](https://jira.hl7.org/browse/FHIR-44512): add link to cqf-notDoneValueSet ([Applied here](patterns.html#negation-rationale))
* [FHIR-44113](https://jira.hl7.org/browse/FHIR-44113): Consider updating examples to align with Conformance Requirement 2.14 Applied ([here](patterns.html#presence)), ([here](patterns.html#absence)), and ([here](patterns.html#negation-rationale))
* [FHIR-44099](https://jira.hl7.org/browse/FHIR-44099): FHIR version of code structure does not include the term "using" Applied ([here](using-cql.html#code-representation-in-narrative))
* [FHIR-44091](https://jira.hl7.org/browse/FHIR-44091): Missing period ([Applied here](using-cql.html#conformance-requirement-2-10))
* [FHIR-44090](https://jira.hl7.org/browse/FHIR-44090): Consider including the terminology operators link ([Applied here](using-cql.html#conformance-requirement-2-9))
* [FHIR-44089](https://jira.hl7.org/browse/FHIR-44089): Value set is written 5 different ways Changes applied in the whole section ([here](using-cql.html#value-sets))
* [FHIR-44087](https://jira.hl7.org/browse/FHIR-44087): Missing periods ([Applied here](using-cql.html#conformance-requirement-2-6))
* [FHIR-44086](https://jira.hl7.org/browse/FHIR-44086): Confusing Terminology Applied ([here](using-cql.html#data-model))
* [FHIR-44082](https://jira.hl7.org/browse/FHIR-44082): Incomplete Sentence Applied ([here](using-cql.html#conformance-requirement-2-3))
* [FHIR-44079](https://jira.hl7.org/browse/FHIR-44079): Missing period ([Applied here](using-cql.html#conformance-requirement-2-2))
* [FHIR-44077](https://jira.hl7.org/browse/FHIR-44077): Too many spaces before colon ([Applied here](using-cql.html#conformance-requirement-2-2))
* [FHIR-44075](https://jira.hl7.org/browse/FHIR-44075): Conflicting information about underscores Applied ([here](using-cql.html#conformance-requirement-2-1))
* [FHIR-44073](https://jira.hl7.org/browse/FHIR-44073): Incorporated ModelInfo guidance from QICore Applied ([here](using-modelinfo.html))
* [FHIR-44072](https://jira.hl7.org/browse/FHIR-44072): Incorporated Patterns guidance from QICore Applied ([here](patterns.html))
* [FHIR-44071](https://jira.hl7.org/browse/FHIR-44071): Updated negation guidance ([here](patterns.html))
* [FHIR-44069](https://jira.hl7.org/browse/FHIR-44069): "When" should be lower case Applied ([here](using-cql.html#libraries))
* [FHIR-44066](https://jira.hl7.org/browse/FHIR-44066): Should Health Level 7 be upper class Applied ([here](index.html#references))
* [FHIR-44065](https://jira.hl7.org/browse/FHIR-44065): Misspelling of "Explain" in Status: Summary Applied ([here](changes.html))
* [FHIR-44063](https://jira.hl7.org/browse/FHIR-44063): Consider adding an acronyms page Applied ([here](using-cql.html)), ([here](index.html)), ([here](profiles.html)), and ([here](extensions.html))
* [FHIR-44061](https://jira.hl7.org/browse/FHIR-44061): Removed multiple periods in banner
* [FHIR-44059](https://jira.hl7.org/browse/FHIR-44059): Additional documentation on scope and purpose ([Applied here](index.html#summary))
* [FHIR-43931](https://jira.hl7.org/browse/FHIR-44059): Fixed incomplete sentence
* [FHIR-43915](https://jira.hl7.org/browse/FHIR-43915): Clarify double-braces / context in FHIR Query Pattern extension Applied ([here](extensions.html#cql-related-extensions))
* [FHIR-43901](https://jira.hl7.org/browse/FHIR-43901): Created new ModelInfoSettings profile (Applied [here](StructureDefinition-cql-modelinfosettings.html))
* [FHIR-43886](https://jira.hl7.org/browse/FHIR-43886): CQL Library Evaluate: return parameter doesn't always return all expressions ([Applied here](OperationDefinition-cql-library-evaluate.html))
* [FHIR-43882](https://jira.hl7.org/browse/FHIR-43882): Added additional details to 2.18.2 to note profiles are StructureDefinitions with derivation set to constraint
* [FHIR-43881](https://jira.hl7.org/browse/FHIR-43881): Typos: package, csn Applied ([here](using-elm.html#conformance-requirement-5-1))
* [FHIR-43877](https://jira.hl7.org/browse/FHIR-43877): Conflict in Mime Type version guidance and Library profiles Applied ([here](Library-ANCCohort.html)), ([here](Library-ELMExample.html)), ([here](StructureDefinition-elm-json-library.html)), ([here](StructureDefinition-elm-xml-library.html)), and ([here](CapabilityStatement-cql-evaluation-service.html))
* [FHIR-43795](https://jira.hl7.org/browse/FHIR-43795): Clarified Tuple and List type representation (Applied [here](conformance.html#fhir-type-mapping))
* [FHIR-43794](https://jira.hl7.org/browse/FHIR-43794): Clarified top-level expressions can return tuples and lists (Applied [here](conformance.html#fhir-type-mapping))
* [FHIR-43793](https://jira.hl7.org/browse/FHIR-43793): Clarify FHIR Type Mapping for List and Tuple types (Applied [here](conformance.html#fhir-type-mapping))
* [FHIR-43789](https://jira.hl7.org/browse/FHIR-43789): Fixed a typo in 2.14
* [FHIR-43787](https://jira.hl7.org/browse/FHIR-43787): Added Link to and example usage of cqf-notDoneValueSet (Applied [here](patterns.html#negation-rationale))
* [FHIR-43786](https://jira.hl7.org/browse/FHIR-43786): Clarified data type names section (Applied [here](using-cql.html#data-type-names))
* [FHIR-43785](https://jira.hl7.org/browse/FHIR-43785): Define or Replace "Initial Case" ([Applied here](using-cql.html#conformance-requirement-2-13))
* [FHIR-43783](https://jira.hl7.org/browse/FHIR-43783): Clarify purpose of "Representation in Narrative" section Applied ([here](using-cql.html#valueset-representation-in-narrative))
* [FHIR-43777](https://jira.hl7.org/browse/FHIR-43777): Convert text link to hyperlink ([Applied here](using-cql.html#conformance-requirement-2-9))
* [FHIR-43774](https://jira.hl7.org/browse/FHIR-43774): Fixed incomplete sentence in nested libraries ([Applied here](using-cql.html#nested-libraries))
* [FHIR-43765](https://jira.hl7.org/browse/FHIR-43765): Clarified terminologies are examples only ([Applied here](terminology.html))
* [FHIR-43764](https://jira.hl7.org/browse/FHIR-43764): Clarified description of prefetchData.data ([Applied here](OperationDefinition-cql-library-evaluate.html))
* [FHIR-43763](https://jira.hl7.org/browse/FHIR-43763): Clarified description of prefetchData.key ([Applied here](OperationDefinition-cql-library-evaluate.html))
* [FHIR-43760](https://jira.hl7.org/browse/FHIR-43760): Clarified description of prefetchData.data ([Applied here](OperationDefinition-cql-cql.html))
* [FHIR-43759](https://jira.hl7.org/browse/FHIR-43759): Clarified description of prefetchData.key ([Applied here](OperationDefinition-cql-cql.html))
* [FHIR-43758](https://jira.hl7.org/browse/FHIR-43758): Added binding to CQL Access Modifier ([Applied here](extensions.html))
* [FHIR-43755](https://jira.hl7.org/browse/FHIR-43755): Added guidance on absence of isRetrievable extension ([Applied here](extensions.html))
* [FHIR-43754](https://jira.hl7.org/browse/FHIR-43754): Added guidance on absence of isIncluded extension ([Applied here](extensions.html))
* [FHIR-43752](https://jira.hl7.org/browse/FHIR-43752): Added missing extension references ([Applied here](extensions.html))
* [FHIR-43747](https://jira.hl7.org/browse/FHIR-43747): Added a dependency slice to relatedArtifact in the CQLModule profile
* [FHIR-43742](https://jira.hl7.org/browse/FHIR-43742): Consider tightening ELM Library profile requirements w/ invariants Applied ([here](StructureDefinition-elm-json-library.html), [here](StructureDefinition-elm-xml-library.html))
* [FHIR-43741](https://jira.hl7.org/browse/FHIR-43741): CQL Module: Consider using invariant to require parameters have defaultValue or cqlType ([Applied here](StructureDefinition-cql-module-definitions.html))
* [FHIR-43740](https://jira.hl7.org/browse/FHIR-43740): CQL Module: Clarify inputParameters extension vs Library.parameter element ([Applied here](StructureDefinition-cql-module-definitions.html))
* [FHIR-43739](https://jira.hl7.org/browse/FHIR-43739): Tightened CQLModelInfo profile ([Applied here](StructureDefinition-cql-modelinfo.html))
* [FHIR-43738](https://jira.hl7.org/browse/FHIR-43738): Tightened CQLLibrary profile ([Applied here](StructureDefinition-cql-library.html))
* [FHIR-43737](https://jira.hl7.org/browse/FHIR-43737): Clarify use of data absent reason codes in CQL Evaluation Result Applied ([here](StructureDefinition-cql-evaluationresult.html))
* [FHIR-43734](https://jira.hl7.org/browse/FHIR-43734): Mismatch between CQL Capability Statement profile and example Applied ([here](StructureDefinition-cql-capabilitystatement.html))
* [FHIR-43733](https://jira.hl7.org/browse/FHIR-43733): Typo: A library profiles Applied ([here](profiles.html#profiles))
* [FHIR-43732](https://jira.hl7.org/browse/FHIR-43732): Incorrect reference to CRMI IG Applied ([here](conformance.html#conformance-requirement-4-7))
* [FHIR-43731](https://jira.hl7.org/browse/FHIR-43731): Page listing does not match menu Applied ([here](index.html#how-to-read-this-guide)) and in menu.xml
* [FHIR-43703](https://jira.hl7.org/browse/FHIR-43703): Updated example in Concepts to include a code from another system
* [FHIR-43666](https://jira.hl7.org/browse/FHIR-43666): Fixed incomplete sentence
* [FHIR-43665](https://jira.hl7.org/browse/FHIR-43665): Clarified conformance requirement 1.1 (Applied [here](conformance.html#conformance-requirement-4-7))
* [FHIR-43582](https://jira.hl7.org/browse/FHIR-43582): Added -version to the CQL naming convention conformance requirement 2.18
* [FHIR-43581](https://jira.hl7.org/browse/FHIR-43581): Clarified negation guidance
* [FHIR-43480](https://jira.hl7.org/browse/FHIR-43480): Typo in Conformance Requirement 2.17
* [FHIR-43479](https://jira.hl7.org/browse/FHIR-43479): Removed quotes from parameters in the example in 2.8
* [FHIR-43439](https://jira.hl7.org/browse/FHIR-43439): Clarified human readable representation of codes
* [FHIR-43436](https://jira.hl7.org/browse/FHIR-43436): Finished sentence on 2.1.2 
* [FHIR-43425](https://jira.hl7.org/browse/FHIR-43425): Fixed reference to CRMI
* [FHIR-43418](https://jira.hl7.org/browse/FHIR-43418): Typo fixes on using CQL page
* [FHIR-43340](https://jira.hl7.org/browse/FHIR-43340): Clarified modelInfoSettings

### Initial STU 1 Ballot Changes (version 1.0.0-ballot)

This is the first ballot of this implementation guide in this form, but the content has been balloted and published in multiple prior implementation guides, including:

Change Summary
This ballot made the following major changes:

* [Clinical Guidelines](http://hl7.org/fhir/uv/cpg/libraries.html)
* [Quality Measures](https://hl7.org/fhir/us/cqfmeasures/using-cql.html)
* [Canonical Resource Management Infrastructure](http://hl7.org/fhir/uv/crmi/2023Sep/using-cql.html)

The following changes were made as a result of ballot comments received in the September 2023 ballot of the Canonical Resource Management Infrastructure IG. One of those comments was the suggestion to break this CQL-specific content out into its own implementation guide; this IG is the result of that change.

* [FHIR-43076](https://jira.hl7.org/browse/FHIR-43076): Use a dataAbsentReason extension to indicate missing results
* [FHIR-43075](https://jira.hl7.org/browse/FHIR-43075): Add guidance on missing information
* [FHIR-42921](https://jira.hl7.org/browse/FHIR-42921): Consider requiring the use of a SignatureLevel higher than none
* [FHIR-42574](https://jira.hl7.org/browse/FHIR-42574): Libraries are not required for CQL
* [FHIR-42573](https://jira.hl7.org/browse/FHIR-42573): Explaing conformance requirement 4.12
* [FHIR-42571](https://jira.hl7.org/browse/FHIR-42571): Representation in a Library needs clarification
* [FHIR-42570](https://jira.hl7.org/browse/FHIR-42570): Code URI expectation inconsistent
* [FHIR-42569](https://jira.hl7.org/browse/FHIR-42569): What is "knowledge artifact CQL"?
* [FHIR-42568](https://jira.hl7.org/browse/FHIR-42568): Why so much discussion about VSAC in an international spec?
* [FHIR-42567](https://jira.hl7.org/browse/FHIR-42567): Use a value set avoiding OIDs
* [FHIR-42566](https://jira.hl7.org/browse/FHIR-42566): Update location of code system URIs
* [FHIR-42565](https://jira.hl7.org/browse/FHIR-42565): How is the association between a namespace and URI established?
* [FHIR-42562](https://jira.hl7.org/browse/FHIR-42562): Put versioning stuff together
* [FHIR-42561](https://jira.hl7.org/browse/FHIR-42561): Explain identifier rules
* [FHIR-42560](https://jira.hl7.org/browse/FHIR-42560): Better explain library declarations
* [FHIR-42559](https://jira.hl7.org/browse/FHIR-42559): Clarify language around CQL artifacts
* [FHIR-41869](https://jira.hl7.org/browse/FHIR-41869): No content in this ModelInfo section of Using CQL
* [FHIR-41868](https://jira.hl7.org/browse/FHIR-41868): Provide more context in examples
