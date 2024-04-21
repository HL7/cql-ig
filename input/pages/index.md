

{:toc}

<!--
Where possible, new and updated content will be highlighted with green text and background.
{:.new-content}
-->

{: #using-cql-with-fhir-implementation-guide}

### Summary
{: #summary}

[Clinical Quality Language (CQL)](http://cql.hl7.org) is a clinically-focused query language that can be used to express logic in a broad range of healthcare use cases, including clinical decision and cognitive support, public health and quality reporting, computable clinical guidelines, research trial eligibility, and many others. Several implementation guides have been published that include conformance criteria related to the use of CQL in these contexts. This implementation guide is the result of extracting common aspects of that support to a universal realm, broadly applicable implementation guide that supports the use of CQL with Fast Healthcare Interoperability Resources (FHIR). Future versions of those implementation guides should consider referencing the conformance and guidance established here.

Note that although this is a first release of this implementation guide, the content has been balloted, published, reviewed, implemented, and refined over many years as part of the [Quality Measure Implementation Guide](https://hl7.org/fhir/us/cqfmeasures), [FHIR Clinical Guidelines](https://hl7.org/fhir/uv/cpg), [Quality Improvement Profile (QI-Core)](https://hl7.org/fhir/us/qicore), and the [Canonical Resource Management Infrastructure IG](https://hl7.org/fhir/uv/crmi).

Some of the conformance language and requirements described in this implementation guide, particularly around the use of terminology, may be applicable more broadly. We propose the inclusion of appropriate conformance requirements and guidance in a future version of the CQL specification.

### Scope of Use

The intent of this implementation guide is to support the use of CQL with FHIR in general. It is a universal realm specification and is intended to be broadly applicable to any use case that involves libraries or expressions of CQL evaluating against FHIR resources, including:

* Library profiles to support packaging of CQL (and compiled CQL, or Expression Logical Model (ELM)) as FHIR Library resources
* Evaluation support profiles to facilitate the representation of structured information about a logic library, as well as the result of evaluating a logic library
* CQL Evaluation Service capability statement
* Model Information (ModelInfo)-related profiles to facilitate configuration of ModelInfo for FHIR implementation guides

### How to read this Guide
{: #how-to-read-this-guide}

#### Target Audiences

This implementation guide is targeted at two main audiences:

1. **Authors**: Persons involved in the development of CQL-based FHIR Knowledge Artifacts that are authoring CQL, either directly or with tooling assistance
2. **Integrators**: Persons involved in the development of systems that support authoring, publishing, distributing, and implementing CQL-based FHIR Knowledge Artifacts

This Guide is divided into several pages which are listed at the top of each
page in the menu bar:
-  **[Home](index.html)**: Summary and background information on Using CQL with FHIR.
-  **Authoring**:
    -  **[Using CQL](using-cql.html)**: Conformance requirements for using Clinical Quality Language as part of authoring FHIR Knowledge Artifacts.
    -  **[Patterns](patterns.html)**: Patterns and guidance for using Clinical Quality Language as part of authoring FHIR Knowledge Artifacts.
-  **Integrating**:
    -  **[Conformance](conformance.html)**: Conformance requirements for integrating Clinical Quality Language as part of systems that support authoring, publishing, distribution, and implementing FHIR Knowledge Artifacts.
    -  **[Using ELM](using-elm.html)**: Conformance requirements for the use of Expression Logical Model (ELM) artifacts.
    -  **[Using ModelInfo](using-modelinfo.html)**: Conformance requirements for the use of Model Info.
-  **Artifacts**: 
    -  **[Profiles](profiles.html)**: List of profiles defined for use by knowledge artifacts.
    -  **[Extensions](extensions.html)**: List of extensions defined and used by knowledge artifacts.
    -  **[Operations](operations.html)**: List of operations and operation pattern profiles.
    -  **[Capabilities](capabilities.html)**: Definitions of services and operations in support of authoring, publishing, and distributing canonical resources and knowledge artifacts.
    -  **[Terminology](terminology.html)**: List of CodeSystems and ValueSets.
    -  **[Artifacts Summary](artifacts.html)**: List of the FHIR artifacts defined as part of this implementation guide.
-  **[Downloads](downloads.html)**: Links to downloadable artifacts for implementations.
-  **[Version History](changes.html)**: Changes made in each version of the Using CQL with FHIR Implementation Guide.

### Acknowledgements

This Implementation Guide was made possible by the thoughtful contributions of the following people and organizations:

* Brian Kaney, Vermonster - Editor
* Bryant Austin, Smile Digital Health - Contributor
* Clinical Quality Information (CQI) Work Group
* Michael Holck, ICF - Contributor
* Ewout Kramer, Firely - Contributor
* Carl Leitner - Contributor
* Rob McClure, Md Partners - Contributor
* Evan Muchasak, NCQA - Contributor
* Rob Reynolds, Smile Digital Health - Contributor
* Brenin Rhodes, Smile Digital Health - Contributor
* Bryn Rhodes, Smile Digital Health - Editor
* Derek Ritz - Contributor
* Chris Schuler, Smile Digital Health - Contributor
* Jennifer Seeman, ICF - Contributor
* Adam Stevenson, Smile Digital Health - Contributor

In addition, the editors would like to thank the many reviewers that provided detailed and insightful comments as part of balloting and preparation of this content, including Chris Moesel, Lloyd McKenzie, Jonathan Percival, Yan Heras, Paul Denning, Juliet Rubini, Angela Flanagan, Isaac Vetter, and many others.

### References
{: #references}

Health Level Seven. Clinical Quality Framework - HL7 Clinical Decision Support Work Group Confluence Page. [Online]. Available from: [https://confluence.hl7.org/display/CQIWC/Clinical Quality Framework](https://confluence.hl7.org/display/CQIWC/Clinical%20Quality%20Framework) [Accessed 11 October 2019].

Health Level Seven. Clinical Quality Language. [Online]. Available from: [http://cql.hl7.org](http://cql.hl7.org) [Accessed October 2023].

Health Level Seven. FHIR Clinical Guidelines. [Online]. Available from: [http://hl7.org/fhir/uv/cpg](http://hl7.org/fhir/uv/cpg) [Accessed October 2023].

Health Level Seven. Canonical Resource Management Infrastructure (Ballot). [Online]. Available from: [http://hl7.org/fhir/uv/crmi/2023Sep](http://hl7.org/fhir/uv/crmi/2023Sep) [Accessed October 2023].

Health Level Seven. Quality Measure Implementation Guide. [Online]. Available from: [http://hl7.org/fhir/us/cqfmeasures](http://hl7.org/fhir/us/cqfmeasures) [Accessed October 2023].

Health Level Seven. HL7 Cross-Paradigm Specification: Representing Negatives. [Online]. Available from: [https://www.hl7.org/implement/standards/product_brief.cfm?product_id=592](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=592) [Accessed March 2024].

Health Level Seven. FHIR Quality Profile. [Online]. Available from: [http://hl7.org/fhir/us/qicore](http://hl7.org/fhir/us/qicore) [Accessed March 2024].

Health Level Seven. US Core. [Online]. Available from: [http://hl7.org/fhir/us/core](http://hl7.org/fhir/us/core) [Accessed March 2024].

### Dependencies

{% include dependency-table-short.xhtml %}

### Cross Version Analysis

{% include cross-version-analysis.xhtml %}

### Global Profiles

{% include globals-table.xhtml %}

### IP Statements

{% include ip-statements.xhtml %}
