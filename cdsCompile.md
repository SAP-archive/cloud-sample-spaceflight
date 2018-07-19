## CDS Compiler Conventions

In Web IDE, when you select "Build CDS" from the project context menu, or "Build" from the "db" folder's context menu, the CDS compiler will be invoked.  Although it is perfectly possible to configure the behaviour of this compiler, in the absence of any explicit configuration, it will follow certain conventions concerning directory and file names.

### Directory Name Conventions
By default, the CDS compiler will assume that the following directory names are present in your project:
  * "db"  - Holds the database definition
  * "srv" - Holds the service definition that exposes the database contents as an OData service 
  * "app" - Holds the user interface definition that consumes the OData service as an end-user application

### The `index.cds` file
The CDS compiler will then look in each of the above directories for an `index.cds` file.  If such a file is found, then it is explicitly opened and parsed.

Creating your own `index.cds` is not a requirement and if you choose to create one, it can contain any CDS statements you like.  However, the main purpose for this file is to act as a useful central point from which all the other CDS files can be referenced.

No error will occur if `index.cds` cannot be found.  In this case, the CDS compiler will simply open and parse ***all*** files with an extension of `.cds`.
