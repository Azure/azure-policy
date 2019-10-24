const fs = require('fs');
const path = require('path');

const samplesRootPath = path.join(__dirname, '..');

test('example test', () => {
   const files = fs.readdirSync(samplesRootPath);
   files.forEach(file => {
      console.log(file);
   });
});
