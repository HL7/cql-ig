{: toc}

{: #changes}

This page details changes made in each version of the Using CQL with FHIR Implementation Guide.
### STU1 Reconciliation Changes (version 1.0.0-ballot)

The following changes were made as reconciliation of issues raised in the 1.0.0-ballot

{{ site.data.package-list.list[0].desc }}

### Initial STU 1 Ballot Changes (version 1.0.0-ballot)

This is the first ballot of this implementation guide in this form, but the content has been balloted and published in multiple prior implementation guides, including:

Change Summary
This ballot made the following major changes:

* [Clinical Guidelines](http://hl7.org/fhir/uv/cpg/libraries.html)
* [Quality Measures](https://hl7.org/fhir/us/cqfmeasures/using-cql.html)
* [Canonical Resource Management Infrastructure](http://hl7.org/fhir/uv/crmi/2023Sep/using-cql.html)

The following changes were made as a result of ballot comments received in the September 2023 ballot of the Canonical Resource Management Infrastructure IG. One of those comments was the suggestion to break this CQL-specific content out into its own implementation guide; this IG is the result of that change.

- Use a dataAbsentReason extension to indicate missing results([FHIR-43076](https://jira.hl7.org/browse/FHIR-43076))
- Add guidance on missing information([FHIR-43075](https://jira.hl7.org/browse/FHIR-43075))
- Consider requiring the use of a SignatureLevel higher than none([FHIR-42921](https://jira.hl7.org/browse/FHIR-42921))
- Libraries are not required for CQL([FHIR-42574](https://jira.hl7.org/browse/FHIR-42574))
- Explaing conformance requirement 4.12([FHIR-42573](https://jira.hl7.org/browse/FHIR-42573))
- Representation in a Library needs clarification([FHIR-42571](https://jira.hl7.org/browse/FHIR-42571))
- Code URI expectation inconsistent([FHIR-42570](https://jira.hl7.org/browse/FHIR-42570))
- What is "knowledge artifact CQL"?([FHIR-42569](https://jira.hl7.org/browse/FHIR-42569))
- Why so much discussion about VSAC in an international spec?([FHIR-42568](https://jira.hl7.org/browse/FHIR-42568))
- Use a value set avoiding OIDs([FHIR-42567](https://jira.hl7.org/browse/FHIR-42567))
- Update location of code system URIs([FHIR-42566](https://jira.hl7.org/browse/FHIR-42566))
- How is the association between a namespace and URI established?([FHIR-42565](https://jira.hl7.org/browse/FHIR-42565))
- Put versioning stuff together([FHIR-42562](https://jira.hl7.org/browse/FHIR-42562))
- Explain identifier rules([FHIR-42561](https://jira.hl7.org/browse/FHIR-42561))
- Better explain library declarations([FHIR-42560](https://jira.hl7.org/browse/FHIR-42560))
- Clarify language around CQL artifacts([FHIR-42559](https://jira.hl7.org/browse/FHIR-42559))
- No content in this ModelInfo section of Using CQL([FHIR-41869](https://jira.hl7.org/browse/FHIR-41869))
- Provide more context in examples([FHIR-41868](https://jira.hl7.org/browse/FHIR-41868))
- Added -version to the CQL naming convention conformance requirement 2.18 ([FHIR-43582](https://jira.hl7.org/browse/FHIR-43582))
