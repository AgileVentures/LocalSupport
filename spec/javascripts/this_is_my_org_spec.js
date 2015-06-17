// Lesson: You can't spy on a $(css) jQuery DOM selector, it's not an object, it's a return value.
// So instead of spying on $('.nav-collpase'), I spy on $.fn .
// http://stackoverflow.com/a/6198122/2197402

// Lesson: Event spying requires knowing the actual event triggered when the function is called.
// Calling collapse will trigger the events 'show' or 'hide'
// https://github.com/seyhunak/twitter-bootstrap-rails/blob/master/app/assets/javascripts/twitter/bootstrap/bootstrap-collapse.js#L69

describe('This is my Organisation button', function() {
    var timo, nav, menu, spyCollapse;
    beforeEach(function() {
        setFixtures('<a id="TIMO">This is my organisation</a>');
        appendSetFixtures(sandbox({class:'nav-collapse'}));
        appendSetFixtures('<li id="menuLogin" class="dropdown"></li>');
        appendSetFixtures("<form id='loginForm'><div></div> </form>");
        appendSetFixtures("<input id='user_organisation_id' name='user[organisation_id]' type='hidden' value='642' />");
        appendSetFixtures('<a id = "toggle_link">');
        appendSetFixtures("<form id='registerForm'><div></div> </form>");
        timo = $('#TIMO');
        nav  = $('.nav-collapse');
        menu = $('#menuLogin');
        toggle = $('#toggle_link');
        register = $('#registerForm');
        spyCollapse = spyOn($.fn, 'collapse').and.callThrough();
        spyOnEvent(nav, 'show');
        spyOnEvent(timo, 'click');
        spyOnEvent(toggle, "click");
        timo.TIMO();
    });
    describe('when not logged in', function() {
        beforeEach(function() { timo.attr('data-signed_in', 'false') });
        it('click propagation should be stopped', function() {
            timo.click();
            expect('click').toHaveBeenStoppedOn(timo);
        });
        describe('when login menu is closed and TIMO is clicked', function() {
            beforeEach(function() { timo.click() });
            it('$.fn.TIMO will call collapse("show")', function() {
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
            it('loginForm contains hidden input field with org id', function(){
                expect($("form#loginForm input[name=pending_organisation_id]").val()).toEqual('642')
            });
            it('registerForm contains hidden input field with org id', function(){
                expect($("form#registerForm input[name=user\\[pending_organisation_id\\]]").val()).toEqual('642')
            });
        });
        describe('when login menu is open and TIMO is clicked', function() {
            beforeEach(function() {
                nav.addClass('in');
                menu.addClass('open');
                register.addClass('in');
                timo.click()
            });
            it('$.fn.TIMO will not call collapse("show")', function() {
                expect(spyCollapse).not.toHaveBeenCalledWith('show');
            });
            it('nav will not have "show" event', function() {
                expect('show').not.toHaveBeenTriggeredOn(nav)
            });
            it('toggle will not have "click" event', function(){
                expect('click').not.toHaveBeenTriggeredOn(toggle);
            })
            it('nav does not change attributes', function() {
                expect(nav).toHaveClass('in');
            });
            it('menu does not change attributes', function() {
                expect(menu).toHaveClass('open');
            });
        });
    });
    describe('when logged in', function() {
        it('should return true, allowing default behavior', function() {
            timo.attr('data-signed_in', 'true');
            timo.click();
            expect('click').not.toHaveBeenStoppedOn(timo);
        });
    });
});

