namespace common;

using {
  managed as AdminData,
  sap
} from '@sap/cds/common';

// ---------------------------------------------------------------------------------------------------------------------
// Define an ID field to be of type UUID (Universal Unique Identifier).
// Such a field is typically used as a key field and the UUID value is generated automatically.
//
// Also, inherit default admin data provided by @sap/cds/common (modifiedAt/By, createdAt/By).
// ---------------------------------------------------------------------------------------------------------------------
abstract entity Managed : AdminData {
  key ID : UUID;
}
