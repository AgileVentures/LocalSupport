// Lesson: You can't spy on a $(css) jQuery DOM selector, it's not an object, it's a return value.
// So instead of spying on $('.nav-collpase'), I spy on $.fn .
// http://stackoverflow.com/a/6198122/2197402

// Lesson: Event spying requires knowing the actual event triggered when the function is called.
// Calling collapse will trigger the events 'show' or 'hide'
// https://github.com/seyhunak/twitter-bootstrap-rails/blob/master/app/assets/javascripts/twitter/bootstrap/bootstrap-collapse.js#L69

describe('This is my Organization button', function() {
    var timo, nav, menu, spy, spyEvent;
    beforeEach(function() {
        jasmine.getFixtures().load('TIMO_button.html');
        timo = $('#TIMO');
        timo.TIMO();
    });
    it('TIMO button should be available', function() {
        expect(timo.length).not.toBe(0);
    });
    describe('when not logged in', function() {
        beforeEach(function() {
            jasmine.getFixtures().appendSet(sandbox({class:'nav-collapse'}));
            jasmine.getFixtures().appendSet('<li id="menuLogin" class="dropdown"></li>');
            nav  = $('.nav-collapse');
            menu = $('#menuLogin');
            spy = spyOn($.fn, 'collapse').andCallThrough();
            spyEvent = spyOnEvent(nav, 'show');
        });
        it('nav bar and login menu should be available', function() {
            expect(nav.length).not.toBe(0);
            expect(menu.length).not.toBe(0);
        });
        describe('when login menu is closed and TIMO is clicked', function() {
            beforeEach(function() { timo.click() });
            it('$.fn.TIMO will call collapse("show")', function() {
                expect(spy).toHaveBeenCalledWith('show');
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
        });
        describe('when login menu is open and TIMO is clicked', function() {
            beforeEach(function() {
                nav.addClass('in');
                menu.addClass('open');
                timo.click()
            });
            it('$.fn.TIMO will not call collapse("show")', function() {
                expect(spy).not.toHaveBeenCalledWith('show');
            });
            it('nav will not have "show" event', function() {
                expect('show').not.toHaveBeenTriggeredOn(nav)
            });
            it('nav does not change attributes', function() {
                expect(nav).toHaveClass('in');
            });
            it('menu does not change attributes', function() {
                expect(menu).toHaveClass('open');
            });
        });
    });
});

