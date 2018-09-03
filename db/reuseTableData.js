#!/usr/bin/env node

/**
 * =====================================================================================================================
 * @fileOverview Copy CSV files from a reference repository into the local db/src/gen folder
 * 
 * IMPORTANT: No recursive evaluation is performed
 *            Only reuse modules in the SAP namespace which are directly referenced in the package.json are considered 
 * 
 * A reuse module must provide a .hdbtabledata file in which all the required .csv files are declared.
 * If a .hdbtabledata file cannot be found, then no csv files are copied
 * 
 * The .hdbtabledata file maps qualified table names to corresponding .csv filenames
 * 
 * If there is a .csv file for the same table at both the consumption and reuse levels
 * then only the file from the consumption level is taken (no data merge is performed)
 * 
 * If however, there is a .csv file for the same table in different reuse modules
 * then the .csv files belonging to the first reuse module encountered in package.json will be taken
 * 
 * All .csv files declared in the .hdbtabledata files are copied according to the rules above, no matter whether the
 * corresponding table is used at the consumption level or not.
 * 
 * In case of structural table changes, it is necessary to provide an 'overwriting' .csv file at the consumption level
 * that reflects the new table structure
 * 
 * Author   : Christian Georgi   christian.georgi@sap.com
 * Modified : Chris Whealy       chris.whealy@sap.com
 * =====================================================================================================================
 **/

const fs   = require('fs')
const path = require('path')
const EOL  = require('os').EOL

// A useful version of Array push that returns the modified array rather than the index of the newly added item...
const push = (arr, newEl) => (_ => arr)(arr.push(newEl))

// Files containing table data
const tableDataFileSuffixes = [".hdbtabledata"]

/**
 * ---------------------------------------------------------------------------------------------------------------------
 * Recursively discover all .hdbtabledata files starting from the specified directory
 * Returns an array of fully qualified file names
 */
const _getTableDataSync =
  (directory, tableDataList) =>
    fs.existsSync(directory)
    ? fs.readdirSync(directory)
        .reduce((acc, fName) =>
            (fqName => 
              tableDataFileSuffixes.some(sfx => fqName.endsWith(sfx))
              ? push(acc, fqName)
              : (fs.statSync(fqName).isDirectory())
                ? _getTableDataSync(fqName, acc)
                : acc)
            (path.join(directory, fName))
        , tableDataList || [])
    : []


// Only consider space* modules
const dependencyFilter = dep => dep.startsWith("space")

// Discover all .hdbtabledata files in the db/src/csv folder
const localTableData = _getTableDataSync(path.join('db/src/csv'))

// Gather all locally declared table names
var tableNames = localTableData.
  reduce(
    (accOuter, filePath) =>
      JSON.
        parse(fs.readFileSync(filePath)).
        imports.
        reduce((accInner, entry) => push(accInner, entry.target_table), accOuter)
  , [])

console.log("Found %i locally declared tables\n%s", tableNames.length, tableNames.join('\n  '))

// Pull in the top level package.json file
const packages = JSON.parse(fs.readFileSync(path.join('package.json')))

// Discover all *.hdbtabledata that might be present in dependent node modules
const reuseTableDataFiles = Object.
  keys(packages.dependencies).
  filter(dependencyFilter).
  reduce((acc, dependency) => _getTableDataSync(path.join('node_modules', dependency), acc), [])

reuseTableDataFiles.forEach(filePath => { // filter out tables declared locally and copy csv data
  console.log(`Reusing table data from '${path.relative(process.cwd(), filePath)}'`)
  const newFiles = []
  const jsonTableDataContent = JSON.parse(fs.readFileSync(filePath))
  const nonFilteredImports = [] // will contain imports with locally declared and/or duplicate tables filtered out
  jsonTableDataContent.imports.filter(entry => {
    const existing = tableNames.includes(entry.target_table)
    if (existing) {
      console.log('Filtered out already existing table: ' + entry.target_table)
    }
    return !existing
  }).forEach(entry => {
    nonFilteredImports.push(entry)
    tableNames.push(entry.target_table)
  })

  const copiedTableDataImports = [] // will contain the table data of the non-filtered imports
  const baseDestPath = path.join('db/src/gen', path.dirname(filePath).split('node_modules')[1])
  nonFilteredImports.forEach(entry => {
    const srcFile = path.join(path.dirname(filePath), entry.source_data.file_name)
    if (fs.existsSync(srcFile)) {
      const destFile = path.join(baseDestPath, entry.source_data.file_name)
      _writeContentSync(destFile, fs.readFileSync(srcFile))
      newFiles.push(destFile)
    } else {
      console.log('No csv file was found for table: ' + entry.target_table)
    }
    copiedTableDataImports.push(entry)
  })
  if (nonFilteredImports.length > 0) { // writes the non-filtered table data
    const tableData = {}
    tableData.format_version = 1
    tableData.imports = copiedTableDataImports // assumption: simple *.hdbtabledata
    const destFile = path.join(baseDestPath, path.basename(filePath))
    _writeContentSync(destFile, JSON.stringify(tableData, null, 2))
    newFiles.push(destFile)
  }

  console.log('  ' + newFiles.join(EOL + '  '))

  // add our new files to the list that Web IDE will copy back to the workspace
  if (process.env.GENERATION_LOG && newFiles.length > 0) {
    let log = fs.readFileSync(process.env.GENERATION_LOG)
    log += newFiles.map(f => path.relative(process.cwd(), f)).join(EOL)
    fs.writeFileSync(process.env.GENERATION_LOG, log)
  }
})

function _writeContentSync(fileName, data) {
  const pathName = path.dirname(fileName)
  if (fs.existsSync(pathName)) {
    fs.writeFileSync(fileName, data)
  } else {
    _mkdirSync(pathName)
    _writeContentSync(fileName, data)
  }
}

function _mkdirSync(pathName) {
  const sep = path.sep
  const initDir = path.isAbsolute(pathName) ? sep : ''
  pathName.split(sep).reduce((parentDir, childDir) => {
    const curDir = path.resolve('.', parentDir, childDir)
    if (!fs.existsSync(curDir)) {
      fs.mkdirSync(curDir)
    }
    return curDir
  }, initDir)
}



