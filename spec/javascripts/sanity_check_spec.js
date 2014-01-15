describe('Jasmine sanity check', function() {
    it('works', function() { expect(true).toBe(true); });
});

describe('what am i doing', function() {
    beforeEach(function() {
        loadFixtures('TIMO_signed_out.html');
    });
    it('My fixture should load', function() {
        expect($('#TIMO')).toBe($('#TIMO'));
    });
    it('I should spy on fn TIMO', function() {
        var spyEvent = spyOnEvent($('#TIMO'), 'click');
//        $('#TIMO').click();
        expect('click').toHaveBeenTriggeredOn($('#TIMO'))
    });
});