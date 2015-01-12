var $ = require('vendor/jquery');

describe('stuff', function(){
  it('should set the body', function(){
    spyOn($.fn, 'html');
    var stuff = require('stuff');
    expect($.fn.html).toHaveBeenCalledWith('hello');
  });

});
