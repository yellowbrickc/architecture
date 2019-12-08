const domainEvents = require('./index');
const recursive = require('recursive-readdir');

describe('When using the exported domain events', () => {
  let jsonSchemas = null;
  const keys = Object.keys(domainEvents);

  beforeAll(() => recursive('./json-schema', ['event.json', '*.pdf'])
    .then((files) => {
      jsonSchemas = files;
    }));

  it('the list of domain events should contain all json-schemas', () => {
    expect(jsonSchemas.length).toEqual(keys.length);
  });

  it('should expose all json schemas with their correct name', () => {
    jsonSchemas.forEach((file) => {
      const fullPath = `./${file}`;
      const json = require(fullPath); // eslint-disable-line global-require
      const id = json.id;

      const parts = id.split('/');
      const eventName = parts[1].replace('.json', '');
      expect(keys.indexOf(eventName)).toBeGreaterThan(-1);
    });
  });
});
