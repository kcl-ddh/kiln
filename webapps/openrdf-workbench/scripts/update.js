// Prerequisite: template.js

function populateParameters() {
	var elements = getQueryStringElements();
	for ( var i = 0; elements.length - i; i++) {
		var pair = elements[i].split('=');
		var value = decodeURIComponent(pair[1]).replace(/\+/g, ' ');
		var q = document.getElementById('update');
		if (pair[0] == 'update')
			if (!q.value) {
				q.value = value;
			}
	}
}

var currentqueryLn = 'SPARQL';

function loadNamespaces() {
	var update = document.getElementById('update');
	var queryLn = 'SPARQL';
	var namespaces = document.getElementById(queryLn + '-namespaces');
	var last = document.getElementById(currentqueryLn + '-namespaces');
	if (namespaces) {
		if (!update.value) {
			update.value = namespaces.innerText || namespaces.textContent;
			currentqueryLn = queryLn;
		}
		if (last) {
			var text = last.innerText || last.textContent;
			if (update.value == text) {
				update.value = namespaces.innerText || namespaces.textContent;
				currentqueryLn = queryLn;
			}
		}
	}
}

addLoad(function() {
	populateParameters();
	loadNamespaces();
});

/* MSIE6 does not like xslt w/ this updatestring, so we use url parameters. */
function doSubmit() {
	if (document.getElementById('update').value.length >= 1000) {
		// some functionality will not work as expected on result pages
		return true;
	} else { // safe to use in request-URI
		var url = [];
		url[url.length] = 'update';
		if (document.all) {
			url[url.length] = ';';
		} else {
			url[url.length] = '?';
		}
		addParam(url, 'queryLn');
		addParam(url, 'update');
		addParam(url, 'limit');
		addParam(url, 'infer');
		url[url.length - 1] = '';
		document.location.href = url.join('');
		return false;
	}
}