describe('Organization Reports - without users page', function () {
    var generate_users, select_all;
    beforeEach(function () {
        setFixtures('<button id="generate_users"></button>');
        appendSetFixtures('<button id="select_all" class="btn" data-toggle="button"></button>');
        appendSetFixtures('<tr id="1"><td class="response"><input type="checkbox" value="1" checked /></td></tr>');
        appendSetFixtures('<tr id="2"><td class="response"><input type="checkbox" value="2" /></td></tr>');
        appendSetFixtures('<tr id="3"><td class="response"><input type="checkbox" value="3" checked /></td></tr>');
        appendSetFixtures('<tr id="4"><td class="response"><input type="checkbox" value="4" /></td></tr>');
        generate_users = $('#generate_users');
        select_all = $('#select_all');
        generate_users.generate_users();
        select_all.select_all();
    });
    describe('Generate Users button', function () {
        it('makes an ajax request when clicked', function () {
            spyOn($, "ajax");
            generate_users.click();
            expect($.ajax.calls.count()).toBe(1);
            var args = $.ajax.calls.mostRecent().args[0];
            expect(args.data).toEqual({ organizations: ['1', '3'] });
            expect(args.dataType).toBe('json');
            expect(args.type).toBe('POST');
            expect(args.url).toBe('/organization_reports/without_users')
        });
        it('overwrites checkbox with server response', function () {
            spyOn($, "ajax").and.callFake(function (params) { 
              params.success({
                  1: 'I have returned.',
                  3: 'Galahoslos?'
              });
            });
            generate_users.click();
            expect($('#1 .response')).toHaveHtml('I have returned.');
            expect($('#2 .response')).toHaveHtml('<input type="checkbox" value="2" />');
            expect($('#3 .response')).toHaveHtml('Galahoslos?');
            expect($('#4 .response')).toHaveHtml('<input type="checkbox" value="4" />');
        });
        it('color codes the server responses', function () {
            spyOn($, "ajax").and.callFake(function (params) { 
                params.success({
                    1: 'Error: Drop your weapon! You have 15 seconds to comply.',
                    3: 'Error: Five... Four... Three. Two. One! (fires phase disruptor)'
                });
            });
            generate_users.click();
            expect($('#1')).toHaveClass('alert');
            expect($('#2')).not.toHaveClass('alert');
            expect($('#3')).toHaveClass('alert');
            expect($('#4')).not.toHaveClass('alert');
        });
    });
    describe('Select All button', function () {
        it('toggles an extra class on click', function () {
            expect(select_all).not.toHaveClass('active');
            select_all.click();
            expect(select_all).toHaveClass('active');
            select_all.click();
            expect(select_all).not.toHaveClass('active');
        });
        it('selects all when made active', function () {
            var checks = $('input[type="checkbox"]');
            select_all.click();
            checks.each(function () {
                expect($(this)).toBeChecked();
            });
            select_all.click();
            checks.each(function () {
                expect($(this)).not.toBeChecked();
            });
        });
        it('deselects all when made inactive', function () {
            select_all.click();
        });
    });
});