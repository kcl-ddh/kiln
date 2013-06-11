// Prerequisite: template.js

function deleteQuery(savedBy, name, urn) {
	var currentUser = getCookie("server-user");
	if ((!savedBy || currentUser == savedBy)) {
		if (confirm("'"
				+ name
				+ "' will no longer be accessible, even using your browser's history. "
				+ "Do you really wish to delete it?")) {
			document.forms[urn].submit();
		}
	} else {
		alert("'" + name + "' was saved by user '" + savedBy + "'.\nUser '"
				+ currentUser + "' is not allowed do delete it.");
	}
}

function toggle(urn) {
	var metadata = document.getElementById(urn + '-metadata');
	var text = document.getElementById(urn + '-text');
	metadata.style.display = (metadata.style.display == 'none') ? '' : 'none';
	text.style.display = (text.style.display == 'none') ? '' : 'none';
	var toggle = document.getElementById(urn + '-toggle');
	var attr = 'value';
	var show = 'Show';
	var text = toggle.getAttribute(attr) == show ? 'Hide' : show;
	toggle.setAttribute(attr, text);
}

addLoad(function() {
	var queries = document.getElementsByTagName('pre');
	for (i = 0; i < queries.length; i++) {
		queries[i].innerHTML = queries[i].innerHTML.trim();
	}

	var editForms = document.getElementsByName('edit-query');
	for ( var i = 0; i < editForms.length; i++) {
		var form = editForms[i];
		var queryText = form.getElementsByTagName('input')[2];
		queryText.setAttribute('value', queryText.getAttribute('value').trim());
	}
});