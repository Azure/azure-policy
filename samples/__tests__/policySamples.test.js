const fsasync = require('fs').promises;
const fs = require('fs');
const path = require('path');

const samplesRootPath = path.join(__dirname, '..');

// These directories are excluded from samples tests
const excludedDirectories = [
   path.join(samplesRootPath, '__tests__', '**').toUpperCase(),
   path.join(samplesRootPath, 'GuestConfiguration', 'package-samples', '**').toUpperCase(),
   path.join(samplesRootPath, 'KubernetesService', '**').toUpperCase()
];

// Directories with these file type are excluded from samples tests
const excludedFileExtensions = [
   '.REGO'
];

const samplesDirectories = [];

function getFilePaths(rootDirPath) {
   const entryPaths = fs.readdirSync(rootDirPath).map(entry => path.join(rootDirPath, entry));
   const filePaths = entryPaths.filter(entryPath => fs.statSync(entryPath).isFile());
   const dirPaths = entryPaths.filter(entryPath => !filePaths.includes(entryPath));
   const dirFiles = dirPaths.reduce((prev, curr) => prev.concat(getFilePaths(curr)), []);
   return [...filePaths, ...dirFiles];
}

// Get the full set of directory paths containing policy samples
let allSamplesFiles = getFilePaths(samplesRootPath);
let samplesDirectoriesByPath = {};
allSamplesFiles.forEach(filePath => {
   let containingDirPath = path.dirname(filePath);

   // Exclude some directories and files that are deemed 'special content'
   for (const excludedDir of excludedDirectories) {
      if ((excludedDir.endsWith('**') && containingDirPath.toUpperCase().startsWith(excludedDir.substr(0, excludedDir.length - 3))) || containingDirPath.toUpperCase() === excludedDir) {
         return;
      }
   }

   if (excludedFileExtensions.includes(path.extname(filePath).toUpperCase())) {
      return;
   }

   if (!samplesDirectoriesByPath[containingDirPath]) {
      samplesDirectoriesByPath[containingDirPath] = [filePath];
   } else {
      samplesDirectoriesByPath[containingDirPath].push(filePath);
   }
});

for (const dirPath in samplesDirectoriesByPath) {
   samplesDirectories.push([dirPath, samplesDirectoriesByPath[dirPath]]);
}

// Validates that each samples directory contains the expected files
test.each(samplesDirectories)('Validate directory structure: %s', (dirPath, filePaths) => {
   const expectedPolicyDefinitionFiles = [
      path.join(dirPath, 'azurepolicy.json'),
      path.join(dirPath, 'azurepolicy.parameters.json'),
      path.join(dirPath, 'azurepolicy.rules.json'),
      path.join(dirPath, 'README.md')
   ];

   const expectedPolicySetFiles = [
      path.join(dirPath, 'azurepolicyset.json'),
      path.join(dirPath, 'azurepolicyset.parameters.json'),
      path.join(dirPath, 'azurepolicyset.definitions.json'),
      path.join(dirPath, 'README.md')
   ];

   // Special case samples dirs that only contain markdown
   if (filePaths.every(filePath => path.extname(filePath).toUpperCase() === '.MD')) {
      return;
   }

   if (filePaths.some(filePath => path.basename(filePath, '.json').toUpperCase() === 'AZUREPOLICYSET')) {
      expect(filePaths).toEqual(expect.arrayContaining(expectedPolicySetFiles));
   } else {
      expect(filePaths).toEqual(expect.arrayContaining(expectedPolicyDefinitionFiles));
   }
});

// Validates that all JSON files are valid JSON (not necessarily valid policy entities though)
test.each(samplesDirectories.map(dirSet => dirSet[1]).reduce((first, second) => first.concat(second), []))('Validate JSON can be parsed: %s', async (filePath) => {
   if (path.extname(filePath).toUpperCase() !== '.JSON') {
      return;
   }

   let fileContent = await fsasync.readFile(filePath);
   JSON.parse(fileContent);
});
