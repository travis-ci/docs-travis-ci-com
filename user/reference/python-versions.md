---
title: The complete list of Python versions available for on-demand installations
layout: en

---
{% assign versions = site.data.python_versions %}
<table>
  <tr>
    <th>OS</th>
    <th>Release</th>
    <th>Version</th>
  </tr>
  <tr>
    <td rowspan="{{versions.ubuntu.size}}">Ubuntu</td>
    <td rowspan="{{versions.ubuntu.precise.size}}">12.04</td>
    <td>{{versions.ubuntu.precise.versions[0]}}</td>
  </tr>
  {% for version in versions.ubuntu.precise.versions offset:1 %}
  <tr><td>{{version}}</td></tr>
  {% endfor %}
  <tr>
    <td rowspan="{{versions.ubuntu.trusty.size}}">14.04</td>
    <td>{{versions.ubuntu.precise.versions[0]}}</td>
  </tr>
  {% for version in versions.ubuntu.trusty.versions offset:1 %}
  <tr><td>{{version}}</td></tr>
  {% endfor %}
 </table>