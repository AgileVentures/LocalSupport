describe('Generate User operation', function() {
    var generate_user, ajax;
    beforeEach(function() {
        setFixtures('<tr id="362"><td><a class="generate_user"></a></td><td class="response"><span></span></td></tr>');
        generate_user = $('.generate_user');

        generate_user.generate_user();
    });
    it('makes an ajax request when clicked',function(){
        spyOn($, "ajax");
        generate_user.click();
        var args = $.ajax.calls.mostRecent();
        expect(args.data).toEqual({ id: '362' });
        expect(args.dataType).toEqual('json');
        expect(args.type).toEqual('POST');
        expect(args.url).toEqual('/orphans')
    });
    it('inserts text and removes button if successful', function() {
        spyOn( $, "ajax" ).and.callFake(function (params) { 
          params.success("hi");
        });
        generate_user.click();
        expect($('#362 span')).toHaveText('hi');
        expect($('#362 .response a').length).toBe(0)
    });
    it('inserts failure message if unsuccessful', function() {
        spyOn( $, "ajax" ).and.callFake(function (params) { 
          params.error("error");
        });
        generate_user.click();
        expect($('#362 span')).toHaveText('error')
    });
});