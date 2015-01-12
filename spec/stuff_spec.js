var $ = require('jquery');

describe('stuff', function(){
  it('should set the body', function(){
    spyOn($.fn, 'html');
    var stuff = require('app/stuff/stuff');
    expect($.fn.html).toHaveBeenCalledWith('hello');
  });

});
