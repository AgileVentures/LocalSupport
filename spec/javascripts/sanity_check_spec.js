// Lesson: You can't spy on a $(css) jQuery DOM selector, it's not an object, it's a return value.
// So instead of spying on $('.nav-collpase'), I spy on $.fn .
// http://stackoverflow.com/a/6198122/2197402

describe('Jasmine sanity check', function() {
    it('works', function() { expect(true).toBe(true); });
});

describe('what am i doing', function() {
    var timo, nav, menu;

    beforeEach(function() {

//        loadFixtures('TIMO_full.html');
        jasmine.getFixtures().load('TIMO_header.html');
        jasmine.getFixtures().appendLoad('TIMO_body.html');
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