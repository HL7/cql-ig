library ANCCohort

using FHIR version '4.0.1'

include FHIRHelpers version '2.0.0-ballot'

codesystem "ANCM Concept Codes": 'http://hl7.org/fhir/uv/cql/CodeSystem/example'

code "Pregnancy confirmed": 'ANC.B4.DE1' from "ANCM Concept Codes" display 'Pregnancy confirmed'

define "Is Antenatal Care Applicable":
  "Is pregnancy confirmed" is true


/* Copied from ANCMContactDataElements */
/*
  @dataElement: ANC.B4.DE1 Pregnancy confirmed
  @activity: ANC.B4 Confirm pregnancy
  @description: Pregnancy has been confirmed
*/
define "Is pregnancy confirmed":
  MostRecent(
    Final([Observation: "Pregnancy confirmed"])
  ).value as boolean

/* Copied from WHOCommon */
define function Final(observations List<Observation>):
  observations O
    where O.status in { 'final', 'amended', 'corrected' }
      and Coalesce(ModifierExtension(O, 'who-notDone').value, false) is false
      and O.value is not null

define function MostRecent(observations List<Observation>):
  Last(
    observations O
      sort by issued
  )

/*
@description: Returns any WHO core modifier extensions defined on the given resource with the specified id.
@comment: NOTE: Extensions are not the preferred approach, but are used as a way to access
content that is defined by extensions but not yet surfaced in the
CQL model info.
*/
define function ModifierExtensions(domainResource DomainResource, id String):
  domainResource.modifierExtension E
	  where E.url = ('http://fhir.org/guides/who/core/StructureDefinition/' + id)
		return E

/*
@description: Returns the single WHO core modifier extension (if present) on the given resource with the specified id.
@comment: This function uses singleton from to ensure that a run-time exception is thrown if there
is more than one extension on the given resource with the specified url.
*/
define function ModifierExtension(domainResource DomainResource, id String):
  singleton from ModifierExtensions(domainResource, id)

