---
title: Online Hosted Instructions
permalink: index.html
layout: home
---

# Content Directory

Required labs files can be [downloaded here](https://github.com/MicrosoftLearning/AZ500-AzureSecurityTechnologies/archive/master.zip)

Hyperlinks to each of the lab exercises and demos are listed below.

## Labs

{% assign labs = site.pages | where_exp:"page", "page.url contains '/Instructions/Labs'" %}
| Module | Lab |
| --- | --- | 
{% for activity in labs  %}| {{ activity.lab.module }} | [{{ activity.lab.title }}{% if activity.lab.type %} - {{ activity.lab.type }}{% endif %}]({{ site.github.url }}{{ activity.url }}) |
{% endfor %}
