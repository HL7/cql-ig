

{:toc}

<!--
Where possible, new and updated content will be highlighted with green text and background.
{:.new-content}
-->

<div markdown="1" class="bg-info">

This is the first ballot of this implementation guide in this form, but the content has been balloted and published in multiple prior implementation guides, including:

* [Clinical Guidelines](http://hl7.org/fhir/uv/cpg/libraries.html)
* [Quality Measures](https://hl7.org/fhir/us/cqfmeasures/using-cql.html)
* [Canonical Resource Management Infrastructure](http://hl7.org/fhir/uv/crmi/2023Sep/using-cql.html)

The following changes were made as a result of ballot comments received in the September 2023 ballot of the Canonical Resource Management Infrastructure IG. One of those comments was the suggestion to break this CQL-specific content out into its own implementation guide; this IG is the result of that change.

{{ site.data.package-list.list[0].desc }}

</div>

{: #using-cql-with-fhir-implementation-guide}

### Summary
{: #summary}

[Clinical Quality Language (CQL)](http://cql.hl7.org) is a clinically-focused query language that can be used to express logic in a broad range of healthcare use cases, including clinical decision and cognitive support, public health and quality reporting, computable clinical guidelines, research trial eligibility, and many others. Several implementation guides have been published that include conformance criteria related to the use of CQL in these contexts. This implementation guide is the result of extracting common aspects of that support to a universal realm, broadly applicable implementation guide that supports the use of CQL with FHIR. Future versions of those implementation guides should consider referencing the conformance and guidance established here.

### Scope of Use

The intent of this implementation guide is to support the use of CQL with FHIR in general. It is a universal realm specification and is intended to be broadly applicable to any use case that involves libraries or expressions of CQL evaluating against FHIR resources, including:

* Library profiles to support packaging of CQL (and compiled CQL, or ELM) as FHIR Library resources
* Evaluation support profiles to facilitate the representation of structured information about a logic library, as well as the result of evaluating a logic library
* CQL Evaluation Service capability statement
* ModelInfo-related profiles to facilitate configuration of ModelInfo for FHIR implementation guides

### How to read this Guide
{: #how-to-read-this-guide}

This Guide is divided into several pages which are listed at the top of each
page in the menu bar:

-  **[Home](index.html)**: Summary and background information for the Canonical Resource Management Infrastructure Implementation Guide
-  **[Using CQL](using-cql.html)**: Using Clinical Quality Language as part of knowledge artifacts
-  **[Profiles](profiles.html)**: List of profiles defined for use by knowledge artifacts
-  **[Extensions](extensions.html)**: List of extensions defined and used by knowledge artifacts
-  **[Operations](operations.html)**: List of operations and operation pattern profiles
-  **[Capabilities](capabilities.html)**: Definitions of services and operations in support of authoring, publishing, and distributing canonical resources and knowledge artifacts
-  **[Downloads](downloads.html)**: Links to downloadable artifacts for implementations.
-  **[Acknowledgements](acknowledgements.html)**

### Must Support

Certain elements in the profiles defined in this implementation guide are marked as Must Support. This flag is used to indicate that the element plays a critical role in defining, sharing, and implementing artifacts, and implementations **SHALL** understand and process the element.

In addition, because artifact specifications typically make use of data implementation guides (e.g. IPS, US Core, QI-Core), the implications of the Must Support flag for profiles used from those implementation guides must be considered.

For more information, see the definition of [Must Support](https://hl7.org/fhir/R4/profiling.html#mustsupport) in the base FHIR specification.

**Conformance Requirement 1.1 (Must Support Elements):** [<img src="conformance.png" width="20" class="self-link" height="20"/>](#conformance-requirement-1-1)
{: #conformance-requirement-1-1}

For resource instances claiming to conform to profiles from this IG, Must Support on any profile data element **SHALL** be interpreted as follows:
* Authoring systems and knowledge repositories **SHALL** be capable of populating all Must Support data elements.
* Evaluating systems **SHALL** be capable of processing resource instances containing Must Support data elements without generating an error or causing the evaluation to fail.
* In situations where information on a particular data element is not present and the reason for absence is unknown, authoring and repository systems **SHALL NOT** include the data elements in the resource instance. For example, for systems using ‘9999’ to indicate unknown data values, do not include ‘9999’ in the resource instance.
* When consuming resource instances, evaluating systems **SHALL** interpret missing data elements within resource instances as data not present for the artifact.
* Submitting and receiving systems using knowledge artifacts to perform data exchange or artifact evaluation operations **SHALL** respect the must support requirements of the profiles used by the artifact to describe the data involved in the operation.

### References
{: #references}

Health level seven. Clinical Quality Framework - HL7 Clinical Decision Support Work Group Confluence Page. [Online]. Available from: [https://confluence.hl7.org/display/CQIWC/Clinical Quality Framework](https://confluence.hl7.org/display/CQIWC/Clinical%20Quality%20Framework) [Accessed 11 October 2019].

### Dependencies

{% include dependency-table-short.xhtml %}

### Cross Version Analysis

{% include cross-version-analysis.xhtml %}

### Global Profiles

{% include globals-table.xhtml %}

### IP Statements

{% include ip-statements.xhtml %}
