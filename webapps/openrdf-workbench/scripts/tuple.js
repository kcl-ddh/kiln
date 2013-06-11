// Prerequisite: paging.js

function correctLimit() {
	var limit = getParameter('limit');
	if ('' == limit) {
		limit = 0;
	}
	
	document.getElementById('limit').value = limit;
}
			
addLoad(
function() {
	correctLimit();
	correctButtons();
	var limit = getLimit();
			    
    // Modify title to reflect total_result_count cookie
    if (limit > 0) {
    	var h1 = document.getElementById('title_heading');
    	var oldh1 = h1.innerHTML;
    	var h1start = /^.*\(/
        var total_result_count = getTotalResultCount();			    
    	var have_total_count = (total_result_count > 0);
		var offset = getOffset();
		var first = offset + 1;
		var last = offset + limit;
		last = have_total_count ? Math.min(total_result_count, last) : last;
		var newHTML = h1start.exec(oldh1) + first + '-' + last;
		if (have_total_count) { 
			newHTML = newHTML + ' of ' + total_result_count;
		}

		newHTML = newHTML + ')';
		h1.innerHTML = newHTML;
	}
    hideExternalLinksAndSetHoverEvent();
    setShowDataTypesCheckboxAndSetChangeEvent();
});