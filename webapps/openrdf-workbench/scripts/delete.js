// Prerequisite: template.js
// Prerequisite: jquery

/**
 * Invoked by the "Delete" button on the form in delete.xsl. Checks with the
 * DeleteServlet whether the given ID has been proxied, giving a chance to back
 * out if it is.
 */
function checkIsSafeToDelete() {
	var id = $('#id').val();
	var submitForm = false;
	$
			.ajax({
				dataType : 'json',
				url : 'delete',
				async : false,
				timeout : 5000,
				data : {
					checkSafe : id
				},
				error : function(jqXHR, textStatus, errorThrown) {
					if (textStatus == 'timeout') {
						feedback
								.text('The server seems unresponsive. Delete request not sent.');
					} else {
						feedback
								.text('There is a problem with the server. Delete request not sent. Error Type = '
										+ textStatus
										+ ', HTTP Status Text = "'
										+ errorThrown + '"');
					}
				},
				success : function(data) {
					submitForm = data.safe;
					if (!submitForm) {
						submitForm = confirm('WARNING: You are about to delete a repository that has been proxied by another repository!');
					}
				}
			});
	return submitForm;
}
