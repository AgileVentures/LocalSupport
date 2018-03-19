describe('gem bootstrap_sortable_rails', function() {
    var header;
    beforeEach(function() {
        setFixtures('<table class="table table-responsive table-hover sortable"><thead><tr><th class="down sorted" data-sortcolumn="0" data-sortkey="0-0">Name</th></tr></thead><tbody>')
        appendSetFixtures('<tr><td id="1" data-value="Harrow Baptist Church"><a href="/organisations/1">Harrow Baptist Church</td></tr>')
        appendSetFixtures('<tr><td id="2" data-value="Human Touch Worldwide"><a href="/organisations/1">Human Touch Worldwide</td></tr>')
        appendSetFixtures('</tbody></table>')
        header = $('th');
    });
    describe('when clicking on the tableheader', function() {
        it('sorts A-Z', function() {
            expect($('td').first()).toHaveText('Harrow Baptist Church');
        });
        xit('sorts Z-A', function() {
            header.click();
            expect($('td').first()).toHaveText('Human Touch Worldwide')
        });
        it('inserts an arrow after click', function() {
            header.click();
            expect(header.find('span')).toHaveClass('arrow');
        });
    });
});

