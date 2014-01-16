describe('Jasmine sanity check', function() {
    it('works', function() { expect(true).toBe(true); });
});

describe('what am i doing', function() {
    var timo;
    beforeEach(function() {
        loadFixtures('TIMO_signed_out.html');
        timo = $('#TIMO');
        timo.TIMO();
    });

    it('My fixture should load', function() {
        expect(timo).toBe(timo);
    });
    it('I should spy on fn TIMO', function() {
        // https://github.com/velesin/jasmine-jquery#event-spies
        var spyEvent = spyOnEvent(timo, 'click');
//        $(timo).click();
        expect('click').toHaveBeenTriggeredOn(timo);
        // WHY DOESN'T THIS WORK?? It's pure copy-pasta.
//        expect(spyEvent).toHaveBeenTriggered()
    });
});