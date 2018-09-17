<a name="top"></a>
# Space Travel Sample for TechEd 2018




<a name="contents"></a>
## Table of Contents
1. [Description](#description)
1. [Requirements](#requirements)
1. [Download & Installation](#download)
1. [Configuration](#configuration)
1. [Limitations](#limitations)
1. [Known Issues](#issues)
1. [Support](#support)
1. [Contributing](#contributing)
1. [License](#license)





<a name="description"></a>
## Description

This repository contains the base CDS data model for the following TechEd 2018 sessions:

| TechEd Session Code | Repository | Session Description |
|---|---|---|
| CNA262 | [cloud-sample-spaceflight-hana](https://github.com/SAP/cloud-sample-spaceflight-hana) | Developing SAP HANA Database Modules with an Application Programming Model |
| CNA375 | [cloud-sample-spaceflight-node](https://github.com/SAP/cloud-sample-spaceflight-node) | Build Node Applications Using the Programming Model with SAP Cloud Platform |
| CNA376 | [cloud-sample-spaceflight-java](https://github.com/SAP/cloud-sample-spaceflight-java) | Build (Java) Applications with the Programming Model on SAP Cloud Platform |
| CNA462 | [cloud-sample-spaceflight-ui](https://github.com/SAP/cloud-sample-spaceflight-ui) | Develop UIs for Microservices-Based Applications on SAP Cloud Platform |

This data model has been defined using SAP's [Core Data Services](https://help.sap.com/viewer/09b6623836854766b682356393c6c416/2.0.03/en-US) 


### Data Model

The data model used by all these sessions is described [here](./docs/README.md).   Please read this description in order to gain a correct understanding firstly of the data model's structure, and secondly, how it can be used.

### Core Data Services (CDS) Build Tool

A brief overview of the default behaviour of the CDS Build Tool is given [here](./docs/cdsCompile.md).






<a name="requirements"></a>
## Requirements

### For SAP TechEd 2018

For attendees of SAP TechEd 2018, the session instructors will provide you with access to the full environment in which you can develop the various sample applications used in the sessions listed above.

### For General Use

Once SAP TechEd 2018 has finished, the exercises shown in the above sessions will be available for use to anyone with an SAP Cloud Platform (Cloud Foundry) account containing at least the services listed below:

* Application Runtime
* SAP HANA Database (Enterprise)
* SAP HANA Schemas & HDI Containers (hdi-shared)

The instructions below are only needed if you wish to run the application in your own account on SAP cloud platform.

### Development in SAP Cloud Platform Web IDE

An SAP Cloud Platform (Neo) account in needed in order have access to the Full-stack version of the SAP Web IDE. For more information, see [Open SAP Web IDE](https://help.sap.com/viewer/825270ffffe74d9f988a0f0066ad59f0/CF/en-US/51321a804b1a4935b0ab7255447f5f84.html).

Read the [getting started tutorial](https://help.sap.com/viewer//65de2977205c403bbc107264b8eccf4b/Cloud/en-US/5ec8c983a0bf43b4a13186fcf59015fc.html) to learn more about working with SAP Cloud Platform Web IDE.

Now clone your fork of this repository (*File -> Git -> Clone Repository*).

#### Develop, Build, Deploy

Build and deploy the DB module by choosing *Build* from the context menu of the `db` folder.





<a name="download"></a>
## Download and Installation

The exercises for the sessions listed above are entirely Cloud-based.  Although you are at liberty to use any software editor you choose, the exercise instructions assume the use of SAP Web IDE; therefore, no software need be installed locally.





<a name="configuration"></a>
## Configuration

None





<a name="limitations"></a>
## Limitations

When using SAP Web IDE in the Firefox Quantum browser, a small number editor features are known not to function correctly; therefore it is recommended to use an up-to-date version of Google Chrome when working in SAP Web IDE.




<a name="issues"></a>
## Known Issues

None so far...




<a name="support"></a>
<a name="contributing"></a>
## Support and Contributing

This project is provided "as-is": there is no guarantee that raised issues will be answered or addressed in future releases.





<a name="license"></a>
## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This project is licensed under the Apache Software License, Version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
