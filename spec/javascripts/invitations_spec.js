describe('Invitations toolbar script', function () {
    var invite_users, select_all;
    beforeEach(function () {
        setFixtures('<div id="resend_invitation" data-resend_invitation="false" style="display: none;"></div>');
        appendSetFixtures('<button id="invite_users"></button>');
        appendSetFixtures('<button id="select_all" class="btn" data-toggle="button"></button>');
        appendSetFixtures('<tr id="1"><td class="response"><input type="checkbox" data-id="1" data-email="a@org.org" checked /></td></tr>');
        appendSetFixtures('<tr id="2"><td class="response"><input type="checkbox" data-id="2" data-email="b@org.org" /></td></tr>');
        appendSetFixtures('<tr id="3"><td class="response"><input type="checkbox" data-id="3" data-email="c@org.org" checked /></td></tr>');
        appendSetFixtures('<tr id="4"><td class="response"><input type="checkbox" data-id="4" data-email="d@org.org" /></td></tr>');
        invite_users = $('#invite_users');
        select_all = $('#select_all');
        invite_users.invite_users();
        select_all.select_all();
    });
    describe('Invite Users button', function () {
        it('reads a boolean from a hidden field when clicked', function() {
            var parser = spyOn($, 'parseJSON');
            invite_users.click();
            expect(parser).toHaveBeenCalledWith('false');
        });
        it('makes an ajax request when clicked', function () {
            spyOn($, "ajax");
            invite_users.click();
            expect($.ajax.calls.count()).toBe(1);
            var args = $.ajax.calls.mostRecent().args[0];
            expect(args.data).toEqual('{"invite_list":{"1":"a@org.org","3":"c@org.org"},"resend_invitation":false}');
            expect(args.dataType).toBe('json');
            expect(args.contentType).toBe('application/json');
            expect(args.type).toBe('POST');
            expect(args.url).toBe('/invitations')
        });
        it('uses JSON stringify to format the array properly for Rails', function() {
            var stringify = spyOn(JSON, 'stringify');
            invite_users.click();
            expect(stringify).toHaveBeenCalledWith({ invite_list : { 1 : 'a@org.org', 3 : 'c@org.org' }, resend_invitation : false });
        });
        it('overwrites checkbox with server response', function () {
            spyOn($, "ajax").and.callFake(function (params) { 
              params.success({
                  1: 'I have returned.',
                  3: 'Galahoslos?'
              });
            });
            invite_users.click();
            expect($('#1 .response')).toHaveHtml('I have returned.');
            expect($('#2 .response')).toHaveHtml('<input type="checkbox" data-id="2" data-email="b@org.org" />');
            expect($('#3 .response')).toHaveHtml('Galahoslos?');
            expect($('#4 .response')).toHaveHtml('<input type="checkbox" data-id="4" data-email="d@org.org" />');
        });
        it('color codes the server responses', function () {
            spyOn($, "ajax").and.callFake(function (params) { 
                params.success({
                    1: 'Error: Drop your weapon! You have 15 seconds to comply.',
                    3: 'Error: Five... Four... Three. Two. One! (fires phase disruptor)'
                });
            });
            invite_users.click();
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
