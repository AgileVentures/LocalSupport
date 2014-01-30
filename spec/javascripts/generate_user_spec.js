describe('Generate User operation', function() {
    var generate_user, ajax;
    beforeEach(function() {
        setFixtures('<tr id="362"><td><a class="generate_user"></a></td><td class="response"><span></span></td></tr>');
        generate_user = $('.generate_user');
        spyOn($, "ajax");
        generate_user.generate_user();
    });
    it('makes an ajax request when clicked',function(){
        generate_user.click();
        var args = $.ajax.mostRecentCall.args[0];
        expect(args.data).toEqual({ id: '362' });
        expect(args.dataType).toEqual('json');
        expect(args.type).toEqual('POST');
        expect(args.url).toEqual('/orphans')
    });
//    it('inserts text if successful', function() {
//        ajax.andCallFake(function(options) {
//            options.success('hi');
//        });
//        expect($('#362 span')).toHaveText('hi')
//    })
});