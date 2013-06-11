// Prerequisite: template.js

/**
 * Populate the query text area with the value of the URL query parameter, only
 * if it is present. If it is not present in the URL query, then looks for the
 * 'query' cookie, and sets it from that. (The cookie enables re-populating the
 * text field with the previous query when the user returns via the browser back
 * button.)
 */
function setQueryTextIfPresent() {
	var query = getParameterFromUrlOrCookie('query');
	if (query) {
		var ref = getParameterFromUrlOrCookie('ref');
		if (ref == 'id' || ref == 'hash') {
			getQueryTextFromServer(query, ref);
		} else {
			$('#query').val(query);
		}
	}
}

function getQueryTextFromServer(queryParam, refParam) {
	$.getJSON('query', {
		action : "get",
		query : queryParam,
		ref : refParam
	}, function(response) {
		if (response.queryText) {
			$('#query').val(response.queryText);
		}
	});
}

/**
 * Gets a parameter from the URL or the cookies, preferentially in that order.
 * 
 * @param param
 *            the name of the parameter
 * @returns the value of the given parameter, or something that evaluates as
 *          false, if the parameter was not found
 */
function getParameterFromUrlOrCookie(param) {
	var href = document.location.href;
	var elements = href.substring(href.indexOf('?') + 1).substring(
			href.indexOf(';') + 1).split(decodeURIComponent('%26'));
	var result = false;
	for ( var i = 0; elements.length - i; i++) {
		var pair = elements[i].split('=');
		var value = decodeURIComponent(pair[1]).replace(/\+/g, ' ');
		if (pair[0] == param) {
			result = value;
		}
	}
	if (!result) {
		result = getCookie(param);
	}
	return result;
}

/**
 * Global variable for holding the current query language.
 */
var currentQueryLn;

/**
 * Populate reasonable default name space declarations into the query text area.
 * The server has provided the declaration text in hidden elements.
 */
function loadNamespaces() {
	var query = document.getElementById('query');
	var queryLn = document.getElementById('queryLn').value;
	var namespaces = document.getElementById(queryLn + '-namespaces');
	var last = document.getElementById(currentQueryLn + '-namespaces');
	if (namespaces) {
		if (!query.value) {
			query.value = namespaces.innerText || namespaces.textContent;
			currentQueryLn = queryLn;
		}

		if (last) {
			var text = last.innerText || last.textContent;
			if (query.value == text) {
				query.value = namespaces.innerText || namespaces.textContent;
				currentQueryLn = queryLn;
			}
		}
	}
}

/**
 * After confirming with the user, clears the query text and loads the current
 * repository and query language name space declarations.
 */
function resetNamespaces() {
	if (confirm('Click OK to clear the current query text and replace it with the '
			+ document.getElementById('queryLn').value
			+ ' namespace declarations.')) {
		document.getElementById('query').value = '';
		loadNamespaces();
	}
}

/**
 * Add click handlers identifying the clicked element in a hidden 'action' form
 * field.
 */
function addClickHandlers() {
	addClickHandler('exec');
	addClickHandler('save');
}

/**
 * Add a click handler to the specified element, that will set the value on a
 * hidden 'action' form field.
 * 
 * @param id
 *            the id of the element to add the click handler to
 */
function addClickHandler(id) {
	document.getElementById(id).onclick = function() {
		document.getElementById('action').value = id;
	}
}

/**
 * Clear the save feedback field, and look at the contents of the query name
 * field. Disables the save button if the field doesn't satisfy a given regular
 * expression.
 */
function disableSaveIfNotValidName() {
	var name = document.getElementById('query-name');
	var save = document.getElementById('save');
	var valid = /^[- \w]{1,32}$/
	save.disabled = !valid.test(name.value);
	clearFeedback();
}

/**
 * Clear any contents of the save feedback field.
 */
function clearFeedback() {
	var feedback = document.getElementById('save-feedback');
	feedback.className = '';
	feedback.innerHTML = '';
}

/**
 * Calls another function with a delay of 200 msec, to give enough time after
 * the event for the document to have changed. (Workaround for annoying browser
 * behavior.)
 */
function handleNameChange() {
	setTimeout('disableSaveIfNotValidName()', 200);
}

/**
 * Add event handlers to the save name field to react to changes in it.
 */
function addSaveNameHandler() {
	var name = document.getElementById('query-name');
	name.onkeydown = handleNameChange;
	name.onpaste = handleNameChange;
	name.oncut = handleNameChange;
}

