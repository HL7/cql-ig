# Negation in FHIR

QICore and CPG have patterns for representing negation

* Events not done for a reason
* Requests not to do something
* Rejected proposals

Feedback from workflow

Rejected proposals need to be represented with a Task, the core issue being that the Request resources do not have a status that indicates "rejected", and that typically, the author of the proposal is the only one that can update the proposal, so a user rejecting a proposal from another clinician, or a decision support service, cannot be represented with an update to the proposal itself.

Need to support negation of specific activities as well as classes of activities

* I didn’t do X (code)
* I didn’t do any of Y (valueset)

Adding to the profiles for the positive statements, a cqf-valueSet extension that will allow us to specify orders for classes of things using a value set reference.

Extensions pack to add the cqf-valueSet extension

Using CQL to describe querying using these negation patterns

CPG-on-FHIR to describe requesting and rejecting proposals using this approach

QICore to add the extension and update the patterns

## Implications:

We will now be able to request classes, rather than just individual items

Propose that we build this in to the DataExchange for Opioids IG

We already support institution specific configuration for the Opioid MME calculator, we need to support the same kind of thing for ServiceRequest/MedicationRequest orders, so that they can provide a ConceptMap, and support that for both a ValueSet and a Code

Patterns right now are 1-to-1 with the profiles

* Use case 1 is covered by the _event_ negation profiles, e.g. ProcedureNotDone and MedicationNotAdministered
* Use case 2 is covered by the _request_ negation profiles, e.g. ServiceNotRequested and MedicationNotRequested
* Use case 3 is currently not really covered by any documentation, though you could express, but it would require talking about both the positive proposal and the task rejection

## Options

1. Retain current profiles
2. Collapse to a single profile
3. Establish positive and negative profiles as derivative

Each of these options is considered in turn, using the running example of "evidence that aspirin was not ordered or prescribed for a reason"

### Retain Current Profiles

Retain current profiles, and establish the pattern for the rejected proposal case

The pattern for Use Case 3 needs to combine the proposal with a TaskRejected profile:

```cql
define "Aspirin Rejected For Reason":
  [MedicationRequest: Aspirin] MR 
    with [TaskRejected: Fulfill] T 
      such that T.focus.references(MR)
        and T.statusReason in "Negation Reason Codes"
    where MR.status = 'active'
```

> This example searches for an active proposal, plan, or order for Aspirin that was rejected

In addition, we search for documentation that the medication was not ordered for a reason:

```cql
define "Aspirin Not Requested For Reason":
  [MedicationNotRequested: Aspirin] MR
    where MR.status in { 'active', 'completed' }
      and MR.statusReason in "Negation Reason Codes"
```

As well as for documentation that the medication was not administered for a reason:

```cql
define "Aspirin Not Administered For Reason":
  [MedicationNotAdministered: Aspirin] MA
    where MA.statusReason in "Negation Reason Codes"
```

The exclusion criteria can then be expressed as the union of these:

```cql
define "Exclusion Criteria":
  exists "Aspirin Rejected For Reason"
    or exists "Aspirin Not Requested For Reason"
    or exists "Aspirin Not Administered For Reason"
```

> Note that because the `code` element of the MedicationRequest would now have the possibility of being represented as a ValueSet, the retrieve of the MedicationRequest is actually expanded as:

```cql
[MedicationRequest: code in "Aspirin"]
  union [MedicationRequest: code ~ "Aspirin"]
```

### Collapse to a Single Profile per Activity Type

The next option to consider is collapsing to a single profile, so instead of having MedicationRequest and MedicationNotRequested, we would only have MedicationRequest.

Using this approach, the example would look like:

```cql
define "Aspirin Rejected For Reason":
  [MedicationRequest: Aspirin] MR
    with [Task: Fulfill] T
      such that T.focus.references(MR)
        and T.status = 'rejected'
        and T.statusReason in "Negation Reason Codes"
    where MR.status = 'active'
      and MR.doNotPerform is not true

define "Aspirin Not Requested For Reason":
  [MedicationRequest: Aspirin] MR
    where MR.status in { 'active', 'completed' }
      and MR.statusReason in "Negation Reason Codes"
      and MR.doNotPerform is true

define "Aspirin Not Administered For Reason":
  [MedicationAdministration: Aspirin] MA
    where MA.status = 'not-done'
      and MA.statusReason in "Negation Reason Codes"
```

### Expand to Positive and Negative Profiles

The next option to consider is defining a base profile as well as positive and negative profiles, so:

MedicationRequest
  |- MedicationRequested - positive profile, doNotPerform fixed to true but not required, status in 'active', 'completed'
  |- MedicationNotRequested - negative profile, doNotPerform fixed to false, status in 'active', 'completed'

Using this approach, the example would look like:

```cql
define "Aspirin Rejected For Reason":
  [MedicationRequested: Aspirin] MR
    with [TaskRejected: Fulfill] T
      such that T.focus.references(MR)
        and T.statusReason in "Negation Reason Codes"

define "Aspirin Not Requested For Reason":
  [MedicationNotRequested: Aspirin] MR
    where MR.statusReason in "Negation Reason Codes"

define "Aspirin Not Administered For Reason":
  [MedicationNotAdministered: Aspirin] MA
    where MA.statusReason in "Negation Reason Codes"
```
