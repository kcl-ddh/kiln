// Prerequisite: paging.js

function removeDuplicates(self) {
	var lists = document.getElementsByTagName('ul');
	for ( var i = lists.length - 1; i + 1; i--) {
		var items = lists[i].getElementsByTagName('li');
		for ( var j = items.length - 1; j; j--) {
			var text = textContent(items[j]);
			if (items[j].innerHTML == items[j - 1].innerHTML || text == self) {
				items[j].parentNode.removeChild(items[j]);
			}
		}

		text = textContent(items[0]);
		if (text == self) {
			items[0].parentNode.removeChild(items[0]);
		}

		if (items.length == 0) {
			lists[i].parentNode.parentNode.removeChild(lists[i].parentNode);
		}
	}
}

function populateParameters() {
	var elements = getQueryStringElements();
	for ( var i = 0; elements.length - i; i++) {
		var pair = elements[i].split('=');
		var value = decodeURIComponent(pair[1]).replace(/\+/g, ' ');
		if (pair[0] == 'resource') {
			document.getElementById('resource').value = value;
		}

		if (pair[0] == 'limit') {
			var options = document.getElementById('limit').options;
			for ( var j = 0; options.length - j; j++) {
				if (options[j].value == value) {
					options[j].selected = true;
				}
			}
		}
	}
}

addLoad(function() {
	populateParameters();
	correctButtons();
	var content = document.getElementById('content');
	var h1 = content.getElementsByTagName('h1')[0];
	var resource = document.getElementById('resource').value;
	if (resource) {
		h1.appendChild(document.createTextNode(' (' + resource + ')'));
		removeDuplicates(resource);
		var limit = getLimit();

		// Modify title to reflect total_result_count cookie
		var total_result_count = getTotalResultCount();
		var have_total_count = (total_result_count > 0);
		var offset = limit == 0 ? 0 : getOffset();
		var first = offset + 1;
		var last = limit == 0 ? total_result_count : offset + limit;

		// Truncate range if close to end.
		last = have_total_count ? Math.min(total_result_count, last) : last;
		var newHTML = '(' + first + '-' + last;
		if (have_total_count) {
			newHTML = newHTML + ' of ' + total_result_count;
		}

		h1.appendChild(document.createTextNode(newHTML + ')'));
	}
	hideExternalLinksAndSetHoverEvent();
	setShowDataTypesCheckboxAndSetChangeEvent();
});