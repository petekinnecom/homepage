var stuff = require('stuff');

describe('stuff', function(){
  it('should fail', function(){
    expect(stuff).toBe('thing module');
  });

  it('should pass', function(){
    expect(stuff).toBe('stuff module');
  });
});
