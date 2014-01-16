describe('Jasmine sanity check', function() {
    it('works', function() { expect(true).toBe(true); });
});

describe('what am i doing', function() {
    var timo, nav, menu;

    beforeEach(function() {
        jasmine.getFixtures().load('TIMO_body.html');
        jasmine.getFixtures().load('TIMO_header.html');
//        jasmine.getFixtures().set('<div class="nav-collapse collapse" style="height: 0px;"><li id="menuLogin" class="dropdown"></li></div>');
        timo = $('#TIMO');
        nav  = $('.nav-collapse');
        menu = $('#menuLogin');
        timo.TIMO();
    });

    it('should have a #TIMO matcher', function() {
        expect(timo.length).not.toBe(0);
    });
    it('should have a nav collapse matcher that is visible', function() {
        expect(nav.length).not.toBe(0);
        expect(nav).toHaveClass('nav-collapse');
        expect(nav).toHaveClass('collapse');
        expect(nav).not.toHaveClass('in');
    });
    it('should have a menu login matcher that is NOT visible', function() {
        expect(menu.length).not.toBe(0);
        expect(menu).toHaveClass('dropdown');
        expect(menu).not.toHaveClass('open');
    });
    it('should call collapse if nav is hidden', function() {
        spy = spyOn($.fn, 'collapse');
        timo.click();
        expect(spy).toHaveBeenCalledWith('show');
    });
    it('should expand nav if nav is hidden', function() {
        expect(nav).toHaveAttr('style', 'height: 0px;');
        timo.click();
        expect(nav).not.toHaveAttr('style', 'height: 0px;');
    });
    it('I should spy on fn TIMO', function() {
        // https://github.com/velesin/jasmine-jquery#event-spies
        var spyEvent = spyOnEvent(timo, 'click');
        timo.click();
        expect('click').toHaveBeenTriggeredOn(timo);
        // WHY DOESN'T THIS WORK?? It's pure copy-pasta.
//        expect(spyEvent).toHaveBeenTriggered()
    });
});