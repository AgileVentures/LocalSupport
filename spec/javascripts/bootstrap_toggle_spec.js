describe('bootstrap toggle', function() {
    var header;
    beforeEach(function() {
        setFixtures('<li class="dropdown" id="menuOrgs">'+
            '<a class="dropdown-toggle" href="#">Organisations</a>' +
            '<ul class="dropdown-menu">' +
            '    <li><a href="/organization_reports/without_users">Without Users</a></li>' +
            '</ul>' +
        '</li>');
        link = $('a')[0];
    });
    describe('when clicking on the parent', function() {
        it('pops up a list', function() {
            link.click();
            expect($('li#menuOrgs').first()).toHaveClass('open');
        });
    });
});

