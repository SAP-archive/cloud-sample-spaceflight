# Core Data Service (CDS) Build Tool

## What is CDS?

The concept behind Core Data Services is to offer a three-layer approach to user application development.  These three layers build upon each other and provide a means for defining a:

1. ***data model*** in a database agnostic manner
1. ***service*** that exposes your data model to the outside world in the form of an OData service
1. basic end-user ***application*** that consumes the generated OData service

As a consequence of these three layers, within an SAP Cloud Platform Business Application Project, the directory naming convention described below is expected.

You are free to use as many of these three layers as are relevant for your requirements - but always following the strict order of Data Model -> Service -> Application,

### Directory Name Conventions

| Directory Name | Description
|:-:|---
| `db` | Contains the CDS definitions of all the entities in your data model.<br>This directory can also contain any `.csv` files needed to load the generated tables with data once your database has been deployed to HANA
| `srv` | Contains the service definition that exposes the contents of the HANA database as an OData service
| `app` | Contains a user interface definition to consume the OData service as an end-user application

## CDS Compiler Conventions

In Web IDE, when you select "Build CDS" from the project context menu, or "Build" from the `db` folder's context menu, the CDS compiler will be invoked.  Although it is possible to configure the behaviour of this compiler, in the absence of any explicit configuration, it will follow certain conventions concerning directory and file names.

In keeping with the strict order described above, the CDS compiler first examines the contents of the `db` folder, then the `srv` folder, then finally the `app` folder.

### The `index.cds` file

The CDS compiler's default behaviour is to look in each of the above directories for an `index.cds` file.  If this file is found, then the compiler behaves in the following manner:

1. Only the `index.cds` file will be opened explicitly.  Since this is a normal CDS file, it can contain any CDS statements you like - which includes references to other `.cds` files
1. If your data model is described by multiple `.cds` files, then these files must be referenced within `index.cds`, otherwise they will ***not*** be processed
1. Any `.cds` file that is not explicitly referenced by `index.cds` will be ignored.

***Q:*** What happens to the CDS compiler if I don't create my own `index.cds` file?  
***A:*** Nothing bad... :-)

No error will occur if `index.cds` does not exist.  In this case, the CDS compiler will simply open and parse ***all*** files with an extension of `.cds`.

The advantage of using an `index.cds` file is that should you wish to, you can exclude certain `.cds` files from your data model at compile time.  This is a useful feature if you need to switch on or off certain sections of your data model.
