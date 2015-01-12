describe('thing', function(){
  // Bummer boilerplate
  var thing;

  it('loads module', function(done){
    require(['thing'], function(arg){
      thing = arg;
      expect(thing).toBeTruthy();
      done();
    });
  });
  // END Bummer boilerplate

  it('has access to thing', function(){
    expect(thing).toBe(3);
  });
});
