# CDS Build Tool

## CDS Compiler Conventions

In Web IDE, when you select "Build CDS" from the project context menu, or "Build" from the "db" folder's context menu, the CDS compiler will be invoked.  Although it is possible to configure the behaviour of this compiler, in the absence of any explicit configuration, it will follow certain conventions concerning directory and file names.

### Directory Name Conventions
By default, the CDS compiler will assume that the following directory names are present in your project:

| Directory Name | Description
|:-:|---
| `db` | Contains the entity definitions needed to construct a database representation of your data model.  Can also contain the `.csv` files needed to load the subsequent database tables with data
| `srv` | Contains the service definition that exposes the database contents as an OData service 
| `app` | Contains the user interface definition that consumes the OData service as an end-user application

### The `index.cds` file
The CDS compiler's default behaviour is to look in each of the above directories for an `index.cds` file.  It is not a requirement to create your own `index.cds`; however, if this file is present then there will be certain consequences:

1. `index.cds` is a normal CDS file; therefore, it can contain any CDS statements you like.
1. If `index.cds` exists in one of the above directories, the CDS compiler will explicitly open only this file.
1. If your data model, its services or applications are described by multiple `.cds` files, then the respective `index.cds` files must reference all required files.
1. Any `.cds` file that is not explicitly referenced by `index.cds` will be ignored.

No error will occur if one of the above directories does not contain an `index.cds` file.  In this case, the CDS compiler will simply open and parse ***all*** files with an extension of `.cds`.

