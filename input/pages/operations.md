{:toc}

{: #operations}

### Index

<table class="grid">
  <tr><th>CodeSystem</th><th>Description</th></tr>
{% include table-operationdefinitions.xhtml %}
</table>

### Examples

#### $cql

##### Simple Expression

This example just evaluates the expression `2 + 2`:

```
POST [base]/$cql

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "expression",
    "valueString": "2 + 2"
  }]
}
```

The expected response for this operation is:

```
HTTP/1.1 200 OK

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "return",
    "valueInteger": 4
  }]
}
```

##### Expression With Parameters

This example evaluates the expression `2 + X` where `X` is a parameter passed in the `parameters` parameter with the value of 2:

```
POST [base]/$cql

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "expression",
    "valueString": "2 + X"
  }, {
    "name": "parameters",
    "resource": {
      "resourceType": "Parameters",
      "parameter": [{
        "name": "X",
        "valueInteger": 2
      }]
    }
  }]
}
```

The expected response for this operation is:

```
HTTP/1.1 200 OK

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "return",
    "valueInteger": 4
  }]
}
```

##### Expression Referencing a Library

This example evaluates the expression `Count(PE."Blood Glucose Observations")`, where `"Blood Glucose Observations"` is defined in the `ParameterExample` library and made available to the expression through the `library` parameter:

```
POST [base]/$cql

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "expression",
    "valueString": "Count(PE.\"Blood Glucose Observations\")",
  }, {
    "name": "subject",
    "valueString": "Patient/example"
  }, {
    "name": "parameters",
    "resource": {
      "resourceType": "Parameters",
      "parameter": [{
        "name": "GlucoseThreshold",
        "valueQuantity": {
          "value": 8.0
          "code": "mg/dL",
          "system": "http://unitsofmeasure.org"
        }
      }]
    }
  }, {
    "name": "library",
    "part": [{
      "name": "url",
      "valueCanonical": "http://hl7.org/fhir/uv/cql/Library/ParameterExample"
    }, {
      "name": "name",
      "valueString": "PE"
    }]
  }]
}
```

The expected response for this operation is (assuming a Patient with id `example` and 4 Blood Glucose Observations over 8.0 'mg/dL'):

```
HTTP/1.1 200 OK

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "return",
    "valueInteger": 4
  }]
}
```

NOTE: The parameter name may be qualified by the identifier used for the library to explicitly indicate that the parameter value should only be bound to the parameter in that library, for example:

```json
  }, {
    "name": "parameters",
    "resource": {
      "resourceType": "Parameters",
      "parameter": [{
        "name": "PE.GlucoseThreshold",
        "valueQuantity": {
          "value": 8.0
          "code": "mg/dL",
          "system": "http://unitsofmeasure.org"
        }
      }]
    }
  }, {
```

The local identifier `PE` is specified by the `library.name` part.

#### Library/$evaluate

This example evaluates the `ParameterExample` library

```
POST [base]/Library/ParameterExample/$evaluate

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "subject",
    "valueString": "Patient/example"
  }, {
    "name": "parameters",
    "resource": {
      "resourceType": "Parameters",
      "parameter": [{
        "name": "GlucoseThreshold",
        "valueQuantity": {
          "value": 8.0
          "code": "mg/dL",
          "system": "http://unitsofmeasure.org"
        }
      }]
    }
  }]
}
```

The expected response for this operation is (assuming a Patient with id `example` and 4 Blood Glucose Observations over 8.0 'mg/dL'):

```
HTTP/1.1 200 OK

{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "Blood Glucose Observations",
    "resource": {
      "resourceType": "Observation",
      "id": "observation-1",
      ...
    }
  }, {
    "name": "Blood Glucose Observations",
    "resource": {
      "resourceType": "Observation",
      "id": "observation-2",
      ...
    }
  }, {
    "name": "Blood Glucose Observations",
    "resource": {
      "resourceType": "Observation",
      "id": "observation-3",
      ...
    }
  }, {
    "name": "Blood Glucose Observations",
    "resource": {
      "resourceType": "Observation",
      "id": "observation-4",
      ...
    }
  }]
}
```

NOTE: The parameter name may be qualified by the library name to explicitly indicate that the parameter value should only be bound to the parameter in that library, for example:

```json
  }, {
    "name": "parameters",
    "resource": {
      "resourceType": "Parameters",
      "parameter": [{
        "name": "ParameterExample.GlucoseThreshold",
        "valueQuantity": {
          "value": 8.0
          "code": "mg/dL",
          "system": "http://unitsofmeasure.org"
        }
      }]
    }
  }, {
```

