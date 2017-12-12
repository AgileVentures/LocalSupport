# Contribution Workflow using Pivotal Tracker

<p><img vertical-align="middle" align="left"  src="images/pt_none_button.png"> 
<br/>
<br/>
New tickets have no status set and can be found in the Icebox column. All new tickets must be voted upon to estimate the effort required and complexity of the ticket.  Voting should take place using `/voter` within the appropriate slack channel.
</p>

<br clear="all" />
<p><img vertical-align="middle" align="left" src="images/pt_down_arrow_small.png">
<br/>
<br/>  
Once voted on and an estimate assigned the ticket is available in the Backlog column to be assigned to a volunteer.   Once allocated the ticket should be started and is automatically moved to the Current Interation column.
</p>
<br clear="all" />

<p><img vertical-align="middle" align="left" src="images/pt_start_button.png"> 
Whilst working on the ticket the assigned volunteer(s) work in their own fork of the repository and create feature/bug branches that include the Pivotal Tracker ID in the branch name. Additonally a pull-request should be created to share the changes to the code with other volunteers so they can easily comment and help out where necessary.  A hyperlink to the  Pivotal Tracker ticket should be included in the pull-request's description. Additonal information/progress/issues relating to the ticket should be also added to the ticket as a comment. Remember to include sufficient tests to support the ticket.
</p>

<br clear="all" />
<p><img vertical-align="middle" align="left" src="images/pt_down_arrow_small.png"></p>
<br clear="all" />

<p>
<img vertical-align="middle" align="left" src="images/pt_finish_button.png">
 <br/>
<br/>
Once work on the ticket is completed a final commit with a commit message in the following format should be submitted:
<pre>
makes Capybara check for visibility more robust [Finishes #112900047]
</pre> 
</p>

<br clear="all" />
<p><img vertical-align="middle" align="left" src="images/pt_down_arrow_small.png">
<br/>
<br/>
This will Finish the relevant Pivotal Tracker ticket when the pull-request is merged.
</p>
<br clear="all" />

<p>
<img vertical-align="middle" align="left" src="images/pt_deliver_button.png">
<br/>
<br/>
<br/>
Once merged and tested in staging the changes are pushed (delivered) to the production site ready for the client to Accept or Reject.
</p>

<br clear="all" />
<p><img vertical-align="middle" align="left" src="images/pt_down_arrow_split.png"></p>
<br clear="all" />

<img src="images/pt_accept_reject_buttons.png">
