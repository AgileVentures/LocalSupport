describe('gem bootstrap_sortable_rails', function() {
    var header;
    beforeEach(function() {
        setFixtures('<table class="sortable"><thead><tr><th data-sortkey="0">Name</th></tr></thead>' +
            '<tbody><tr><td data-value="Harrow Baptist Church"><a href="/organisations/1">Harrow Baptist Church</td></tr>' +
            '<tr><td data-value="Human Touch Worldwide"><a href="/organisations/1">Human Touch Worldwide</td></tr></tbody></table>');
        header = $('th');
    });
    describe('when clicking on the tableheader', function() {
        it('sorts A-Z then Z-A', function() {
            header.click();
            expect($('td').first()).toHaveText('Harrow Baptist Church');
            header.click();
            expect($('td').first()).toHaveText('Human Touch Worldwide')
        });
        it('inserts an arrow after click', function() {
            header.click();
            expect(header.find('span')).toHaveClass('arrow');
        });
    });
});

