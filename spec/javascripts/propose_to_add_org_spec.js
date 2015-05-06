describe("Proposed to add organisation link", function(){
    var add_org;
    beforeEach(function(){
        setFixtures('<a id = "add_org">Add Organisation</a>');
	    appendSetFixtures(sandbox({class:'nav-collapse'}));
	    appendSetFixtures('<li id="menuLogin" class="dropdown"></li>');
	    appendSetFixtures("<form id='loginForm'><div></div> </form>");
	    appendSetFixtures('<a id = "toggle_link">');
	    appendSetFixtures("<form id='registerForm'><div></div> </form>");
	    add_org = $("#add_org");
    });
    describe('when not logged in', function(){
        beforeEach(function(){add_org.attr('data-signed-in', 'false')}); 
	it('click propagation is stopped', function(){
	    add_org.click();
	    expect('click').toHaveBeenStoppedOn(add_org);
	})
    });
});