/**
 * Add event handlers to the query text area to react to changes in it.
 */
function addQueryChangeHandler() {
	var query = document.getElementById('query');
	query.onkeydown = clearFeedback;
	query.onpaste = clearFeedback;
	query.oncut = clearFeedback;
}

/**
 * Trim the query text area contents of any leading and/or trailing whitespace.
 */
function trimQuery() {
	var query = document.getElementById('query');
	query.value = query.value.trim();
}

/**
 * Detect if there is no current authenticated user, and if so, disable the
 * 'save privately' option.
 */
function disablePrivateSaveForAnonymous() {
	if ($('#selected-user>span').is('.disabled')) {
		var checkbox = document.getElementById('save-private');
		checkbox.setAttribute('value', false);
		checkbox.setAttribute('disabled', 'disabled');
	}
}

/**
 * Add code to be called when the document is loaded.
 */
addLoad(function() {
	setQueryTextIfPresent();
	loadNamespaces();
	trimQuery();
	addClickHandlers();
	addSaveNameHandler();
	addQueryChangeHandler();
	disablePrivateSaveForAnonymous();
});

/**
 * Utility method to create an XMLHTTPRequest object.
 * 
 * @returns a new object for sending an HTTP request
 */
function createXMLHttpRequest() {
	try {
		return new XMLHttpRequest();
	} catch (e) {
	}
	try {
		return new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
	}
	alert("XMLHttpRequest not supported");
	return null;
}

/**
 * Send a background HTTP request to save the query, and handle the response
 * asynchronously.
 * 
 * @param overwrite
 *            if true, add a URL parameter that tells the server we wish to
 *            overwrite any already saved query
 */
function ajaxSave(overwrite) {
	var feedback = $('#save-feedback');
	var handleSuccess = function(response) {
		if (response.accessible) {
			if (response.written) {
				feedback.removeClass().addClass('success');
				feedback.text('Query saved.');
			} else {
				if (response.existed) {
					if (confirm('Query name exists. Click OK to overwrite.')) {
						ajaxSave(true);
					} else {
						feedback.removeClass().addClass('error');
						feedback.text('Cancelled overwriting existing query.');
					}
				}
			}
		} else {
			feedback.removeClass().addClass('error');
			feedback
					.text('Repository was not accessible (check your permissions).');
		}
	};
	var handleError = function(jqXHR, textStatus, errorThrown) {
		feedback.removeClass().addClass('error');
		if (textStatus == 'timeout') {
			feedback
					.text('Timed out waiting for response. Uncertain if save occured.');
		} else {
			feedback.text('Save Request Failed: Error Type = ' + textStatus
					+ ', HTTP Status Text = "' + errorThrown + '"');
		}
	};
	var url = [];
	url[url.length] = 'query';
	if (overwrite) {
		if (document.all) {
			url[url.length] = ';';
		} else {
			url[url.length] = '?';
		}
		url[url.length] = 'overwrite=true&'
	}
	var href = url.join('');
	var form = $('form[action="query"]');
	$.ajax({
		url : href,
		type : 'POST',
		dataType : 'json',
		data : form.serialize(),
		timeout : 5000,
		error : handleError,
		success : handleSuccess
	});
}

function doSubmit() {
	var allowPageToSubmitForm = false;
	var save = ($('#action').val() == 'save');
	if (save) {
		ajaxSave(false);
	} else {
		var url = [];
		url[url.length] = 'query';
		if (document.all) {
			url[url.length] = ';';
		} else {
			url[url.length] = '?';
		}
		addParam(url, 'action');
		addParam(url, 'queryLn');
		addParam(url, 'query');
		addParam(url, 'limit');
		addParam(url, 'infer');
		var href = url.join('');
		var loc = document.location;
		var currentBaseLength = loc.href.length - loc.pathname.length
				- loc.search.length;
		var pathLength = href.length;
		var urlLength = pathLength + currentBaseLength;

		// Published Internet Explorer restrictions on URL length, which are the
		// most restrictive of the major browsers.
		if (pathLength > 2048 || urlLength > 2083) {
			alert("Due to its length, your query will be posted in the request body. "
					+ "It won't be possible to use a bookmark for the results page.");
			allowPageToSubmitForm = true;
		} else {
			// GET using the constructed URL, method exits here
			document.location.href = href;
		}
	}

	// Value returned to form submit event. If not true, prevents normal form
	// submission.
	return allowPageToSubmitForm;
}