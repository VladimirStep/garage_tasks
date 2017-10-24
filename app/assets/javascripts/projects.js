$(document).on("turbolinks:load", function(){
    $('.new-task form').each(function () {
        $(this).validate({
            submitHandler: function(form){
                $(form).trigger('submit.rails');
                $('input.task-name', form).val('');
            }
        });
        $(this).focusout(function(){
            $('input.task-name', $(this)).val('');
            $(this).validate().resetForm();
        });
    });
});