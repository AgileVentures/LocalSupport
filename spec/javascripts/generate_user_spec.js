describe('Generate User operation', function() {
    var generate_user;
    beforeEach(function() {
        setFixtures('<tr id="362"><td style="text-align: center;"><a class="generate_user btn btn-default" rel="nofollow" data-method="post" href="/orphans?id=362">+</a></td><td class="response"></td></tr>');
        generate_user = $('.generate_user');
        spyOn($, "ajax");
        generate_user.generate_user();
    });
    it('should make an ajax request when clicked',function(){
        generate_user.click();
        expect($.ajax.mostRecentCall.args[0]["url"]).toEqual("/orphans");
    });

});