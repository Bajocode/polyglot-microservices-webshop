const app = require('./app.js');
const assert = require('assert');

function test(title, fn) {
  try {
    fn();
    console.log('\x1b[36m%s\x1b[0m', `passed ${title}`);
    process.exit(0);
  } catch {
    console.log('\x1b[31m', `failed ${title}`);
    process.exit(1)
  }
}

test('reversed reverses string with valid input', () => {
  assert.strictEqual(app.reversed('pannekoek'), 'keokennap');
})
