### FHIR ModelInfo

This implementation guide includes the model information for the base FHIR specification, [FHIR-ModelInfo](Library-FHIR-ModelInfo.html). The following table lists the available classes, the base resource type which they represent, and the primary code path established for each class:


|---|---|
|[Account]({{site.data.fhir.ver}}/Account.html)|type|
|[ActivityDefinition]({{site.data.fhir.ver}}/ActivityDefinition.html)|topic|
|[AdverseEvent]({{site.data.fhir.ver}}/AdverseEvent.html)|event|
|[AllergyIntolerance]({{site.data.fhir.ver}}/AllergyIntolerance.html)|code|
|[Appointment]({{site.data.fhir.ver}}/Appointment.html)|serviceType|
|[Basic]({{site.data.fhir.ver}}/Basic.html)|code|
|[BodyStructure]({{site.data.fhir.ver}}/BodyStructure.html)|location|
|[CarePlan]({{site.data.fhir.ver}}/CarePlan.html)|category|
|[CareTeam]({{site.data.fhir.ver}}/CareTeam.html)|category|
|[ChargeItemDefinition]({{site.data.fhir.ver}}/ChargeItemDefinition.html)|code|
|[Claim]({{site.data.fhir.ver}}/Claim.html)|type|
|[ClaimResponse]({{site.data.fhir.ver}}/ClaimResponse.html)|type|
|[ClinicalImpression]({{site.data.fhir.ver}}/ClinicalImpression.html)|code|
|[Communication]({{site.data.fhir.ver}}/Communication.html)|category|
|[CommunicationRequest]({{site.data.fhir.ver}}/CommunicationRequest.html)|category|
|[Composition]({{site.data.fhir.ver}}/Composition.html)|type|
|[Condition]({{site.data.fhir.ver}}/Condition.html)|code|
|[Consent]({{site.data.fhir.ver}}/Consent.html)|category|
|[Coverage]({{site.data.fhir.ver}}/Coverage.html)|type|
|[DetectedIssue]({{site.data.fhir.ver}}/DetectedIssue.html)|code|
|[Device]({{site.data.fhir.ver}}/Device.html)|type|
|[DeviceMetric]({{site.data.fhir.ver}}/DeviceMetric.html)|type|
|[DeviceRequest]({{site.data.fhir.ver}}/DeviceRequest.html)|code|
|[DeviceUseStatement]({{site.data.fhir.ver}}/DeviceUseStatement.html)|device.code|
|[DiagnosticReport]({{site.data.fhir.ver}}/DiagnosticReport.html)|code|
|[Encounter]({{site.data.fhir.ver}}/Encounter.html)|type|
|[EpisodeOfCare]({{site.data.fhir.ver}}/EpisodeOfCare.html)|type|
|[ExplanationOfBenefit]({{site.data.fhir.ver}}/ExplanationOfBenefit.html)|type|
|[FamilyMemberHistory]({{site.data.fhir.ver}}/FamilyMemberHistory.html)|code|
|[Flag]({{site.data.fhir.ver}}/Flag.html)|code|
|[Goal]({{site.data.fhir.ver}}/Goal.html)|category|
|[GuidanceResponse]({{site.data.fhir.ver}}/GuidanceResponse.html)|module|
|[HealthcareService]({{site.data.fhir.ver}}/HealthcareService.html)|type|
|[ImagingStudy]({{site.data.fhir.ver}}/ImagingStudy.html)|code|
|[Immunization]({{site.data.fhir.ver}}/Immunization.html)|vaccineCode|
|[ImmunizationEvaluation]({{site.data.fhir.ver}}/ImmunizationEvaluation.html)|vaccineCode|
|[ImmunizationRecommendation]({{site.data.fhir.ver}}/ImmunizationRecommendation.html)|vaccineCode|
|[Library]({{site.data.fhir.ver}}/Library.html)|topic|
|[Location]({{site.data.fhir.ver}}/Location.html)|type|
|[Measure]({{site.data.fhir.ver}}/Measure.html)|topic|
|[MeasureReport]({{site.data.fhir.ver}}/MeasureReport.html)|measure.topic|
|[Medication]({{site.data.fhir.ver}}/Medication.html)|code|
|[MedicationAdministration]({{site.data.fhir.ver}}/MedicationAdministration.html)|medication|
|[MedicationDispense]({{site.data.fhir.ver}}/MedicationDispense.html)|medication|
|[MedicationRequest]({{site.data.fhir.ver}}/MedicationRequest.html)|medication|
|[MedicationStatement]({{site.data.fhir.ver}}/MedicationStatement.html)|medication|
|[MessageDefinition]({{site.data.fhir.ver}}/MessageDefinition.html)|event|
|[NutritionOrder]({{site.data.fhir.ver}}/NutritionOrder.html)|event|
|[Observation]({{site.data.fhir.ver}}/Observation.html)|code|
|[OperationOutcome]({{site.data.fhir.ver}}/OperationOutcome.html)|issue.code|
|[Organization]({{site.data.fhir.ver}}/Organization.html)|N/A|
|[Patient]({{site.data.fhir.ver}}/Patient.html)|N/A|
|[Practitioner]({{site.data.fhir.ver}}/Practitioner.html)|code|
|[PractitionerRole]({{site.data.fhir.ver}}/PractitionerRole.html)|code|
|[Procedure]({{site.data.fhir.ver}}/Procedure.html)|code|
|[Questionnaire]({{site.data.fhir.ver}}/Questionnaire.html)|name|
|[QuestionnaireResponse]({{site.data.fhir.ver}}/QuestionnaireResponse.html)|name|
|[RelatedPerson]({{site.data.fhir.ver}}/RelatedPerson.html)|relationship|
|[RiskAssessment]({{site.data.fhir.ver}}/RiskAssessment.html)|code|
|[SearchParameter]({{site.data.fhir.ver}}/SearchParameter.html)|target|
|[Sequence]({{site.data.fhir.ver}}/Sequence.html)|type|
|[ServiceRequest]({{site.data.fhir.ver}}/ServiceRequest.html)|type|
|[Specimen]({{site.data.fhir.ver}}/Specimen.html)|type|
|[Substance]({{site.data.fhir.ver}}/Substance.html)|code|
|[SupplyDelivery]({{site.data.fhir.ver}}/SupplyDelivery.html)|type|
|[SupplyRequest]({{site.data.fhir.ver}}/SupplyRequest.html)|category|
|[Task]({{site.data.fhir.ver}}/Task.html)|code|


For previous versions of FHIR ModelInfo, refer to the [FHIR ModelInfo](https://github.com/cqframework/clinical_quality_language/wiki/FHIRModelInfo) CQFramework wiki page.