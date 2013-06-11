// Prerequisite: template.js
// Prerequisite: jquery

function respondToFormState() {
	var enoughMembers = $('input.memberID').filter(':checked').length >= 2;
	if (enoughMembers) {
		$('#create-feedback').hide();
	} else {
		$('#create-feedback').show();
	}
	var fedID = $('#id').val();
	var validID = /.+/.test(fedID);
	var disable = !(validID && enoughMembers);
	var matchExisting = false;

	// test that fedID not equal any existing id
	$('input.memberID').each(function() {
		if (fedID == $(this).attr('value')) {
			disable = true;
			matchExisting = true;
			return false;
		}
	});
	var recurseMessage = $('#recurse-message');
	if (matchExisting) {
		recurseMessage.show();
	} else {
		recurseMessage.hide();
	}
	$('input#create').prop('disabled', disable);
}

/**
 * Calls another function with a delay of 0 msec. (Workaround for annoying
 * browser behavior.)
 */
function timeoutRespond() {
	setTimeout('respondToFormState()', 0);
}

addLoad(function() {
	respondToFormState();
	$('input.memberID').on('change', respondToFormState);
	$("input[name='type']").on('change', respondToFormState);
	$('#id').off().on('keydown paste cut', timeoutRespond);
});