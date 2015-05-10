describe("Proposed to add organisation link", function(){
    var add_org;
    beforeEach(function(){
        setFixtures('<a id = "add_org">Add Organisation</a>');
        appendSetFixtures(sandbox({class:'nav-collapse'}));
        appendSetFixtures('<li id="menuLogin" class="dropdown"></li>');
        appendSetFixtures("<form id='loginForm'><div></div> </form>");
        appendSetFixtures('<a id = "toggle_link">');
        appendSetFixtures("<form id='registerForm'><div></div> </form>");
        nav  = $('.nav-collapse');
        menu = $('#menuLogin');
        toggle = $('#toggle_link');
        register = $('#registerForm');
        add_org = $("#add_org");
        spyCollapse = spyOn($.fn, 'collapse').and.callThrough();
        spyOnEvent(nav, 'show');
        spyOnEvent(toggle, "click");
        spyOnEvent(add_org, 'click');
        add_org.PTAO();
    });
    describe('when not logged in', function(){
        beforeEach(function(){add_org.attr('data-signed_in', 'false')}); 
        it('click propagation is stopped', function(){
            add_org.click();
            expect('click').toHaveBeenStoppedOn(add_org);
        });
        describe('when login menu is closed and add_org is clicked', function() {
            beforeEach(function() { add_org.click() });
            it('$.fn.add_org will call collapse("show")', function() {
                expect(spyCollapse).toHaveBeenCalledWith('show');
            });
            it("toggle will have 'click' event", function(){
                expect('click').toHaveBeenTriggeredOn(toggle);
            });
            it('nav will have "show" event', function() {
                expect('show').toHaveBeenTriggeredOn(nav)
            });
            it('nav changes attributes', function() {
                expect(nav).toHaveClass('in');
            });
            it('menu changes attributes', function() {
                expect(menu).toHaveClass('open');
            });
            it('loginForm contains hidden input field proposed_org', function(){
                expect($("form#registerForm input[name=user\\[proposed_org\\]]").val()).toBeDefined();
            });

        });
      });
});
