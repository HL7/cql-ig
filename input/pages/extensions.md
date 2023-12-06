{:toc}

{: #extensions}

### ModelInfo Extensions

These extensions provide the ability to configure the way that ModelInfo should be produced for a given extension, profile, or implementation guide.

<table class="grid">
  <tr><th>Extension</th><th>Description</th><th>FMM</th></tr>
 <tr><td><a href="StructureDefinition-cqf-modelInfo-isIncluded.html">ModelInfo Is Included</a> </td><td><p>Specifies whether the profile should be included in the model info constructed for an artifact collection such as an implementation guide. If this extension is not present, included is true by default for resources and profiles, but not data types (unless they are indirectly referenced by included resources or profiles). Note that even if isIncluded is false for a resource or profile, it will still be included in model info if it is a required dependency of some other included resource, profile, or data type.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">1</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-modelInfo-isRetrievable.html">ModelInfo Is Retrievable</a> </td><td><p>Specifies whether the class constructed for the profile should be marked as retrievable in the model info (meaning whether or not it can appear as the target of a retrieve expression). If this value is not specified, retrievable is true for resources and false for data types.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">1</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-modelInfo-label.html">ModelInfo Label</a> </td><td><p>Specifies the label for the class constructed in the model info for the profile (i.e. an alternative, user-friendly name that can be used as the identifier for the class in CQL expressions).</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">1</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-modelInfo-primaryCodePath.html">ModelInfo Primary Code Path</a> </td><td><p>Specifies the primary code path for the class constructed in the model info for the profile (i.e. the path to the code-valued element on the resource that should be used as the default terminology filter when no terminology target is specified in a CQL retrieve).</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">1</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-modelInfoSettings.html">ModelInfo Settings</a> </td><td><p>Specifies the settings to be used for constructing modelinfo from profile definitions.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">1</a></td></tr>
</table>

### CQL-Related Extensions

These extensions provide capabilities related to the use of CQL with FHIR knowledge artifacts.

<table class="grid">
  <tr><th>Extension</th><th>Description</th><th>FMM</th></tr>
 <tr><td><a href="StructureDefinition-cqf-cqlAccessLevel.html">CQL Access Level</a> </td><td><p>Surfaces the CQL access level of the parameter definition on which it appears.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">1</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-cqlType.html">CQL Type</a> </td><td><p>Surfaces the CQL type of the parameter definition on which it appears.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">1</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-defaultValue.html">Default Value</a> </td><td><p>Provides a default value for a parameter definition.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">3</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-fhirQueryPattern.html">FHIR Query Pattern</a> </td><td><p>A FHIR Query URL pattern that corresponds to the data specified by the data requirement. If multiple FHIR Query URLs are present, they each contribute to the data specified by the data requirement (i.e. the union of the results of the FHIR Queries represents the complete data for the data requirement). This is not a resolveable URL, in that it will contain 1) No base canonical (i.e. it's a relative query), and 2) Parameters using tokens that are delimited using double-braces and the context parameters are dependent solely on the subjectType, according to the following: Patient: context.patientId, Practitioner: context.practitionerId, Organization: context.organizationId, Location: context.locationId, Device: context.deviceId.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">3</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-isSelective.html">Is Selective</a> </td><td><p>Allows a given data requirement to be identified as &quot;selective&quot;, meaning that it can be used as an additive criteria to filter a population. A selective data requirement is guaranteed to define a subset (not necessarily proper) of the initial population of an artifact. If multiple data requirements are marked selective, they all apply (i.e. AND semantics).</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">3</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-messages.html">Messages</a> </td><td><p>An OperationOutcome that contains any information, warning, and/or error messages that were generated while processing an operation such as $evaluate or $prepopulate.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">3</a></td></tr>
 <tr><td><a href="StructureDefinition-cqf-valueFilter.html">Value Filter</a> </td><td><p>Allows additional value-based filters to be specified as part of a data requirement.</p></td><td> <a class="fmm" href="http://hl7.org/fhir/versions.html#maturity" title="Maturity Level">3</a></td></tr>
</table>

