var thing = require('../assets/javascripts/stuff');

describe('thing', function(){
  it('should fail', function(){
    expect(thing).toBe('thing module');
  });

  it('should pass', function(){
    expect(thing).toBe('stuff module');
  });
});
