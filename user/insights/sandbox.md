---
title: 1
layout: en_insights

---

# SandBox
In the Sandbox tab, you have a query editor and tester section.

<img src="../../assets/images/queryeditor.png">

Go to the **Plugin** drop-down menu and select the plugin you want to use. Then, click the **LOAD** button to see how the Sample JSON displays.

Add any query you want to test in the **Query** space, click the button **RUN**, and you will receive an Output for the specific query. 

## Query Language

Travis Insights uses the **ObjectPath** query language, objectPath is an agile NoSQL query language for semi-structured data that uses embedded arithmetic calculations, comparison mechanisms, and built-in functions. This language works over JSON documents rather than relations. 
The language lets you work with selector mechanisms, boolean logic, type system, and string concatenation. You can find data in big nested JSON documents.

In the following table, you can find the complete syntax of ObjectPath paths: 

|   Operator       |   Name                       |     Description                                                                                              |    
|:----------------:|:----------------------------:|:------------------------------------------------------------------------------------------------------------:|
| **$**            | root object/element          | It can be either an object or a list of objects. ObjectPath queries work for both.                           |   
| **@**            | current object/element       | @ points to current item from the list generated from executing expression on the left side of []            |    
| **.**            | child/property operator      | . goes one level deeper into data structure (selects child of a parent). In conjunction with property name like .name and array of objects, it returns an array of values under each object's name attribute.                                                                               |  
| **..**           | Recursive descent            | ObjectPath borrows this syntax from E4X (and JSONPath). .. finds all objects in the subtree.                 |      
| *                | Wildcard                     | * selects all objects/elements from the array regardless of their names.                                     |
| **[]**           | Selector operator            | [] is an advanced tool for filtering lists of objects.                                                       |



**Example:**

In weather readings find locations where temperature is higher than 25°C and the sky is clear:

`$.Weather.*[@.temp > 25 and @.clouds is "clear"].name`

For more details, visit: 

- [http://objectpath.org/](http://objectpath.org/)

- [http://objectpath.org/tutorial.html](http://objectpath.org/tutorial.html)

- [http://objectpath.org/reference.html](http://objectpath.org/reference.html)

## Travis Insights ObjectPath

All **Probes** in Travis Insights use a customized ObjectPath - SREOP. SREOP is a superset on top of the original ObjectPath that we apply to return **true** or **false** probe responses.

By default, ObjectPath returns objects, and the use of the selectors/operators **[]** depend on their position. The first set applies the probe conditionals, and the second set is used to provide the unique identifier of each item probed for us to report back.

You can see the differences in the following examples:

**Standard ObjectPath probe:**

`$.instances[@.memory > 9000]`

_Returns a list of instances whose memory is over 9000._

**Travis Insights ObjectPath probe:**

`$.instances[*][@.memory > 9000][@.name]`

_Scores what number of instances' memories are over 9000 and returns a list of instance names for those whose memories are not over 9000._

## Travis Insights ObjectPath Values
There can be two types of values:

- List of items that match the probe conditions. It can include boolean values.
- List of items that don’t match the probe conditions. SREOP includes an internal validator to ensure the user's queries do not contain unsupported characters.

### Travis Insights ObjectPath Syntax

- $.ObjectToSelectFrom[filter conditions (ObjectPath syntax)][probe conditions (ObjectPath syntax + SREOP COUNT and COUNDISTINCT)][unique identifier of each item that do not match the probe conditions (ObjectPath syntax)]

    **Example:**

    `$.Animals.Dogs[*][@.Age > 3][@.name]`


- $.ObjectToSelectFrom[filter conditions (ObjectPath syntax)][SREOP COUNT or COUNDISTINCT][unique identifier of each item that do not match the probe conditions (ObjectPath syntax)] probe conditions

    **Example:**

    `$.Animals.Dogs[*][COUNT][@.name] - $.Animals.Dogs[@.Breed is "Dobermann"][COUNT][@.name] > 0`

    - _For this specific sintax the second value will be an empty array; the probe conditions can be:_
        - _An ObjectPath syntax string_
        - _One or a combination of multiple SREOP syntax strings._

- Any other valid ObjectPath syntax that return a boolean value.

    **Example:**    

    `$.Resources.core.limit - $.Resources.core.remaining > 500`

    - _For this syntax, the second value will be always an empty array._

## Examples 

### Sample JSON

``` 
{
  "Animals": {
    "Dogs": [
      {
        "Breed": "Dobermann",
        "Name": "Fido",
        "Age": 3
      },
      {
        "Breed": "Dobermann",
        "Name": "Scruffy",
        "Age": 5
      },
      {
        "Breed": "Rottweiler",
        "Name": "Charlie",
        "Age": 5
      }
    ]
  }
}
```
### Sample SREOP Probes

Probe name: Some dogs have age less or equal than 3

`$.Animals.Dogs[*][@.Age > 3][@.name]`

- _Match probe conditions: ["Scruffy", "Charlie"]_
- _Don’t match probe conditions: ["Fido"]_

Probe name: Some dogs of breed Dobermann have age less or equal than 3

`$.Animals.Dogs[@.Breed is "Dobermann"][@.Age > 3][@.name]`

- _Match probe conditions: ["Scruffy"]_
- _Don’t match probe conditions: ["Fido"]_

Probe name: Some dogs are not of breed Doberman or have age less or equal than 3

`$.Animals.Dogs[*][@.Breed is "Dobermann" and @.Age > 3][@.name]`

- _Match probe conditions: ["Scruffy"]_
- _Don’t match probe conditions: ["Fido", "Charlie"]_

Probe name: There are no dogs

`$.Animals.Dogs[*][COUNT][@] > 0`

- _Match probe conditions: true_
- _Don’t match probe conditions: []_

Probe name: There are too many dogs

`$.Animals.Dogs[*][COUNT][@] < 3`

- _Match probe conditions: false_
- _Don’t match probe conditions: []_

Probe name: There are no dogs of breed other than Dobermann

`$.Animals.Dogs[*][COUNT][@] - $.Animals.Dogs[@.Breed is "Dobermann"][COUNT][@] > 0`

- _Match probe conditions: true_
- _Don’t match probe conditions: []_

Probe name: There are dogs of breed other than Dobermann

`$.Animals.Dogs[*][COUNT][@] - $.Animals.Dogs[@.Breed is "Dobermann"][COUNT][@] is 0`

- _Match probe conditions: false_
- _Don’t match probe conditions: []_
