/**
 * Code for handling the creation and updating of a range slider for
 * use in forms.
 *
 * This code depends on jQuery, jQuery UI, and URI.js.
 */

/**
 * Updates the label of a slider.
 *
 * @param widget - The HTML element of the slider widget.
 * @param label - The HTML element of the slider label.
 * @param values - Array of two values to be put in the label.
 */
function update_slider_label(widget, label, values) {
    var prefix = widget.data("label-prefix") + " ",
        suffix = " " + widget.data("label-suffix");
    label.text(prefix + values[0] + " – " + values[1] + suffix);
}

/**
 * Creates the slider.
 *
 * @param widget - The HTML element to be used for the slider widget.
 * @param label - The HTML element to be used for the slider label.
 */
function setup_slider(widget, label) {
    widget.slider({
        range: true,
        min: widget.data("range-min"),
        max: widget.data("range-max"),
        values: [widget.data("value-min"), widget.data("value-max")],
        step: widget.data("step"),

        create: function() {
            update_slider_label($(this), label, $(this).slider('values'));
        },

        slide: function(event, ui) {
            update_slider_label($(this), label, ui.values);
        },

        stop: function(event, ui) {
            var params = URI.parseQuery(
                URI.parse(document.location.href).query);
            var field_name = $(this).data("field-name");
            params[field_name + "_start"] = ui.values[0];
            params[field_name + "_end"] = ui.values[1];
            document.location.href = "?" + URI.buildQuery(params);
        }
    });
}

/**
 * Handles form submission and setting the slider values.
 *
 * @param form - The HTML form element.
 * @param slider - The HTML element of the slider widget.
 * @param inputs - Array of input/@name values for inputs that are not
 *                 radio buttons or checkboxes.
 * @param checked_inputs - Array of input/@name values for radio
 *                         buttons and checkboxes.
 */
function prepare_form(form, slider, inputs=[], checked_inputs=[]) {
    var field_name = slider.data("field-name");
    var params = URI.parseQuery(URI.parse(document.location.href).query);
    if (params[field_name + "_start"]) {
        slider.data("value-min", params[field_name + "_start"]);
    }
    if (params[field_name + "_end"]) {
        slider.data("value-max", params[field_name + "_end"]);
    }
    form.on("submit", function(e) {
        e.preventDefault();
        for (i = 0; i < inputs.length; i++) {
            params[inputs[i]] = $("*[name=" + inputs[i] + ']').last().val();
        }
        for (i = 0; i < checked_inputs.length; i++) {
            var checked_values = [];
            $("*[name=" + checked_inputs[i] + ']:checked').each(
                function() { checked_values.push($(this).val()); }
            );
            params[checked_inputs[i]] = checked_values;
        }
        document.location.href = "?" + URI.buildQuery(params);
    });
}
