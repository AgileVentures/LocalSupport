describe('gmaps config', function(){
 it('gets called', function(){
  handler = {
   buildMap: function(){} 
  }  
  g(handler)();
  expect(handler.buildMap).toHaveBeenCalled();
 });
  
 }
)
