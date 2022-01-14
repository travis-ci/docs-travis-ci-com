---
title: Weighting Probes
layout: en_insights

--- 

Probes are weighted from 0 to 1 across three categories (_Security_, _Cost_, and _Delivery_) and three sub-categories (_Architecture_, _Maintenance_, and _Support_) based on how critical the information is.  For example, a probe for a severe security vulnerability will have a higher rating (closer to 1) than a probe for servers that aren't following proper naming conventions/policies.

![weightingProbes](/user/images-insights/weightingProbes.png) 

**_Security_**: Probes that relate to the overall security of the system like public network exposure, secure system configuration, patching, passwords, IAM, etc.
- **_Architecture_**: Relates to the security posture of the overall design and setup of the environment.
- **_Support_**: Relates to how the security posture affects the short-term supportability of the environment.
- **_Maintenance_**: Relates to how security posture impacts long-term maintenance costs.

**_Cost_**: Probes that relate to the overall cost-effectiveness system like reserved instance usage, proper instance sizing, any sort of unused, paid capacity, etc.
- **_Architecture_**: Relates to the relative cost-effectiveness of the overall design and setup of the environment.
- **_Support_**: Relates to the relative cost-effectiveness of the short-term supportability of the environment.
- **_Maintenance_**: Relates to the relative cost-effectiveness of long-term maintenance costs.

**_Delivery_**: Probes that relate to the overall delivery of the system/end product like uptime, response times, SLAs, maximum concurrent sessions, etc.
- **_Architecture_**: Relates to the robustness/stability of the overall design and setup of the environment.
- **_Support_**: Relates to the robustness/stability of the environment and its impact on short-term supportability/management of the environment.
- **_Maintenance_**: Relates to the robustness/stability of the environment and its impact on long-term maintenance costs. 


> This is not an exact science, your weighting may differ, you can edit the plugin weights according to your needs.


**For example:**

If you have a probe which ensures our MySQL security patches are up-to-date. These could be a weightings example.

|   sub-category   |   security   |     cost     |   delivery   |
|:----------------:|:------------:|:------------:|:------------:|
| **Architecture** |      0       |      0       |       0      |
|   **Support**    |     0.75     |      0       |       0      |
|  **Maintenance** |     0.75     |      0       |       0      |


> Probes with 0 as a weighting, don't get counted on the weight average percentage.

We generally try to avoid "double counting" on probe weightings (i.e. one could argue that security patching also has an impact on delivery and/or cost, but it is primarily a security issue) unless the issue is so severe that it warrants doing so to raise it to the top of our list.  Likewise, when the impact is spread evenly across sub-categories, we try to just split the weight evenly between them.

As a rule of thumb, a highly impactful probe will have a total score total of 2.5+.  A probe of average importance will be weighted in the 1.5 - 2.5 range.  A probe of low importance will range between 0.5 - 1.5 in weighting.