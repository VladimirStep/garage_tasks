$(document).on("turbolinks:load", function(){
    $('.new-task form').each(function () {
        var current_form = $(this);
        var input_task_field  = $('input.task-name', $(this));

        current_form.validate({
            onfocusout: false,
            submitHandler: function(form){
                $(form).trigger('submit.rails')
            }
        });

        input_task_field.focusout(function(){
            $(this).val('');
            current_form.validate().resetForm();
        });

        current_form.on('ajax:complete', function(){
            input_task_field.val('');
        });
    });
});